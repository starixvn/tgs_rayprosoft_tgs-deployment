#!/bin/bash

echo $1 $2 $3
export brand=$1
export domain=$2
export invite_code=$3

echo ${brand} ${domain} ${invite_code}

export domain_=echo "${domain}" | sed -e "s/./-/g"

echo $domain_
#envsubst <  ingress-$1.yml | kubectl apply -f - 
