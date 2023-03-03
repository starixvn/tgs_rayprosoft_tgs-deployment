
### Install bash-completion
### https://kubernetes.io/docs/tasks/tools/included/optional-kubectl-configs-bash-linux/

apt-get install bash-completion
source /usr/share/bash-completion/bash_completion
echo 'source <(kubectl completion bash)' >>~/.bashrc
echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -F __start_kubectl k' >>~/.bashrc
exec bash
exit 登出再登入


### calico
https://projectcalico.docs.tigera.io/getting-started/kubernetes/quickstart

kubectl apply -f https://projectcalico.docs.tigera.io/manifests/calico.yaml


2023/02/24 改用下面安裝
https://docs.tigera.io/calico/3.25/getting-started/kubernetes/quickstart
https://github.com/projectcalico/calico/tree/master/charts/tigera-operator

helm repo add projectcalico https://projectcalico.docs.tigera.io/charts
kubectl create namespace tigera-operator
helm install calico projectcalico/tigera-operator --namespace tigera-operator

helm uninstall calico --namespace tigera-operator



### ingress
https://kubernetes.github.io/ingress-nginx/deploy/#bare-metal-clusters
    
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.1.1/deploy/static/provider/baremetal/deploy.yaml

*** 修改 nginx.conf 的 http, https port
	
### cert-manager
https://cert-manager.io/docs/installation/
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.7.1/cert-manager.yaml


### helm 
https://helm.sh/docs/intro/install/

### metric-server 
https://github.com/kubernetes-sigs/metrics-server

kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl edit deploy  metrics-server -n kube-system
deploy args 要加上 - --kubelet-insecure-tls

### reloader 
https://github.com/stakater/Reloader

kubectl apply -f https://raw.githubusercontent.com/stakater/Reloader/master/deployments/kubernetes/reloader.yaml


### nfs provisioner
helm repo add nfs-subdir-external-provisioner \
      https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner
  
helm repo update

helm install nfs-provisioner \
  nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
  --set nfs.server=192.168.50.111 \
  --set nfs.path=/nfsshare \
  --set storageClass.name=nfs-provisioner
  
helm template nfs-provisioner \
  nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
  --set nfs.server=192.168.50.111 \
  --set nfs.path=/nfsshare \
  --set storageClass.name=nfs-provisioner
  
### install reloader

https://github.com/stakater/Reloader

kubectl apply -f https://raw.githubusercontent.com/stakater/Reloader/master/deployments/kubernetes/reloader.yaml


### nats
helm repo add nats https://nats-io.github.io/k8s/helm/charts/
helm install nats nats/nats --set cluster.enabled=true,auth.enabled=false -n dev

REF: https://github.com/nats-io/k8s/tree/master/helm/charts/stan

### redis, redis exporter and redisinsight

helm repo add bitnami https://charts.bitnami.com/bitnami

helm install redis bitnami/redis --set password=1qaz2wsx,metrics.enabled=true,master.disableCommands=["FLUSHDB"] -n dev

helm install redis bitnami/redis --set global.redis.password=1qaz2wsx,auth.enabled=false,metrics.enabled=true -n dev

helm upgrade --install redis bitnami/redis --set global.redis.password=1qaz2wsx,auth.enabled=false,metrics.enabled=true -n dev

helm uninstall redis -n dev

redis-metrics:9121/metrics 
https://github.com/bitnami/charts/tree/master/bitnami/redis/#installing-the-chart

helm install redisinsight . -f values.yaml -n dev
https://docs.redislabs.com/latest/ri/installing/install-k8s/
https://dev-redisinsight.rpgp.cc/



### Install localstack 

https://github.com/localstack/helm-charts/tree/main/charts/localstack

helm repo add localstack-charts https://localstack.github.io/helm-charts

helm install localstack localstack-charts/localstack -n dev


helm upgrade --install localstack localstack-charts/localstack  \
--set persistence.enabled=true \
--set persistence.storageClass=nfs-client \
--set persistence.accessModes[0]=ReadWriteOnce \
--set service.type=NodePort \
--set service.nodePort=31566 \
--set ingress.enabled=true \
--set ingress.hosts[0].host=localstack.rpgp.cc \
--set ingress.hosts[0].paths[0].path=/ \
--set ingress.hosts[0].paths[0].pathType=Prefix \


### install pgpool && configmap && secrets

### install jaeger && kibana && elasticsearch 

