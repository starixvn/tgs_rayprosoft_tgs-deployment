# nats official 
helm repo add nats https://nats-io.github.io/k8s/helm/charts/

helm upgrade --install nats nats/nats -f nats/helm-config.yaml -n staging

# redis, redis exporter and redisinsight

helm repo add bitnami https://charts.bitnami.com/bitnami

helm upgrade -i redis bitnami/redis -f values-redis.yaml -n staging

helm template redis bitnami/redis -f values-redis.yaml -n staging

redis-metrics:9121/metrics 
https://github.com/bitnami/charts/tree/master/bitnami/redis/#installing-the-chart

helm install redisinsight . -f values.yaml -n staging
https://docs.redislabs.com/latest/ri/installing/install-k8s/
https://stg-redisinsight.rpgp.cc/


# mongodb, mpmgodb express and exporter

mongodb 6.0 版本 更新很大
https://www.mongodb.com/docs/v6.0/release-notes/6.0-compatibility/#legacy-opcodes-removed

helm install mongodb bitnami/mongodb --set auth.rootPassword=1qaz2wsx,auth.enabled=false,metrics.enabled=true,image.tag=5.0.9-debian-11-r3 -n staging

改用版本 5.0.9-debian-11-r3 

helm uninstall mongodb  -n staging


mongodb-metrics:9216/metrics 
https://github.com/bitnami/charts/tree/master/bitnami/mongodb#installing-the-chart

helm repo add cowboysysop https://cowboysysop.github.io/charts/
helm install mongodb-express cowboysysop/mongo-express  --set mongodbEnableAdmin=true,mongodbAdminPassword=1qaz2wsx,ingress.enabled=true,ingress.hosts[0].host=stg-mongodb-express.rpgp.cc,ingress.hosts[0].paths[0]=/ -n staging
http://stg-mongodb-express.rpgp.cc/
https://artifacthub.io/packages/helm/cowboysysop/mongo-express

helm install mongodb-express cowboysysop/mongo-express  --set mongodbEnableAdmin=true,mongodbAdminPassword=1qaz2wsx,ingress.enabled=true,ingress.hosts[0].host=stg-mongodb-express.rpgp.cc,ingress.hosts[0].paths[0]=/ -n staging

go to mongodb pods 
mongosh
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

db.filedb.insert({name: "test"})