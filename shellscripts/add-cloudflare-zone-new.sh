#!/bin/bash
auth_email=infrastructure@rayprosoft.com
auth_key=ea16209785cb4fa06858c5571ff5b8057840f
account_id=bca33f2713e936cee007fa34f24a773f
content=ac14ad4ad050b4a71b144385e51a20f5-1241810226.ap-east-1.elb.amazonaws.com

CreateDnsRecord(){
        dns_record=$1
        zone_id=$2

        result=$(curl -X POST "https://api.cloudflare.com/client/v4/zones/$2/dns_records" \
             -H "X-Auth-Email: ${auth_email}" \
             -H "X-Auth-Key: ${auth_key}" \
             -H "Content-Type: application/json" \
             --data '{"type":"CNAME","name":"'$1'","content":"'${content}'","proxied":true}')

	echo ${result}
}

arr[0]="moneyclub8.com n9dv03"
arr[1]="hk2811.com n9dv03" 
arr[2]="hk2812.com eccsml" 
arr[3]="hk2813.com ids9k2"
arr[4]="hk2815.com 8r44wt"
arr[5]="hk2817.com wts48q"
arr[6]="hk2819.com sqfo13"
arr[7]="hk2820.com oxhhu5"
arr[8]="hk2821.com 8j3sfn"
arr[9]="hk2822.com weujfl"
arr[10]="hk2823.com wnkssf"
arr[11]="hk2825.com 8f0opc"
arr[12]="hk2826.com ek07pi"
arr[13]="hk2827.com 7u6578"
arr[14]="hk2830.com tb3e3a"
arr[15]="hk2831.com lh142k"
arr[16]="hk2832.com y9iho6"
arr[17]="hk2833.com lf1imv"
arr[18]="hk2835.com dronyo"
arr[19]="betbet88.net 3lftf4"



response=$(curl -X GET "https://api.cloudflare.com/client/v4/zones?per_page=1000" \
    -H "X-Auth-Email: ${auth_email}" \
    -H "X-Auth-Key: ${auth_key}" \
    -H "Content-Type: application/json") 

#echo ${response} | jq '.result'

declare -i index=0

# FOR DELETE
for zone in $(echo ${response} | jq '.result' | jq  '.[] | .id+","+.name'); do
	IFS=' '
    read -a zone_array <<< ${zone}
	zoneid=${zone_array[0]/\"}
    zonename=${zone_array[1]/\"}

	for ((i=0; i< ${#arr[@]}; i++))
	do
	   read -ra newarr <<< "${arr[i]}"
	   new_domain="${newarr[0]}"
	   
	   if [[ "${new_domain}" == "${zonename}" ]]; then
		   echo $new_domain======$zonename
		   echo ${zoneid}
		url="https://api.cloudflare.com/client/v4/zones/${zoneid}"
		echo "url=${url}"

		result=$(curl -X DELETE "https://api.cloudflare.com/client/v4/zones/${zoneid}" \
		     -H "X-Auth-Email: ${auth_email}" \
		     -H "X-Auth-Key: ${auth_key}" \
		     -H "Content-Type: application/json")
		echo "delete result: $result";
	   fi
	done
done

for zone in "${arr[@]}"; 
for ((i=0; i< ${#arr[@]}; i++))
do
	echo ${zone}
	result2=$(curl -X POST "https://api.cloudflare.com/client/v4/zones" \
	     -H "X-Auth-Email: ${auth_email}" \
	     -H "X-Auth-Key: ${auth_key}" \
	     -H "Content-Type: application/json" \
	     --data "{\"name\":\"${zone}\",\"account\":{\"id\":\"${account_id}\"},\"jump_start\":false,\"type\":\"full\"}")
	echo ${result2}

	zoneid=$(echo ${result2} | cut -c18-49)
	 
	result_automatic_https_rewrites=$(curl -X PATCH "https://api.cloudflare.com/client/v4/zones/${zoneid}/settings/automatic_https_rewrites" \
		 -H "X-Auth-Email: ${auth_email}" \
	     -H "X-Auth-Key: ${auth_key}" \
	     -H "Content-Type: application/json" \
		--data "{\"value\":\"on\"}")
	 
	echo ${result_automatic_https_rewrites}
	 
	result_always_use_https=$(curl -X PATCH "https://api.cloudflare.com/client/v4/zones/${zoneid}/settings/always_use_https" \
		 -H "X-Auth-Email: ${auth_email}" \
	     -H "X-Auth-Key: ${auth_key}" \
	     -H "Content-Type: application/json" \
		--data "{\"value\":\"on\"}")
	
	echo ${result_always_use_https}
	 
	result_minify=$(curl -X PATCH "https://api.cloudflare.com/client/v4/zones/${zoneid}/settings/minify" \
		-H "X-Auth-Email: ${auth_email}" \
	    -H "X-Auth-Key: ${auth_key}" \
	    -H "Content-Type: application/json" \
		--data "{\"value\":{\"css\":\"on\",\"html\":\"on\",\"js\":\"on\"}}")
	 
	echo ${result_minify}
	
	result_brotli=$(curl -X PATCH "https://api.cloudflare.com/client/v4/zones/${zoneid}/settings/brotli" \
		 -H "X-Auth-Email: user@example.com" \
		 -H "X-Auth-Key: c2547eb745079dac9320b638f5e225cf483cc5cfdda41" \
		 -H "Content-Type: application/json" \
		 --data '{"value":"on"}')
		 
	echo ${result_brotli} 
	 
	dns_record_result=$(CreateDnsRecord ${zone} ${zoneid})
	dns_record_result=$(CreateDnsRecord "www" ${zoneid})
	echo ${dns_record_result};
done
