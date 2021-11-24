# nats and its exporter
helm install nats bitnami/nats --set metrics.enabled=true,auth.enabled=false
nats-metrics:7777/metrics 
https://github.com/bitnami/charts/tree/master/bitnami/nats/#installing-the-chart


# mongodb, mpmgodb express and exporter
helm install mongodb bitnami/mongodb --set auth.rootPassword=1qaz2wsx,auth.enabled=false,metrics.enabled=true -n dev
mongodb-metrics:9216/metrics 
https://github.com/bitnami/charts/tree/master/bitnami/mongodb#installing-the-chart

helm install mongodb-express cowboysysop/mongo-express  --set mongodbEnableAdmin=true,mongodbAdminPassword=1qaz2wsx,ingress.enabled=true,ingress.hosts[0].host=dev.mongodb-express.tgsdev.gq,ingress.hosts[0].paths[0]=/ -n dev
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

db.filedb.insert({name: "test"})