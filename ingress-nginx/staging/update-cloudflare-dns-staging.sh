#!/bin/bash
export token="0urb613nnL1aiyuKO_shCaCyfIPVhhXQhh3RKEaH"
export old_content="ac93c3550b9974b7b932661583bf9912-2029401609.ap-east-1.elb.amazonaws.com"
new_content=$1

domains=("rpgp.cc" "pgdemo.site")
for domain in ${domains[@]}; do
  echo "Domain: $domain "
  
  response=$(curl -X GET "https://api.cloudflare.com/client/v4/zones?per_page=1000&name=$domain" \
    -H "Authorization: Bearer $token" \
    -H "Content-Type: application/json") 

  declare -i index=0
  declare -i dns_index=0
  declare -i count=0

  for zoneid in $(echo ${response} | jq '.result' | jq -r '.[].id'); do

    echo ${response} | jq '.result' | jq -r ".[${index}].name"
    index=$((index+1))
    dns_index=$((0))
    echo "ZONE_ID=${zoneid}"
     
    dnsrecordResponse=$(curl -X GET "https://api.cloudflare.com/client/v4/zones/${zoneid}/dns_records?per_page=1000&content=${old_content}" \
      -H "Authorization: Bearer $token" \
      -H "Content-Type: application/json")

    #echo ${dnsrecordResponse} | jq '.result' | jq '.[]'

    for dnsid in $(echo ${dnsrecordResponse} | jq '.result' | jq -r '.[].id'); do 
      dnsname=$(echo ${dnsrecordResponse} | jq '.result' | jq -r ".[${dns_index}].name")
      proxied=$(echo ${dnsrecordResponse} | jq '.result' | jq -r ".[${dns_index}].proxied") 
      content=$(echo ${dnsrecordResponse} | jq '.result' | jq -r ".[${dns_index}].content") 
      
      dns_index=$((dns_index+1))
      echo "dns_name: ${dnsname}" 
      echo "dns_proxied: ${proxied}"
      echo "dnsid: ${dnsid}"
      echo "content: ${content}"

      result=$(curl -X PUT "https://api.cloudflare.com/client/v4/zones/${zoneid}/dns_records/${dnsid}" \
        -H "Authorization: Bearer $token" \
        -H "Content-Type: application/json" \
        --data "{\"type\":\"CNAME\",\"name\":\"${dnsname}\",\"content\":\"${new_content}\",\"proxied\":${proxied}}")
        
      echo ${result} | jq 
      echo "================"
    done 
  done
done