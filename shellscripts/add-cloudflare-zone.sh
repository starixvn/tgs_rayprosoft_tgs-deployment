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


declare -a arr=("mclub001.com" "mclub002.com" "mclub006.com" "mclub007.com" "mclub008.com" "mclub009.com" "mclub010.com" "mclub011.com" "mclub012.com" "mclub013.com" "mclub014.com" "mclub015.com");

response=$(curl -X GET "https://api.cloudflare.com/client/v4/zones?per_page=1000" \
    -H "X-Auth-Email: ${auth_email}" \
    -H "X-Auth-Key: ${auth_key}" \
    -H "Content-Type: application/json") 

#echo ${response} | jq '.result'

declare -i index=0

# FOR DELETE
for zone in $(echo ${response} | jq '.result' | jq  '.[] | .id+","+.name'); do
	IFS=','
    read -a zone_array <<< ${zone}
	zoneid=${zone_array[0]/\"}
    zonename=${zone_array[1]/\"}

	for new_domain in "${arr[@]}"
	do
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

for zone in "${arr[@]}"; do
	echo ${zone}
	result2=$(curl -X POST "https://api.cloudflare.com/client/v4/zones" \
	     -H "X-Auth-Email: ${auth_email}" \
	     -H "X-Auth-Key: ${auth_key}" \
	     -H "Content-Type: application/json" \
	     --data "{\"name\":\"${zone}\",\"account\":{\"id\":\"${account_id}\"},\"jump_start\":false,\"type\":\"full\"}")
	echo ${result2}
	zoneid=$(echo ${result2} | cut -c18-49)

	dns_record_result=$(CreateDnsRecord ${zone} ${zoneid})
	dns_record_result=$(CreateDnsRecord "www" ${zoneid})
	echo ${dns_record_result};
done
