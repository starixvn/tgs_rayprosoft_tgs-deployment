改用helm upgrade -i 安裝

kubectl create namespace logging

REF: https://docs.fluentbit.io/manual/installation/kubernetes#installation

先依照文件設定helm repo

升級時，先執行
helm repo update

安裝daemonset的fluent-bit
helm upgrade -i fluent-bit fluent/fluent-bit -f .\edge-values.yaml

安裝center
helm upgrade -i log-center fluent/fluent-bit -f .\center-values.yaml

再重新執行helm upgrade指令
