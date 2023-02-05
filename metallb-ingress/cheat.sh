kind create cluster --config=kind-config.yaml

#creating cluster with specific version
kind create cluster --config=kind-config.yaml --image=kindest/node:v1.23.3

#creating Nginx ingress controller 
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

#installing Weavework CNI
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml

#installing Cilium CNI
docker pull cilium/cilium:v1.10.5
kind load docker-image cilium/cilium:v1.10.5
helm install cilium cilium/cilium --version 1.10.5 \
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
