# nats official 
helm repo add nats https://nats-io.github.io/k8s/helm/charts/

helm upgrade --install nats nats/nats -f nats/helm-config.yaml -n staging

# redis, redis exporter

helm repo add bitnami https://charts.bitnami.com/bitnami

helm upgrade -i redis bitnami/redis -f values-redis.yaml -n staging

helm template redis bitnami/redis -f values-redis.yaml -n staging

redis-metrics:9121/metrics 
https://github.com/bitnami/charts/tree/master/bitnami/redis/#installing-the-chart

# redisinsight
cd redisinsight 
helm install redisinsight . -f values.yaml -n staging
https://docs.redislabs.com/latest/ri/installing/install-k8s/
https://stg-redisinsight.rpgp.cc/


# mongodb, mpmgodb express and exporter
mongodb 6.0 版本 更新很大
https://www.mongodb.com/docs/v6.0/release-notes/6.0-compatibility/#legacy-opcodes-removed

### 下載 mongodb helm chart 
helm pull bitnami/mongodb --version 14.1.1
加上 create-user-job.yaml 檔案

cd mongodb 
helm upgrade -i mongodb bitnami/mongodb -f values-mongo.yaml -n staging --version 14.1.1  

local: helm upgrade -i mongodb . -f values-mongo.yaml -n staging --version 14.1.1  
### 14.1.1 可以正常安裝，太新的版本會有錯誤

改用版本 5.0.9-debian-11-r3 

helm uninstall mongodb  -n staging


mongodb-metrics:9216/metrics 
https://github.com/bitnami/charts/tree/master/bitnami/mongodb#installing-the-chart


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


helm repo add cowboysysop https://cowboysysop.github.io/charts/
helm upgrade -i mongodb-express bitnami/mongodb -f values-mongo-express.yaml -n staging

http://stg-mongodb-express.rpgp.cc/
https://artifacthub.io/packages/helm/cowboysysop/mongo-express
