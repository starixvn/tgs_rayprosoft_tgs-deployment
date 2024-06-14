# https://grafana.com/docs/grafana/latest/administration/roles-and-permissions/access-control/plan-rbac-rollout-strategy/
#!/bin/bash 
export TARGET_GRAFANA_TOKEN="glsa_G8JdXgFME50LIkMdmk1kT4SIBzae3BfN_e07d97b9"
export TARGET_GRAFANA_URL="https://stg-grafana2.rpgp.cc/api"

json_data=$(curl -X GET \
	  -H "Authorization: Bearer ${TARGET_GRAFANA_TOKEN}" \
	 "${TARGET_GRAFANA_URL}/v1/provisioning/alert-rules" | jq)
	 
# Loop through each group in the JSON data
echo "$json_data" | jq -c '.[]' | while read rule; do
	echo "==========================================="
	## fix cannot convert to json format
	rule=$(echo "$rule" | sed 's/job="kubelet"/job=\\"kubelet\\"/g')
	rule=$(echo "$rule" | sed 's/container!=""/container!=\\"\\"/g')
	rule=$(echo "$rule" | sed 's/container!="monitor"/container!=\\"monitor\\"/g')
	rule=$(echo "$rule" | sed 's/job="kubelet"/job=\\"kubelet\\"/g')
	rule=$(echo "$rule" | sed 's/database="tgs"/database=\\"tgs\\"/g')
	rule=$(echo "$rule" | sed 's/namespace="staging"/namespace=\\"staging\\"/g')
	rule=$(echo "$rule" | sed 's/namespace!~""/namespace!~\\"\\"/g')
	rule=$(echo "$rule" | sed 's/namespace!=""/namespace!=\\"\\"/g')
	rule=$(echo "$rule" | sed 's/namespace="prod"/namespace=\\"prod\\"/g')
	
	echo $rule
	uid=$(echo $rule | jq -r '.uid' )
	
	echo "uid=$uid"

	# Make the POST request to provision the alert rule
	response=$(curl -s -X DELETE \
		-H "Authorization: Bearer $TARGET_GRAFANA_TOKEN" \
		-H "Content-Type: application/json" \
		"$TARGET_GRAFANA_URL/v1/provisioning/alert-rules/$uid")

	echo "Response: $response"
done
