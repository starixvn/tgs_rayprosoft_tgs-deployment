#REF: https://kubernetes.github.io/ingress-nginx/deploy/#bare-metal-clusters
#REF: https://github.com/kubernetes/ingress-nginx/blob/main/charts/ingress-nginx/values.yaml

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

kubectl create ns ingress-nginx

helm -n ingress-nginx upgrade -i nginx-ingress ingress-nginx/ingress-nginx -f config.yaml --set controller.replicaCount=3

helm uninstall nginx-ingress  -n ingress-nginx