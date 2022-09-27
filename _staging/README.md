# nats and its exporter
helm repo add bitnami https://charts.bitnami.com/bitnami

helm install nats bitnami/nats --set metrics.enabled=true,auth.enabled=false -n staging
nats-metrics:7777/metrics 
https://github.com/bitnami/charts/tree/master/bitnami/nats/#installing-the-chart

# redis, redis exporter and redisinsight
helm install redis bitnami/redis --set password=1qaz2wsx,auth.enabled=false,metrics.enabled=true -n staging
redis-metrics:9121/metrics 
https://github.com/bitnami/charts/tree/master/bitnami/redis/#installing-the-chart

helm install redisinsight . -f values.yaml -n staging
https://docs.redislabs.com/latest/ri/installing/install-k8s/
https://stg-redisinsight.rpgp.cc/


# mongodb, mpmgodb express and exporter
helm install mongodb bitnami/mongodb --set auth.rootPassword=1qaz2wsx,auth.enabled=false,metrics.enabled=true -n staging
mongodb-metrics:9216/metrics 
https://github.com/bitnami/charts/tree/master/bitnami/mongodb#installing-the-chart

helm install mongodb-express cowboysysop/mongo-express  --set mongodbEnableAdmin=true,mongodbAdminPassword=1qaz2wsx,ingress.enabled=true,ingress.hosts[0].host=mongodb-express.tgsstg.gq,ingress.hosts[0].paths[0]=/ -n staging
http://mongodb-express.tgsstg.gq/
https://artifacthub.io/packages/helm/cowboysysop/mongo-express

helm install mongodb-express cowboysysop/mongo-express  --set mongodbEnableAdmin=true,mongodbAdminPassword=1qaz2wsx,ingress.enabled=true,ingress.hosts[0].host=stg-mongodb-express.rpgp.cc,ingress.hosts[0].paths[0]=/ -n staging

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

db.filedb.insert({name: "test"})