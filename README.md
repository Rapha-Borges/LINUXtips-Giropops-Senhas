# Projeto Prático Programa Intensivo em Containers e Kubernetes - Desenvolvimento e Otimização Segura de Aplicações Kubernetes

O objetivo deste projeto é criar e implementar uma aplicação em Kubernetes, utilizando as melhores práticas de segurança e otimização.

Este projeto utiliza como base a aplicação [Giropops-Senhas](https://github.com/badtuxx/giropops-senhas).

## Tecnologias utilizadas

- [Docker](https://docs.docker.com/get-docker/)
- [Kubernetes](https://kubernetes.io/docs/home/)
- [Helm](https://helm.sh/docs/intro/install/)
- [Prometheus](https://prometheus.io/docs/prometheus/latest/installation/)
- [Grafana](https://grafana.com/docs/grafana/latest/installation/)
- [Metrics Server](https://github.com/kubernetes-sigs/metrics-server)
- [Cert-Manager](https://cert-manager.io/docs/installation/kubernetes/)
- [Ingress NGINX Controller](https://kubernetes.github.io/ingress-nginx/deploy/)
- [Kyverno](https://kyverno.io/)
- [Cosign](https://github.com/sigstore/cosign)
- [Trivy](https://aquasecurity.github.io/trivy/v0.47/getting-started/installation/)
- [yamlint](https://yamllint.readthedocs.io/en/stable/index.html)
- [Digestabot](https://github.com/chainguard-dev/digestabot)
- [Zora Dashboard](https://zora-dashboard.undistro.io/)
- [Locust](https://locust.io/)
- [Terrafom](https://www.terraform.io)
- [OpenTofu](https://opentofu.org/)
- [OCI](https://www.oracle.com/br/cloud/)
- [Kind](https://kind.sigs.k8s.io/docs/user/quick-start/)



## Imagem Docker

![Trivy](static/trivy.png)

A aplicação foi construída utilizando como base as imagens [Python da Chainguard](https://edu.chainguard.dev/chainguard/chainguard-images/reference/python/), que já possuem as melhores práticas de segurança implementadas. Utilizando a técnica de [multi-stage build](https://docs.docker.com/develop/develop-images/multistage-build/) para reduzir o tamanho final e principalmente aumentar a segurança.

Você pode buildar a imagem localmente utilizando os arquivos na pasta 'giropops-senhas' com o comando:

```bash
docker build -t <login-docker-hub>/linuxtips-giropops-senhas:{versao} .
```

E rodar testes de segurança utilizando o [Trivy](https://aquasecurity.github.io/trivy/v0.47/getting-started/installation/)

```bash
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin v0.47.0
trivy image <login-docker-hub>/linuxtips-giropops-senhas:{versao}
```

Ou utilizar a imagem disponível no [Docker Hub](https://hub.docker.com/repository/docker/raphaelborges/linuxtips-giropops-senhas/) com a garantia de utilizar sempre a versão mais recente e livre de vulnerabilidades. Já que a imagem é buildada automaticamente sempre que houver qualquer alterção, utilizando o [Digestabot](https://github.com/chainguard-dev/digestabot) para manter a imagem base sempre atualizada, o [Trivy](https://trivy.dev/) para verificar se a imagem possui alguma vulnerabilidade e o [Cosign](https://docs.sigstore.dev/) para assinar a imagem e garantir que ela não foi alterada.

* Caso tenha interesse em conhecer mais sobre o Digestabot, você pode ler o meu artigo [Você já conhece o Digestabot?](https://dev.to/raphaborges/voce-ja-conhece-o-digestabot-787).

## Kubernetes - Técnicas Aplciadas

Como o objetivo deste projeto é aplicar as melhores práticas de segurança e otimização, foram utilizadas as seguintes técnicas:

- [x] [Secrets](https://kubernetes.io/docs/concepts/configuration/secret/) para armazenar as variáveis de ambiente??
- [x] [Limites de Recursos](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) para limitar o uso de CPU e Memória
- [x] [Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/) para limitar o acesso a aplicação
- [x] [Pod Security Policies](https://kubernetes.io/docs/concepts/policy/pod-security-policy/) para limitar o acesso a aplicação
- [x] [RBAC](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) para limitar o acesso a aplicação
- [x] [Service Account](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/) para limitar o acesso a aplicação
- [x] [Pod Disruption Budget](https://kubernetes.io/docs/tasks/run-application/configure-pdb/) para garantir que sempre haverá pelo menos um pod rodando ??
- [x] [Horizontal Pod Autoscaler](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) para escalar a aplicação horizontalmente
- [x] [Pod Affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity) para garantir que os pods rodem no mesmo node
- [x] [ConfigMap](https://kubernetes.io/docs/concepts/configuration/configmap/) para armazenar as configurações da aplicação
- [x] [Pod Monitor](https://docs.openshift.com/container-platform/4.14/rest_api/monitoring_apis/podmonitor-monitoring-coreos-com-v1.html) Para definir as métricas de monitoramento
- [x] [Strategy](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy) para garantir que a aplicação seja atualizada sem downtime
- [x] [Image Pull Policy](https://kubernetes.io/docs/concepts/containers/images/#updating-images) para garantir que a aplicação utilize sempre a imagem mais recente
- [x] [Security Context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) para definir o usuário e grupo que a aplicação irá rodar
- [x] [Probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) para verificar se a aplicação está saudável
- [x] [Policy](https://kubernetes.io/docs/concepts/policy/pod-security-policy/) para garantir que a aplicação utilize sempre a imagem mais recente

## Kubernetes - Arquitetura

A aplicação foi dividida nos seguintes componentes:

- [x] [giropops-senhas](giropops-senhas/deployment.yaml) - Responsável por gerar as senhas
- [x] [redis](redis/deployment.yaml) - Responsável por armazenar as senhas
- [x] [locust](locust/deployment.yaml) - Responsável por gerar testes de carga na aplicação
- [x] [ingress-nginx](ingress-nginx/deployment.yaml) - Responsável por gerar o ingress da aplicação
- [x] [kube-prometheus](kube-prometheus/deployment.yaml) - Responsável por gerar o dashboard de monitoramento
- [x] [metrics-server](metrics-server/deployment.yaml) - Responsável por gerar métricas de monitoramento
- [x] [zora-dashboard](zora-dashboard/deployment.yaml) - Responsável por gerar um dashboard de vulnerabilidades

## Deploy

O deploy da aplicação pode ser feito de forma local, utilizando o [Kind](https://kind.sigs.k8s.io/docs/user/quick-start/), ou em um cluster na [Oracle Cloud](https://www.oracle.com/br/cloud/) utilizando outro projeto que desenvolvi como base, o [OKE-FREE](https://github.com/rapha-Borges/oke-free)

- Local - [Kind](kind/README.md)
- OCI   - [Oracle Cloud](OCI/README.md)

## Desenvolvido por [@Raphael Borges](https://r11s.com.br/)