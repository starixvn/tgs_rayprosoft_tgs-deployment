# install necessary component 
## At first, install provisioner and pv  
cd nfs-provisioner 
kubectl apply -f .
cd dev 
kubectl apply -f 01.pv.yml 

helm repo add localstack-charts https://localstack.github.io/helm-charts

https://github.com/localstack/helm-charts/blob/main/charts/localstack/README.md

helm install localstack localstack-charts/localstack -n dev

helm install localstack localstack-repo/localstack -n dev
https://github.com/localstack/localstack

kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.1.0/cert-manager.crds.yaml
helm install cert-manager jetstack/cert-manager --namespace cert-manager --version v1.1.0
https://cert-manager.io/docs/installation/kubernetes/


helm install sonarqube . -f values.yaml --set OpenShift.enabled=true,serviceAccount.create=true,postgresql.serviceAccount.enabled=true,postgresql.securityContext.enabled=false,postgresql.volumePermissions.enabled=true,postgresql.volumePermissions.securityContext.runAsUser="auto",ingress.enabled=true,ingress.hosts[0].host=sonarqube.tgsdev.gq,ingress.hosts[0].paths[0]=/ -n dev
										  
helm install sonarqube oteemocharts/sonarqube --set OpenShift.enabled=true,\
                                          serviceAccount.create=true,\
                                          postgresql.serviceAccount.enabled=true,\
                                          postgresql.securityContext.enabled=false,\
                                          postgresql.volumePermissions.enabled=true,\
                                          postgresql.volumePermissions.securityContext.runAsUser="auto",\
										  ingress.enabled=true,\
										  ingress.hosts[0].host=sonarqube.tgsdev.gq,\
									      ingress.hosts[0].paths[0]=/ -n dev
										  
https://artifacthub.io/packages/helm/oteemo-charts/sonarqube

# nats and its exporter
helm install nats bitnami/nats --set metrics.enabled=true,auth.enabled=false -n dev
nats-metrics:7777/metrics 
https://github.com/bitnami/charts/tree/master/bitnami/nats/#installing-the-chart

//Official
helm repo add nats https://nats-io.github.io/k8s/helm/charts/
helm install nats nats/nats --set cluster.enabled=true,auth.enabled=false -n dev

### https://github.com/nats-io/k8s/tree/master/helm/charts/stan

# redis, redis exporter and redisinsight
helm install redis bitnami/redis --set password=1qaz2wsx,metrics.enabled=true,master.disableCommands=["FLUSHDB"] -n dev

helm install redis bitnami/redis --set global.redis.password=1qaz2wsx,metrics.enabled=true -n dev

redis-metrics:9121/metrics 
https://github.com/bitnami/charts/tree/master/bitnami/redis/#installing-the-chart

helm install redisinsight . -f values.yaml -n dev
https://docs.redislabs.com/latest/ri/installing/install-k8s/
http://redisinsight.tgsdev.gq/

# mongodb, mpmgodb express and exporter
helm install mongodb bitnami/mongodb --set auth.rootPassword=1qaz2wsx,auth.enabled=false,metrics.enabled=true -n dev
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

# pgadmin
helm repo add runix https://helm.runix.net/
helm install pgadmin runix/pgadmin4 --set ingress.enabled=true,ingress.hosts[0].host=pgadmin.rpgp.cc,ingress.hosts[0].paths[0].path=/,ingress.hosts[0].paths[0].pathType=Prefix

,env.email=tgs@rayprosoft.com

https://github.com/rowanruseler/helm-charts/tree/master/charts/pgadmin4

# consul
helm install consul bitnami/consul --set ingress.enabled=true,ingress.hostname=consul.tgsdev.gq

# root helm url 
https://github.com/bitnami/charts/tree/master/bitnami





install nats 
install localstack 
install redis  (可能要到 50.111 刪除資料 才能運作)
install rabbitmq
install configmap & secrets
在jenkins 更新 k8s config 
lobby 的 ingress  brand token 要重新設定


kubectl create secret generic brand-cert --from-literal=key.pem="$(openssl genrsa 2048)" -n dev
 

更新 jenkins, harbor ingress
更新 baget 
更新 email, notofy





