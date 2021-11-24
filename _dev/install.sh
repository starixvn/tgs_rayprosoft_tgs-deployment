#!/bin/bash
export GP=game-sbo
export GPCODE=SBO
envsubst <  game.yml | kubectl apply -f - 
