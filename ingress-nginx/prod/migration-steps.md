## 新建一個新的nginx-controller
helm upgrade -i nginx-ingress ingress-nginx/ingress-nginx -f config.yaml --set controller.replicaCount=3  -n ingress-nginx

## 移除舊的 nginx-controller



## 移除舊的 nginx-controller
