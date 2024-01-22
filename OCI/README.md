# Fazendo deploy do projeto no OKE (Oracle Kubernetes Engine)

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

7. Adicione os valores ao arquivo `export_variables.sh`, para exportar todas as variáveis necessárias para a autenticação do terraform.

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
source export_variables.sh
```

3. Aplicar os arquivos na pasta `terraform`.

```bash
tofu init
tofu apply
```

* Caso você tenha utilizado um profile diferente de `DEFAULT`, ocorrerá um erro ao final do processo de criação dos recursos. Para corrigir, basta adicionar o profile no arquivo `~/.kube/config` e executar o comando `tofu apply` novamente.

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

5. Ao finalizar a criação dos recursos, o output mostrará o endereço de IP do Load Balancer que está configurado para expor a nossa aplicação principal. Para acessar as aplicações, como Locust e Prometheus, basta acessar o endereço de IP + a porta do serviço.

```bash
<ip>:3000 # Locust
<ip>:3001 # Prometheus
<ip>:3002 # Grafana
<ip>:3003 # AlertManager
```

# Removendo os recursos

Para remover os recursos criados, basta executar o comando abaixo:

```bash
tofu destroy
```


## TODO

- [ ] Corrigir erro do `tofu apply` quando o profile é diferente de `DEFAULT`.
- [ ] Verificar possibilidade do recurso `kubernetes_namespace` executar somente no contexto correto.