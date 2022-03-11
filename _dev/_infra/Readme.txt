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

helm install redis bitnami/redis --set global.redis.password=1qaz2wsx,metrics.enabled=true -n dev

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

