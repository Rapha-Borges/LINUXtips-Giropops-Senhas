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
<ip>:3000 # Locust
<ip>:3001 # Prometheus
<ip>:3002 # Grafana
<ip>:3003 # AlertManager
```
