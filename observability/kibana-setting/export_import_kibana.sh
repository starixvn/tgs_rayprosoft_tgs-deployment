#!/bin/bash

# Elasticsearch URLs and credentials
SOURCE_ELASTICSEARCH_URL="https://prod-elasticsearch.rpgp.cc"
DEST_ELASTICSEARCH_URL="https://stg-elasticsearch.rpgp.cc"
SOURCE_USERNAME="elastic"
# PASSWORD=$(kubectl get secret elasticsearch-es-elastic-user -n eck -o jsonpath='{.data.elastic}' | base64 --decode)
SOURCE_PASSWORD="8X48m3649bIN2EUfpiz70mGz"
DEST_USERNAME="elastic"
DEST_PASSWORD="E529DefiNI442OCZb8l24Wg2"

# Kibana URLs
SOURCE_KIBANA_URL="https://kibana.srvptt.com" ## 要看有沒有被 cloudflare 的白名單阻擋
DEST_KIBANA_URL="https://stg-kibana.rpgp.cc"

# Function to generate API key
generate_api_key() {
  local ELASTICSEARCH_URL=$1
  local USERNAME=$2
  local PASSWORD=$3
  echo "Generating API key for $ELASTICSEARCH_URL..."
  API_KEY_RESPONSE=$(curl -X POST "$ELASTICSEARCH_URL/_security/api_key" \
    -u $USERNAME:$PASSWORD \
    -H "Content-Type: application/json" \
    -d '{
      "name": "kibana-api-key",
      "role_descriptors": {
        "kibana_user_role": {
          "cluster": ["all"],
          "index": [
            {
              "names": ["*"],
              "privileges": ["all"]
            }
          ]
        }
      }
    }')

  API_KEY=$(echo $API_KEY_RESPONSE | jq -r '.api_key')
  ID=$(echo $API_KEY_RESPONSE | jq -r '.id')
  ENCODED_API_KEY=$(echo -n "$ID:$API_KEY" | base64)

  if [ -z "$ENCODED_API_KEY" ]; then
    echo "Failed to generate API key for $ELASTICSEARCH_URL."
    exit 1
  fi

  echo "Generated API Key: $ENCODED_API_KEY"
  echo $ENCODED_API_KEY
}

# Function to export Data Views (Saved Objects)
export_data_views() {
  local KIBANA_URL=$1
  local API_KEY=$2
  echo "Exporting Data Views from $KIBANA_URL..."
  curl -X POST "$KIBANA_URL/api/saved_objects/_export" \
       -H "Authorization: ApiKey $API_KEY" \
       -H "kbn-xsrf: true" \
       -H "Content-Type: application/json" \
       -d '{
             "type": ["index-pattern"],
             "includeReferencesDeep": true
           }' -o data_views.ndjson

  if [ $? -ne 0 ]; then
    echo "Failed to export Data Views from $KIBANA_URL."
    exit 1
  fi
}

# Function to import Data Views (Saved Objects)
import_data_views() {
  local KIBANA_URL=$1
  local API_KEY=$2
  echo "Importing Data Views to $KIBANA_URL..."
  curl -X POST "$KIBANA_URL/api/saved_objects/_import" \
       -H "Authorization: ApiKey $API_KEY" \
       -H "kbn-xsrf: true" \
       -H "Content-Type: multipart/form-data" \
       -F file=@data_views.ndjson

  if [ $? -ne 0 ]; then
    echo "Failed to import Data Views to $KIBANA_URL."
    exit 1
  fi
}



export_component_templates() {
    echo "Exporting component templates..."
    curl -X GET "$SOURCE_ELASTICSEARCH_URL/_component_template?pretty" > component_templates.json
}

# Export index templates
export_index_templates() {
    echo "Exporting index templates..."
    curl -X GET "$SOURCE_ELASTICSEARCH_URL/_index_template?pretty" > index_templates.json
}

# Export index lifecycle policies
export_ilm_policies() {
    echo "Exporting index lifecycle policies..."
    curl -X GET "$SOURCE_ELASTICSEARCH_URL/_ilm/policy?pretty" > ilm_policies.json
}

import_component_templates() {
    echo "Importing component templates..."
    local component_templates=$(jq -r '.component_templates[].name' component_templates.json)

    # Debugging output to see if component templates are correctly parsed
    echo "Component templates to be imported:"
    echo "$component_templates"

    for template in $component_templates; do
        # Debugging output to see the individual template being processed
        echo "Processing template: $template"

        template_body=$(jq -c ".component_templates[] | select(.name==\"$template\").component_template | {template: .template}" component_templates.json)
        
        # Debugging output to see the template body
        echo "\nTemplate body for $template:"
        echo "$template_body" | jq

        curl -u $DEST_USERNAME:$DEST_PASSWORD -X PUT "$DEST_ELASTICSEARCH_URL/_component_template/$template" \
            -H 'Content-Type: application/json' \
            -d "$template_body"
        
        # Check if the curl command was successful
        if [ $? -ne 0 ]; then
            echo "Failed to import component template: $template"
            exit 1
        fi
    done
}
import_index_templates() {
    echo "Importing index templates..."
    local index_templates=$(jq -r '.index_templates[].name' index_templates.json)
    for template in $index_templates; do
        echo "index_template=$template"
        template_body=$(jq -c ".index_templates[] | select(.name==\"$template\").index_template | with_entries(select(.value != null))" index_templates.json)
        
        # Debugging output to see the template body
        echo "\nTemplate body for $template:"
        echo "$template_body"

        curl -u $DEST_USERNAME:$DEST_PASSWORD -X PUT "$DEST_ELASTICSEARCH_URL/_index_template/$template" \
            -H 'Content-Type: application/json' \
            -d "$template_body"
        
        # Check if the curl command was successful
        if [ $? -ne 0 ]; then
            echo "Failed to import index template: $template"
            exit 1
        fi
    done
}

# Function to import index lifecycle policies
import_ilm_policies() {
    echo "Importing index lifecycle policies..."
    local ilm_policies=$(jq -r 'keys[]' ilm_policies.json)
    for policy in $ilm_policies; do
        echo "ilm_policy=$policy"
        policy_body=$(jq -c ".\"$policy\" | with_entries(select(.value != null)) | {policy: .policy}" ilm_policies.json)
        
        # Debugging output to see the policy body
        echo "\nPolicy body for $policy:"
        echo "$policy_body"

        curl -u $DEST_USERNAME:$DEST_PASSWORD -X PUT "$DEST_ELASTICSEARCH_URL/_ilm/policy/$policy" \
            -H 'Content-Type: application/json' \
            -d "$policy_body"
        
        # Check if the curl command was successful
        if [ $? -ne 0 ]; then
            echo "Failed to import ILM policy: $policy"
            exit 1
        fi
    done
}


# Main function to coordinate the export and import process
main() {
  # Generate API keys
  SOURCE_API_KEY=$(generate_api_key $SOURCE_ELASTICSEARCH_URL $SOURCE_USERNAME $SOURCE_PASSWORD)
  DEST_API_KEY=$(generate_api_key $DEST_ELASTICSEARCH_URL $DEST_USERNAME $DEST_PASSWORD)

  # Export and import Data Views
  export_data_views $SOURCE_KIBANA_URL $SOURCE_API_KEY
  import_data_views $DEST_KIBANA_URL $DEST_API_KEY

  export_component_templates
  export_index_templates
  export_ilm_policies
	
  import_component_templates
  import_index_templates
  import_ilm_policies
  
  rm component_templates.json
  rm index_templates.json
  rm ilm_policies.json
  
  echo "Data Views backup and restore completed."
}

# Execute the main function
main

