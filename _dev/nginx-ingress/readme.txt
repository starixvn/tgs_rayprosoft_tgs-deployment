## infra team 使用的安裝方式
helm repo add nginx-stable https://helm.nginx.com/stable
修改 values.yaml
helm install nginx nginx-stable/nginx-ingress -f values.yaml


## tgs team 使用的安裝方式 
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.1.1/deploy/static/provider/cloud/deploy.yaml
https://kubernetes.github.io/ingress-nginx/deploy/#bare-metal-clusters
再把 deployment 輸出 yaml, 改成 daemonsets 安裝

