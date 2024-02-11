# Deploy do Cluster Kubernetes na Oracle Cloud Infrastructure

1. Crie uma `API key`

- Entre no seu perfil, acesse a aba [API Keys](https://cloud.oracle.com/identity/domains/my-profile/api-keys) e clique em `Add API Key`.

2. Selecione `Generate API key pair`, faça o download da chave privada. Em seguida, clique em `Add`.

3. Após o download, mova a chave para o diretório `~/.oci/` e renomeie para `oci_api_key.pem`.

```
mv ~/Downloads/<nome_do_arquivo>.pem ~/.oci/oci_api_key.pem
```

4. Corrija as permissões da chave privada:

```
oci setup repair-file-permissions --file ~/.oci/oci_api_key.pem
```

5. Copie o texto que apareceu na página de criação da `API KEY` para o arquivo `~/.oci/config`. Não se esqueça de substituir o valor do compo `key_file` pelo caminho da chave privada `~/.oci/oci_api_key.pem`, conforme exemplo abaixo.

```
vim ~/.oci/config
```

Você pode personalizar o nome do profile alterando o valor [DEFAULT] para o nome desejado. (Leia o passo 3 antes de alterar o nome do profile)

```
[DEFAULT]
user=ocid1.user.oc1..xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
fingerprint=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
tenancy=ocid1.tenancy.oc1..xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
region=xxxxxxxx
key_file=~/.oci/oci_api_key.pem
```

6. Crie a chave `ssh`.

```bash
ssh-keygen -t rsa -b 4096 -f ssh/id_rsa
```

7. Adicione os valores ao arquivo `env.sh`, para exportar todas as variáveis necessárias para a autenticação do terraform.

```
export TF_VAR_tenancy_ocid=<your tenancy ocid>
export TF_VAR_user_ocid=<your user ocid>
export TF_VAR_fingerprint=<your fingerprint>
export TF_VAR_private_key_path=~/.oci/oci_api_key.pem
export TF_VAR_ssh_public_key=$(cat ssh/id_rsa.pub)
export TF_VAR_ssh_private_key=$(cat ssh/id_rsa)
# Optional if you want to use a different profile name change the value below
export TF_VAR_oci_profile="DEFAULT"
```

Agora rode o script para exportar as variáveis:

```
source env.sh
```

3. Aplicar os arquivos na pasta `terraform`.

```bash
tofu init
tofu apply
```

* Caso você tenha utilizado um profile diferente de `DEFAULT`, basta adicionar o profile no arquivo `~/.kube/config`.

```
vim ~/.kube/config
```

```
# conteúdo anterior
users:
- name: <user>
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      command: oci
      args:
      - ce
      - cluster
      - generate-token
      - --cluster-id
      - <cluster OCID>
      - --region
      - sa-saopaulo-1
      - --profile               # ADICIONE ESSA LINHA
      - <profile_name>          # ADICIONE ESSA LINHA

```

4. Acesse o cluster:

```bash
kubectl get nodes
```

# Deploy da aplicação

1. Criando os namespaces:

```bash
kubectl apply -f manifests/namespace.yaml
```

2. Instalando o Ingress Nginx Controller:

```bash
helm upgrade --install ingress-nginx ingress-nginx \
        --repo https://kubernetes.github.io/ingress-nginx \
        --namespace ingress-nginx \
        --set controller.service.annotations."oci\.oraclecloud\.com/load-balancer-type"="nlb" \
        --set controller.service.annotations."oci-network-load-balancer\.oraclecloud\.com/security-list-management-mode"="All" \
        --set controller.service.type="NodePort" \
        --set controller.service.nodePorts.http=30080 \
        --set controller.service.nodePorts.https=30443
```

Utilize o comando abaixo para garantir que o Ingress Nginx Controller foi instalado corretamente antes de prosseguir.

```bash
kubectl wait --namespace ingress-nginx \
        --for=condition=ready pod \
        --selector=app.kubernetes.io/component=controller \
        --timeout=90s
```

3. Instale o Cert-Manager:

```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.1/cert-manager.yaml
```

4. Agora vamos criar a `Issuer` e a `ClusterIssuer` que serão utilizadas para gerar os certificados SSL.

```bash
kubectl apply -f manifests/Issuers/Issuers.yaml
```

5. Instale o Prometheus, Grafana, AlertManager utilizando o kube-prometheus:

```bash
git clone https://github.com/prometheus-operator/kube-prometheus.git && cd kube-prometheus && kubectl create -f manifests/setup && until kubectl get servicemonitors --all-namespaces; do date; sleep 1; echo ''; done && kubectl create -f manifests/ && cd .. && rm -rf kube-prometheus
```

6. Instale o Metrics Server que será utilizado pelo HPA (Horizontal Pod Autoscaler):

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

7. Com o ambiente pronto, podemos fazer o deploy das aplicações:

```bash
kubectl apply -f manifests/
```

8. Após o deploy, precisamos configurar o nosso domínio para apontar para o IP do NLB (Network Load Balancer). Você pode encontrar o IP do NLB no console da Oracle Cloud Infrastructure ou executando o comando abaixo `tofu output` no diretório `terraform`.

```bash
tofu output
```

9. Com o IP do NLB em mãos, crie um registro A no seu domínio apontando para o IP do NLB.

10. Podemos acessar cada uma das aplicações através dos endereços abaixo:

```bash
https://giropops.r11s.com.br # Aplicação principal
https://locust.r11s.com.br # Locust
https://prometheus.r11s.com.br # Prometheus
https://grafana.r11s.com.br # Grafana
https://alertmanager.r11s.com.br # AlertManager
```

# Removendo os recursos

Para remover a aplicação:

```bash
kubectl delete -f manifests/ && kubectl delete -f manifests/Issuers/
git clone https://github.com/prometheus-operator/kube-prometheus.git && cd kube-prometheus && kubectl delete -f manifests/ && kubectl delete -f manifests/setup
cd .. && rm -rf kube-prometheus
kubectl delete -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.1/cert-manager.yaml
kubectl delete -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl delete secrets letsencrypt-staging letsencrypt-prod
```

Removendo o Ingress Nginx Controller:

```bash
helm uninstall ingress-nginx -n ingress-nginx
```

Para remover o cluster e todos os recursos criados:

```bash
tofu destroy
```