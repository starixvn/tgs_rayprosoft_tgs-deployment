# https://grafana.com/docs/grafana/latest/developers/http_api/alerting_provisioning/#provisioned-alert-rule
#!/bin/sh
export GRAFANA_TOKEN="glsa_aZLBtligeLcvs7ee3RWgrEvVgiXo5niF_3370c414"
export DOMAIN="grafana-kubeinfo.yydsgo.xyz"

curl -X GET \
	  -H "Authorization: Bearer ${GRAFANA_TOKEN}" \
	 "https://${DOMAIN}/api/v1/provisioning/alert-rules/export" \
	 | jq > './alerts-export.json'
