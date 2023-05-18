# https://github.com/resmoio/kubernetes-event-exporter/tree/master/charts/kubernetes-event-exporter


helm repo add kubernetes-event-exporter https://resmoio.github.io/kubernetes-event-exporter
helm repo update


helm install kubernetes-event-exporter -f config.yaml kubernetes-event-exporter/kubernetes-event-exporter -n dev

# config.yaml
---
config: |
  logLevel: error
  logFormat: json
  route:
    routes:
      - match:
          - receiver: "dump"
  receivers:
    - name: "dump"
      stdout: {}