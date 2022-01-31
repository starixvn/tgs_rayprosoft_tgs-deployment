#!/bin/bash
export brand=$1
export domain=$2
export domain_=$(echo ${domain} | sed -e "s/\./-/g")
export invite_code=$4

echo ${domain_}
envsubst <  ingress-$1.yml | kubectl apply -f - 
