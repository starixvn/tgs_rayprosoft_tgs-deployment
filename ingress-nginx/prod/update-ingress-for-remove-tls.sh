:q!#!/bin/bash
namespace="staging"

for p in $(kubectl get ing -n $namespace | grep 443 | awk '{print $1}'); do
    kubectl -n $namespace get ing $p -o yaml >  ${p}.yaml;
   
    ## sed -i '/last-applied-configuration/,+1d' ${p}.yaml
    
    sed -i '/cert-manager.io\/cluster-issuer/d' ${p}.yaml
     
    ## 刪除 tls
    sed -i '/tls/,/status/{/tls/!{/status/!d}}' ${p}.yaml
    sed -i '/tls:/d' ${p}.yaml
    
    kubectl apply -f ${p}.yaml
    rm ${p}.yaml
done;