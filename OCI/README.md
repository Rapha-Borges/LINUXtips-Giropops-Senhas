# Fazendo deploy do projeto no OKE (Oracle Kubernetes Engine)

1. Faça login na sua conta Oracle Cloud e exporte o token de autenticação da sua conta Oracle Cloud:

```bash
oci session authenticate --region sa-saopaulo-1
```
```bash
export OCI_CLI_AUTH=security_token
```

ATENÇÃO: O token de autenticação é válido por 1 hora, após esse período é necessário realizar o refresh do token ou gerar um novo.

```bash
oci session refresh --config-file ~/.oci/config --profile DEFAULT
```

2. Criar a chave ssh e exportar o valor da chave publica para a variavel de ambiente TF_VAR_ssh_public_key.

```bash
ssh-keygen -t rsa -b 4096 -f ssh/id_rsa
export TF_VAR_ssh_public_key=$(cat ssh/id_rsa.pub)
```

3. Aplicar os arquivos na pasta `terraform`.

```bash
terraform init
terraform plan -out=oci.tfplan
terraform apply "oci.tfplan"
```

4. Acesse o cluster:

```bash
kubectl get nodes
```

5. Ao finalizar a criação dos recursos, o output mostrará o endereço de IP do Load Balancer que está configurado para expor a nossa aplicação principal. Para acessar as aplicações, como Locust e Prometheus, basta acessar o endereço de IP + a porta do serviço.

```bash
<ip>:30000 # Locust
<ip>:30001 # Prometheus
<ip>:30002 # Grafana
<ip>:30003 # AlertManager
```




<!-- 
4. O output irá mostrar o comando para criação do kubeconfig. Basta copiar e colar no terminal. Exemplo:

```bash
###### NAO UTILIZE ESSE COMANDO, ELE É APENAS UM EXEMPLO. COPIE O COMANDO QUE APARECER NO OUTPUT DO TERRAFORM ######
oci ce cluster create-kubeconfig --cluster-id ${oci_containerengine_cluster.k8s_cluster.id} --file ~/.kube/config --token-version 2.0.0 --kube-endpoint PUBLIC_ENDPOINT" 
``` -->

<!-- 4. Antes de acessar o cluster, é necessário adicionar mais duas linhas no arquivo `~/.kube/config`:

```bash
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
      - --auth               # ADICIONE ESSA LINHA
      - security_token       # ADICIONE ESSA LINHA
```

Esse comando pode adicionar as linhas automaticamente, faça por sua conta e risco:

```bash
sed -i '/^users:/,/^\s*$/ s/\(^.*- sa-saopaulo-1.*$\)/\1\n\ \ \ \ \ \ - --auth\n\ \ \ \ \ \ - security_token/' ~/.kube/config
``` -->

<!-- 6. Faça o deploy da aplicação:

```bash
terraform plan -target=module.giropops-senhas -out=oci.tfplan
terraform apply "oci.tfplan"
```

7. Aplicar a configuração para criar o `load balancer`.

```bash
terraform plan -target=module.loadbalancer -out=oci.tfplan
terraform apply "oci.tfplan"
``` -->