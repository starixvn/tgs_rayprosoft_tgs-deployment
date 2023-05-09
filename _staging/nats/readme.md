helm repo add nats https://nats-io.github.io/k8s/helm/charts/

helm upgrade -i nats nats/nats -f helm-config.yaml -n staging