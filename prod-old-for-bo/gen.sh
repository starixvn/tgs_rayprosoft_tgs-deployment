#!/bin/sh
kubectl get deploy $1 -n prod -o yaml > $1.yaml
echo "---" >> $1.yaml
kubectl get svc $1 -n prod -o yaml >> $1.yaml
echo "---" >> $1.yaml
kubectl get cm configmap-$1 -n prod -o yaml >> $1.yaml
git add .
git commit -m "add $1.yaml"
git push

