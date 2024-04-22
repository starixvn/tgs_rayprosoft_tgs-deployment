#REF: https://github.com/nats-io/k8s/blob/main/helm/charts/nats/values.yaml
helm repo add nats https://nats-io.github.io/k8s/helm/charts/

helm upgrade -i nats nats/nats -f helm-config.yaml -n prod-old


helm template nats nats/nats -f helm-config.yaml -n prod-old