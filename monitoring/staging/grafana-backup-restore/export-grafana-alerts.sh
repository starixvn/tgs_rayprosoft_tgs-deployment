# https://grafana.com/docs/grafana/latest/developers/http_api/alerting_provisioning/#provisioned-alert-rule
#!/bin/sh
export SOURCE_GRAFANA_TOKEN="glsa_aZLBtligeLcvs7ee3RWgrEvVgiXo5niF_3370c414"
export SOURCE_GRAFANA_URL="https://grafana-kubeinfo.yydsgo.xyz/api"
export TARGET_GRAFANA_TOKEN="glsa_lO7k65hGSSCzWQxZYyWS38PeUpARZA0I_a640e626"
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

# install yq
# sudo wget https://github.com/mikefarah/yq/releases/download/v4.18.1/yq_linux_amd64 -O /usr/local/bin/yq
# sudo chmod +x /usr/local/bin/yq
# sudo apt-get install jq -y

json_data=$(yq eval -o=json "${OUTPUT_FILE}")

# Loop through each group in the JSON data
echo "$json_data" | jq -c '.[]' | while read rule; do
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
done