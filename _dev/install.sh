#!/bin/bash
export GP=game-sbo
export GPCODE=SBO
envsubst <  game.yml | kubectl apply -f - 




kubectl create secret generic brand-cert --from-literal=key.pem="$(openssl genrsa 2048)"
