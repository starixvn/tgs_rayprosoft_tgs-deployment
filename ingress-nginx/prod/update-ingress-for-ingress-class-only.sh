#!/bin/bash
namespace="staging"

for p in $(kubectl get ing -n $namespace | grep none | awk '{print $1}'); do
    kubectl -n $namespace get ing $p -o yaml >  ${p}.yaml;
  

    ## 新增 ingressClassName: nginx
    sed -i 'ingressClassName: nginx/ingressClassName: nginx-tgs/g' ${p}.yaml
    
    kubectl apply -f ${p}.yaml
    rm ${p}.yaml
done;
