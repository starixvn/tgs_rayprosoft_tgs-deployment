# https://github.com/resmoio/kubernetes-event-exporter/tree/master/charts/kubernetes-event-exporter


helm repo add kubernetes-event-exporter https://resmoio.github.io/kubernetes-event-exporter
helm update

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