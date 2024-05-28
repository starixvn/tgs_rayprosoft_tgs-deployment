# nfs provisioner
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
	
### cert-manager
https://cert-manager.io/docs/installation/
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.7.1/cert-manager.yaml

# install reloader

https://github.com/stakater/Reloader
kubectl apply -f https://raw.githubusercontent.com/stakater/Reloader/master/deployments/kubernetes/reloader.yaml


# nats and its exporter
helm install nats bitnami/nats --set metrics.enabled=true,auth.enabled=false -n dev
nats-metrics:7777/metrics 
https://github.com/bitnami/charts/tree/master/bitnami/nats/#installing-the-chart

# nats Official
helm repo add nats https://nats-io.github.io/k8s/helm/charts/
helm install nats nats/nats --set cluster.enabled=true,auth.enabled=false -n dev
helm upgrade --install nats nats/nats --set metrics.enabled=true,auth.enabled=false,cluster.enabled=true,cluster.name=nats,cluster.replicas=3 -n dev

helm upgrade --install nats nats/nats -f nats-values.yaml -n dev

helm uninstall nats -n dev

### https://github.com/nats-io/k8s/tree/master/helm/charts/stan

# redis, redis exporter and redisinsight
helm install redis bitnami/redis -f values-redis.yaml -n dev

redis-metrics:9121/metrics 
https://github.com/bitnami/charts/tree/master/bitnami/redis/#installing-the-chart

helm install redisinsight . -f values.yaml -n dev
https://docs.redislabs.com/latest/ri/installing/install-k8s/
http://dev-redisinsight.rpgp.cc/

# mongodb, mpmgodb express and exporter
helm install mongodb bitnami/mongodb --set global.storageClass=nfs-provisioner,auth.rootPassword=1qaz2wsx,auth.enabled=false,metrics.enabled=true -n dev
mongodb-metrics:9216/metrics 
https://github.com/bitnami/charts/tree/master/bitnami/mongodb#installing-the-chart

helm install mongodb-express cowboysysop/mongo-express  --set mongodbEnableAdmin=true,mongodbAdminPassword=1qaz2wsx,ingress.enabled=true,ingress.hosts[0].host=dev-mongodb-express.rpgp.cc,ingress.hosts[0].paths[0]=/ -n dev
http://dev.mongodb-express.tgsdev.gq/
https://artifacthub.io/packages/helm/cowboysysop/mongo-express

go to mongodb pods 
mongo
use admin
db.createUser(
    {
        user:"root",
        pwd:"1qaz2wsx",
        roles:[
            {role:"dbOwner", db:"admin"}
        ]
    }
)

# postgres, postgres exporter
helm install postgres bitnami/postgresql --set postgresqlPassword='1qaz2wsx!@',metrics.enabled=true,postgresqlDatabase=tgs,service.type=NodePort,service.nodePort=30007 -n dev
postgres-postgresql-metrics:9187/metrics 


# consul
helm install consul bitnami/consul --set ingress.enabled=true,ingress.hostname=consul.tgsdev.gq

# root helm url 
https://github.com/bitnami/charts/tree/master/bitnami


kubectl create secret generic brand-cert --from-literal=key.pem="$(openssl genrsa 2048)" -n dev
 




