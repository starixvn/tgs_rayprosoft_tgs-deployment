#!/bin/bash
export brand=$1
export domain=$2
export domain_=$3
export invite_code=$4

envsubst <  ingress-$1.yml | kubectl apply -f - 
