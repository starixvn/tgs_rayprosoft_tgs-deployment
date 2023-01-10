#!/bin/bash
kubectl delete -f observability/fluentbit_old/
helm repo add fluent https://fluent.github.io/helm-charts
helm repo update
helm upgrade -i fluent-bit fluent/fluent-bit -f  observability/fluentbit-new/edge-values.yaml
helm upgrade -i fluent-bit fluent/fluent-bit -f  observability/fluentbit-new/center-values.yaml
kubectl get ds fluent-bit -n logging -o yaml > fluent-bit.yaml
