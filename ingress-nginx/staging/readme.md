#REF: https://kubernetes.github.io/ingress-nginx/deploy/#aws
#REF: https://github.com/kubernetes/ingress-nginx/blob/main/charts/ingress-nginx/values.yaml

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

kubectl create ns ingress-nginx

helm upgrade -i nginx ingress-nginx/ingress-nginx -f config.yaml -n ingress-nginx

helm template nginx ingress-nginx/ingress-nginx -f config.yaml -n ingress-nginx


helm upgrade -i nginx ingress-nginx/ingress-nginx -f values-ingress-controller.yaml -n ingress-nginx

helm upgrade -i nginx-tgs ingress-nginx/ingress-nginx -f config-tgs.yaml -n ingress-nginx

helm uninstall nginx-ingress -n ingress-nginx



eksctl create iamserviceaccount \
    --cluster=tgs-k8s-test \
    --namespace=ingress-nginx \
    --name=aws-load-balancer-controller \
    --attach-policy-arn=arn:aws:iam::060812454361:policy/AWSLoadBalancerControllerIAMPolicy-test \
    --approve


helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
    -n ingress-nginx \
    --set clusterName=tgs-k8s-test \
    --set serviceAccount.create=false \
    --set region=ap-east-1 \
    --set vpcId=vpc-0b86a361eb192585e \
    --set serviceAccount.name=aws-load-balancer-controller

## ALB with ingress controller
https://aws.amazon.com/tw/blogs/opensource/kubernetes-ingress-aws-alb-ingress-controller/
