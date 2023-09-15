## 新建一個新的nginx-controller
helm upgrade -i nginx-ingress ingress-nginx/ingress-nginx -f config.yaml --set controller.replicaCount=3  -n ingress-nginx

helm upgrade -i nginx-tgs ingress-nginx/ingress-nginx -f values-nginx-ingress-conroller.yaml --set controller.replicaCount=3 -n ingress-nginx


## 移除舊的 nginx-controller



## 移除舊的 nginx-controller

REF: https://kubernetes.github.io/ingress-nginx/deploy/#aws

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/aws/deploy.yaml


https://docs.k0sproject.io/v1.25.2+k0s.0/examples/nginx-ingress/


aa0a39ab3dc754f43a88178415c35bbd-1717982857.ap-east-1.elb.amazonaws.com

goal3388.com 這一個域名需要SSL