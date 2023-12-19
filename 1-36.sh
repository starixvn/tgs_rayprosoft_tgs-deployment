#!/bin/bash
kubectl delete -f observability/fluentbit_old/
helm repo add fluent https://fluent.github.io/helm-charts
helm repo update
helm upgrade -i fluent-bit fluent/fluent-bit -f  observability/fluentbit-new/edge-values.yaml -n logging
helm upgrade -i log-center fluent/fluent-bit -f  observability/fluentbit-new/center-values.yaml -n logging
kubectl get ds fluent-bit -n logging -o yaml > fluent-bit.yaml


# 通知 fluent-bit 已更新, 請查看系統相關服務是否運作正常

kubectl get pods -n prod | grep lobby | grep -v gpi

for p in $( kubectl get nodes --show-labels | grep frontend | awk '{print $1}');do echo "=======$p=======";kubectl get pods -A --field-selector spec.nodeName=$p ;done


#kubectl scale deploy pgpgool --replicas=10 -n prod
kubectl scale deploy brand-cert-api --replicas=2 -n prod


    for p in $(kubectl -n prod get pods | grep lobby | grep  ContainerCreating | awk '{print $1}'); do kubectl delete pod $p -n prod --grace-period=0 --force;done
	