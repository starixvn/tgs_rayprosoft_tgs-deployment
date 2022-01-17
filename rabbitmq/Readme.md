https://www.rabbitmq.com/kubernetes/operator/operator-overview.html

kubectl apply -f "https://github.com/rabbitmq/cluster-operator/releases/latest/download/cluster-operator.yml"

## install krew
https://krew.sigs.k8s.io/docs/user-guide/setup/install/

kubectl krew install rabbitmq
kubectl rabbitmq install-cluster-operator





https://blog.csdn.net/qq_24095055/article/details/97001679

rabbitmqctl add_user tgs TgsP@ssw0rd
rabbitmqctl add_vhost /tgs/staging
rabbitmqctl add_vhost /tgs/prod
rabbitmqctl set_permissions -p "/tgs/staging" "tgs" '.*' '.*' '.*'
rabbitmqctl set_permissions -p "/tgs/prod" "tgs" '.*' '.*' '.*'

rabbitmqctl set_user_tags tgs administrator
