#!/bin/bash
namespace="prod"

for p in $(kubectl get ing -n $namespace | awk '{print $1}'); do
    kubectl -n $namespace get ing $p -o yaml >  ${p}.yaml;
    ## 新增 ingressClassName: nginx
    sed -i 's/ingressClassName: nginx/ingressClassName: nginx-tgs/g' ${p}.yaml
    
    kubectl apply -f ${p}.yaml
    rm ${p}.yaml
done;