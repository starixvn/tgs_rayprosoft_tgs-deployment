# https://grafana.com/docs/grafana/latest/developers/http_api/alerting_provisioning/#provisioned-alert-rule
#!/bin/sh
export SOURCE_GRAFANA_TOKEN="glsa_aZLBtligeLcvs7ee3RWgrEvVgiXo5niF_3370c414"
export SOURCE_GRAFANA_URL="https://grafana-kubeinfo.yydsgo.xyz/api"
export TARGET_GRAFANA_TOKEN="glsa_rLHiFpTPj3Fv7HJIsjGZJsdAE6L2Z6KO_2072c8b7"
export TARGET_GRAFANA_URL="https://stg-grafana2.rpgp.cc/api"
export OUTPUT_FILE="alerts-export.json"

# 定义一个函数来获取所有 folder 的 title 和 uid
get_all_folder_uids_staging() {
    local json=$(curl -s -X GET -H "Authorization: Bearer ${TARGET_GRAFANA_TOKEN}" "$TARGET_GRAFANA_URL/folders?limit=10")
    
    # 使用 jq 将 JSON 数据转换为 key-value 格式，并存储到关联数组中
    declare -A folder_uids_staging
    while IFS="=" read -r title uid; do
        folder_uids_staging["$title"]="$uid"
    done < <(echo "$json" | jq -r '.[] | "\(.title)=\(.uid)"')
    
    # 使用 declare -p 打印关联数组
    declare -p folder_uids_staging
}

get_all_folder_uids_prod() {
    local json=$(curl -s -X GET -H "Authorization: Bearer ${SOURCE_GRAFANA_TOKEN}" "$SOURCE_GRAFANA_URL/folders?limit=10")
    
    # 使用 jq 将 JSON 数据转换为 key-value 格式，并存储到关联数组中
    declare -A folder_uids_prod
    while IFS="=" read -r title uid; do
        folder_uids_prod["$uid"]="$title"
    done < <(echo "$json" | jq -r '.[] | "\(.title)=\(.uid)"')
    
    # 使用 declare -p 打印关联数组
    declare -p folder_uids_prod
}

# 调用函数并捕获其输出
eval "$(get_all_folder_uids_staging)"
echo "folder_uids_staging=${folder_uids_staging}"
eval "$(get_all_folder_uids_prod)"
echo "folder_uids_prod=${folder_uids_prod}"

json_data=$(curl -X GET \
	  -H "Authorization: Bearer ${SOURCE_GRAFANA_TOKEN}" \
	 "${SOURCE_GRAFANA_URL}/v1/provisioning/alert-rules" | jq)
	 
echo "json_data=$json_data"

# install yq
# sudo wget https://github.com/mikefarah/yq/releases/download/v4.18.1/yq_linux_amd64 -O /usr/local/bin/yq
# sudo chmod +x /usr/local/bin/yq
# sudo apt-get install jq -y


# Loop through each group in the JSON data
echo "$json_data" | jq -c '.[]' | while read rule; do
	echo "==========================================="
	echo "$rule"
	## fix cannot convert to json format
	rule=$(echo "$rule" | sed 's/container_memory_working_set_bytes{namespace="prod",job="kubelet",container!="monitor",container!=""}/container_memory_working_set_bytes{namespace=\\"staging\\",job=\\"kubelet\\",container!=\\"monitor\\",container!=\\"\\"}/g' | sed 's/container_spec_memory_limit_bytes{namespace="prod",container!="monitor",container!="",job="kubelet"}/container_spec_memory_limit_bytes{namespace=\\"prod\\",container!=\\"monitor\\",container!=\\"\\" ,job=\\"kubelet\\"}/g')
	rule=$(echo "$rule" | sed 's/namespace="prod"/namespace=\\"staging\\"/g' | sed 's/job="kubelet"/job=\\"kubelet\\"/g' | sed 's/container!="monitor"/container!=\\"monitor\\"/g' | sed 's/container!=""/container!=\\"\\"/g')
	rule=$(echo "$rule" | sed 's/namespace="prod",job="kubelet",container!="monitor",container!=""/namespace=\\"staging\\",job=\\"kubelet\\",container!=\\"monitor\\",container!=\\""/g')
	rule=$(echo "$rule" | sed 's/database="tgs"/database=\\"tgs\\"/g')
	rule=$(echo "$rule" | sed 's/namespace!~""}/namespace!~\\"\\"}/g')
	rule=$(echo "$rule" | sed 's/namespace!=""}/namespace!=\\"\\"}/g')
	echo "\n"
	echo "$rule"
    id=$(echo "$rule" | jq -r '.id')
    uid=$(echo "$rule" | jq -r '.uid')
	folderUID=$(echo "$rule" | jq -r '.folderUID')
    orgID=$(echo "$rule" | jq -r '.orgID')
    ruleGroup=$(echo "$rule" | jq -r '.ruleGroup')
    title=$(echo "$rule" | jq -r '.title')

    # Print or process the extracted values
    echo "Processing rule:"
    echo "  id: $id"
    echo "  uid: $uid"
	echo "  folderUID: $folderUID"
	echo "${folder_uids_prod[$folderUID]}"
	folder=${folder_uids_prod[$folderUID]}
	folderUid=${folder_uids_staging[$folder]}
	echo "======folder=>${folder}======"
	echo "======folderUid=>${folderUid}======"
    echo "  orgID: $orgID"
    echo "  ruleGroup: $ruleGroup"
    echo "  title: $title"
	
	rule_json=$(echo "$rule" | jq '.')
	echo "old_rule_json=$rule_json"
	modified_json=$(echo "$rule_json" | jq --arg new_uid "$folderUid" '.folderUID = $new_uid')
	echo "new_rule_json=$modified_json"

	# Make the POST request to provision the alert rule
	response=$(curl -s -X POST \
		-H "Authorization: Bearer $TARGET_GRAFANA_TOKEN" \
		-H "Content-Type: application/json" \
		-d "$modified_json" \
		"$TARGET_GRAFANA_URL/v1/provisioning/alert-rules")

	echo "Response: $response"
done