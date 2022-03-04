kubectl create namespace logging

建下面三個的主要目的是讓 fluentbit 可以把log 塞進elasticsearch

kubectl create -f https://raw.githubusercontent.com/fluent/fluent-bit-kubernetes-logging/master/fluent-bit-service-account.yaml
kubectl create -f https://raw.githubusercontent.com/fluent/fluent-bit-kubernetes-logging/master/fluent-bit-role.yaml
kubectl create -f https://raw.githubusercontent.com/fluent/fluent-bit-kubernetes-logging/master/fluent-bit-role-binding.yaml



REF: https://docs.fluentbit.io/manual/installation/kubernetes#installation