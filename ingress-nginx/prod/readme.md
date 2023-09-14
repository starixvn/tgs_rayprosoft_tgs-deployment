#REF: https://kubernetes.github.io/ingress-nginx/deploy/#aws
#REF: https://github.com/kubernetes/ingress-nginx/blob/main/charts/ingress-nginx/values.yaml

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

kubectl create ns ingress-nginx

helm -n ingress-nginx upgrade -i nginx-ingress ingress-nginx/ingress-nginx -f nginx-backend.yaml --set controller.replicaCount=3

helm -n ingress-nginx upgrade -i nginx-tgs ingress-nginx/ingress-nginx -f nginx-tgs.yaml --set controller.replicaCount=3

helm uninstall nginx-ingress  -n ingress-nginx