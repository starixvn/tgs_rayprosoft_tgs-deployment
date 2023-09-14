#!/bin/bash
namespace="staging"

for p in $(kubectl get ing -n $namespace | grep none | awk '{print $1}'); do
    kubectl -n $namespace get ing $p -o yaml >  ${p}.yaml;
  
    sed -i '/kubectl.kubernetes.io\/last-applied-configuration/d' ${p}.yaml
     
    ## 刪除 nginx.ingress.kubernetes.io 該行
    sed -i '/nginx.ingress.kubernetes.io/d' ${p}.yaml
    
    ## 新增 ingressClassName: nginx
    sed -i '/spec:/a \ \ ingressClassName: nginx' ${p}.yaml
    
    ## 刪除 tls
    sed -i '/tls/,/status/{/tls/!{/status/!d}}' ${p}.yaml
    sed -i '/tls:/d' ${p}.yaml
    
    kubectl apply -f ${p}.yaml
    rm ${p}.yaml
done;
