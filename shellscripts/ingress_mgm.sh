#!/bin/bash

export domain=$1
export invite_code=$2
export domain_=echo ${domain} | sed -e "s/./-/g"

envsubst <  ingress-mgm.yml | kubectl apply -f - 
