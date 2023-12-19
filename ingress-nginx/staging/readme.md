#REF: https://kubernetes.github.io/ingress-nginx/deploy/#aws
#REF: https://github.com/kubernetes/ingress-nginx/blob/main/charts/ingress-nginx/values.yaml

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

kubectl create ns ingress-nginx

helm upgrade -i nginx ingress-nginx/ingress-nginx -f config.yaml -n ingress-nginx

helm template nginx ingress-nginx/ingress-nginx -f config.yaml -n ingress-nginx


helm upgrade -i nginx-frontend ingress-nginx/ingress-nginx -f config-frontend.yaml -n ingress-nginx

helm upgrade -i nginx-tgs ingress-nginx/ingress-nginx -f config-tgs.yaml -n ingress-nginx

helm uninstall nginx-ingress -n ingress-nginx