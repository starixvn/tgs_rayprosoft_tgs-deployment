# https://community.grafana.com/t/ngalert-grafana-8-alert-feature-how-to-export-import-alerts-as-yml-json/51677/22?u=sarasensible
#!/bin/sh
export GRAFANA_TOKEN="glsa_aZLBtligeLcvs7ee3RWgrEvVgiXo5niF_3370c414"
export DOMAIN="http://grafana-kubeinfo.yydsgo.xyz"

curl -X GET \
	  -H "Authorization: Bearer ${GRAFANA_TOKEN}" \
	 "https://${DOMAIN}/ruler/grafana/api/v1/rules" \
	 | jq > './alerts.json'