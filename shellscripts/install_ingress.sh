#!/bin/bash

export domain=$2
export invite_code=$3
export domain_=echo ${domain} | sed -e "s/./-/g"

echo $domain_
#envsubst <  ingress-$1.yml | kubectl apply -f - 
