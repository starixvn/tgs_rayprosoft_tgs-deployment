# REF: https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/values.yaml

kubectl create namespace monitoring

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts


helm install prometheus-stack prometheus-community/kube-prometheus-stack  --version 46.6.0 -f values.yaml -n monitoring
helm template prometheus-stack prometheus-community/kube-prometheus-stack --version 46.6.0 -f values.yaml -n monitoring


helm upgrade --reuse-values -f values.yaml prometheus-stack prometheus-community/kube-prometheus-stack -n monitoring

grafana
admin/prom-operator

kubectl get --raw "/apis/custom.metrics.k8s.io/v1beta1/namespaces/dev/metrics"
