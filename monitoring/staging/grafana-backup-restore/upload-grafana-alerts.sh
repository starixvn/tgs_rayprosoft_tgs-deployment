# https://community.grafana.com/t/ngalert-grafana-8-alert-feature-how-to-export-import-alerts-as-yml-json/51677/22?u=sarasensible
#!/bin/sh
ALERTS_JSON_PATH=./alerts.json
NUMBER_OF_ALERTS=$(jq -c '.Alert | length' ${ALERTS_JSON_PATH})
GRAFANA_TOKEN="glsa_LTTGR8fcwQ9Y8iT6beeZJ6008DwxTcoV_f11f93d7"
DOMAIN=stg-grafana2.rpgp.cc

for ((i=0; i<NUMBER_OF_ALERTS; i++)); do
  ALERT_OBJECT=$(jq -c --arg i "$i" '.Alert[($i | tonumber)] | del(.rules[0].grafana_alert.uid)' ${ALERTS_JSON_PATH})
  ALERT_NAME=$(jq -c --arg i "$i" '.Alert[($i | tonumber)].name' ${ALERTS_JSON_PATH})
  echo "Creating ${ALERT_NAME}...\n"
	response=$(Ocurl -X POST \
		-H "Authorization: Bearer ${GRAFANA_TOKEN}" \
		-H "Content-type: application/json" \
		"https://$DOMAIN/api/ruler/grafana/api/v1/rules/$FOLDER_NAME" \
		-d "${ALERT_OBJECT}")
	echo "response=$response"
	echo "\n"
done