#!/bin/bash
namespace="prod"

# for p in $(kubectl get certificate -n prod | grep -v goal3388.com | awk '{print $1}'); do
    # kubectl delete certificate $p -n $namespace
# done;

for p in $(kubectl get ing -n $namespace | grep -v goal3388.com | awk '{print $1}'); do
    kubectl -n $namespace get ing $p -o yaml >  ${p}.yaml;
    
    echo "====== 修改 $p ======"
    ## optional
    # sed -i '/kubectl.kubernetes.io\/last-applied-configuration/d' ${p}.yaml
    # sed -i '/extensions\/v1beta1/d' ${p}.yaml
     
    ## 刪除 nginx.ingress.kubernetes.io 該行
    sed -i '/nginx.ingress.kubernetes.io/d' ${p}.yaml
    ## 刪除 cert-manager.io/cluster-issuer 該行
    sed -i '/cert-manager.io\/cluster-issuer/d' ${p}.yaml
    
    
    if grep -Fxq "ingressClassName" ${p}.yaml
    then 
       sed -i 's/ingressClassName: nginx/ingressClassName: nginx-tgs/g' ${p}.yaml
       echo "ingressClassName modified"
    else 
       ## 新增 ingressClassName: nginx
       sed -i '/spec:/a \ \ ingressClassName: nginx-tgs' ${p}.yaml
       echo "ingressClassName added"
    fi
    
    if grep -Fxq "tls" ${p}.yaml
    then
        ## code if found
        ## 刪除 tls
        sed -i '/tls/,/status/{/tls/!{/status/!d}}' ${p}.yaml
        sed -i '/tls:/d' ${p}.yaml 
        echo "remove tls"        
    else
        # code if not found
        echo "without tls"
    fi
    kubectl apply -f ${p}.yaml
    rm ${p}.yaml
    
done;
