helm repo add bitnami https://charts.bitnami.com/bitnami

https://github.com/bitnami/charts/tree/master/bitnami/harbor/#installing-the-chart


helm -n harbor upgrade --install harbor bitnami/harbor --set nameOverride=harbor \
  --set trivy.enabled=false \
  --set notary.enabled=false \
  --set chartmuseum.enabled=false \
  --set global.storageClass=gp2 \
  --set service.type=ClusterIP \
  --set externalURL=https://harbor.srvptt.com \
  --set externalRedis.host=redis-master.staging \
  --set harborAdminPassword=harber123 \
  --set postgresql.postgresqlUsername=harbor \
  --set postgresql.postgresqlPassword=harbor123