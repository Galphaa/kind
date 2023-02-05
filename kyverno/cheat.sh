kind create cluster --config=kind-config.yaml

#creating cluster with same version as lab and prod cluster
kind create cluster --config=kind-config.yaml --image=kindest/node:v1.21.10

#installing Weavework CNI
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml

#installing Cilium CNI
helm repo add cilium https://helm.cilium.io/ #adding cilium helm repo if needed
docker pull quay.io/cilium/cilium:v1.11.2
kind load docker-image quay.io/cilium/cilium:v1.11.2
helm install cilium cilium/cilium --version 1.11.2 \
   --namespace kube-system \
   --set nodeinit.enabled=true \
   --set kubeProxyReplacement=partial \
   --set hostServices.enabled=false \
   --set externalIPs.enabled=true \
   --set nodePort.enabled=true \
   --set hostPort.enabled=true \
   --set bpf.masquerade=false \
   --set image.pullPolicy=IfNotPresent \
   --set ipam.mode=kubernetes
cilium hubble enable

#installing kyverno
helm repo add kyverno https://kyverno.github.io/kyverno/
helm repo update
helm install kyverno kyverno/kyverno --namespace kyverno --create-namespace


