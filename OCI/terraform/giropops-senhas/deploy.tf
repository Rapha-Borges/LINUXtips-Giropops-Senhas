# resource "null_resource" "create_kubeconfig" {
#   provisioner "local-exec" {
#     command = "oci ce cluster create-kubeconfig --cluster-id ${var.cluster_id} --file ~/.kube/config --token-version 2.0.0 --kube-endpoint PUBLIC_ENDPOINT --profile ${var.oci_profile}"
#   }
# }

# resource "kubernetes_namespace" "ingress-nginx" {
#   depends_on = [null_resource.create_kubeconfig]
#   metadata {
#     name = "ingress-nginx"
#   }
# }

# resource "null_resource" "ingress" {
#   depends_on = [kubernetes_namespace.ingress-nginx]

#   provisioner "local-exec" {
#     command = <<-EOT
#       helm upgrade --install ingress-nginx ingress-nginx \
#         --repo https://kubernetes.github.io/ingress-nginx \
#         --namespace ingress-nginx \
#         --set controller.service.annotations."oci\.oraclecloud\.com/load-balancer-type"="nlb" \
#         --set controller.service.annotations."oci-network-load-balancer\.oraclecloud\.com/security-list-management-mode"="All" \
#         --set controller.service.type="NodePort" \
#         --set controller.service.nodePorts.http=30080 \
#         --set controller.service.nodePorts.https=30443 && \
#       kubectl wait --namespace ingress-nginx \
#         --for=condition=ready pod \
#         --selector=app.kubernetes.io/component=controller \
#         --timeout=90s
#     EOT
#   }
# }

# resource "null_resource" "install_cert_manager" {
#   depends_on = [ null_resource.ingress ]
#   provisioner "local-exec" {
#     command = "kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.1/cert-manager.yaml && sleep 90"
#   }
# }

# resource "kubernetes_namespace" "giropops-senhas" {
#   depends_on = [null_resource.install_cert_manager]
#   metadata {
#     name = "giropops-senhas"
#   }
# }

# resource "null_resource" "issuer" {
#   depends_on = [kubernetes_namespace.giropops-senhas]

#   provisioner "local-exec" {
#     command = "kubectl apply -f ../manifests/Issuers/Issuers.yaml"
#   }
# }

# resource "null_resource" "install_kube_prometheus" {
#   depends_on = [null_resource.issuer]

#   provisioner "local-exec" {
#     command = "git clone https://github.com/prometheus-operator/kube-prometheus.git && cd kube-prometheus && kubectl create -f manifests/setup && until kubectl get servicemonitors --all-namespaces; do date; sleep 1; echo ''; done && kubectl create -f manifests/ && cd .. && rm -rf kube-prometheus"
#   }
# }

# resource "null_resource" "install_metrics_server" {
#   depends_on = [null_resource.install_kube_prometheus]

#   provisioner "local-exec" {
#     command = "kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml"
#   }
# }

# resource "null_resource" "apply_manifests" {
#   depends_on = [null_resource.install_metrics_server]

#   provisioner "local-exec" {
#     command = "kubectl apply -f ../manifests"
#   }
# }
