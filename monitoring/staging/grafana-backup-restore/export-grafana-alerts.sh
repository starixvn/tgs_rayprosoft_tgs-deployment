# https://grafana.com/docs/grafana/latest/developers/http_api/alerting_provisioning/#provisioned-alert-rule
#!/bin/sh
export SOURCE_GRAFANA_TOKEN="glsa_aZLBtligeLcvs7ee3RWgrEvVgiXo5niF_3370c414"
export SOURCE_GRAFANA_DOMAIN="grafana-kubeinfo.yydsgo.xyz"
export TARGET_GRAFANA_TOKEN="glsa_lO7k65hGSSCzWQxZYyWS38PeUpARZA0I_a640e626"
export TARGET_GRAFANA_URL="https://stg-grafana2.rpgp.cc/api/v1/provisioning/alert-rules"
export OUTPUT_FILE="alerts-export.yaml"

curl -X GET \
	  -H "Authorization: Bearer ${SOURCE_GRAFANA_TOKEN}" \
	 "https://${SOURCE_GRAFANA_DOMAIN}/api/v1/provisioning/alert-rules/export" -o ${OUTPUT_FILE}

# install yq
# sudo wget https://github.com/mikefarah/yq/releases/download/v4.18.1/yq_linux_amd64 -O /usr/local/bin/yq
# sudo chmod +x /usr/local/bin/yq
# sudo apt-get install jq -y

yaml_file="alerts-export.yaml"
json_data=$(yq eval -o=json "${OUTPUT_FILE}")

# Loop through each group in the JSON data
echo "$json_data" | jq -c '.groups[]' | while read group; do
    orgId=$(echo "$group" | jq -r '.orgId')
    name=$(echo "$group" | jq -r '.name')
    folder=$(echo "$group" | jq -r '.folder')
    interval=$(echo "$group" | jq -r '.interval')
    
    # Process each group as needed
    echo "Processing group:"
    echo "  orgId: $orgId"
    echo "  name: $name"
    echo "  folder: $folder"
    echo "  interval: $interval"
    # Loop through each rule in the group
    echo "$group" | jq -c '.rules[]' | while read rule; do
        rule_json=$(echo "$rule" | jq '.')
		
		echo "rule_json=$rule_json"
	
        # Make the POST request to provision the alert rule
        response=$(curl -s -X POST \
            -H "Authorization: Bearer $TARGET_GRAFANA_TOKEN" \
            -H "Content-Type: application/json" \
            -d "$rule_json" \
            "$TARGET_GRAFANA_URL")

        echo "Response: $response"
    done
done