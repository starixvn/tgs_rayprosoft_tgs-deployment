#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Apply RabbitMQ Cluster Operator
# kubectl apply -f "https://github.com/rabbitmq/cluster-operator/releases/latest/download/cluster-operator.yml"

# Install krew
(
  set -x
  cd "$(mktemp -d)"
  OS="$(uname | tr '[:upper:]' '[:lower:]')"
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')"
  KREW="krew-${OS}_${ARCH}"
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz"
  tar zxvf "${KREW}.tar.gz"
  ./"${KREW}" install krew
)

# Update PATH to include krew
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Install RabbitMQ krew plugin
kubectl krew install rabbitmq
kubectl rabbitmq install-cluster-operator

# Create namespace for RabbitMQ
kubectl create ns rabbitmq

# Apply RabbitMQ configuration files
kubectl apply -f rabbitmq.yaml
kubectl apply -f ingress.yaml

sleep 60
for i in {60..1}
do
   echo "$i seconds remaining..."
   sleep 1
done

# Set up RabbitMQ vhost and permissions
kubectl -n rabbitmq exec mq-server-0 -- rabbitmqctl add_vhost /tgs/staging
kubectl -n rabbitmq exec mq-server-0 -- rabbitmqctl set_permissions -p "/tgs/staging" "tgs" '.*' '.*' '.*'
kubectl -n rabbitmq exec mq-server-0 -- rabbitmqctl set_user_tags tgs administrator

echo "RabbitMQ setup completed successfully!"
