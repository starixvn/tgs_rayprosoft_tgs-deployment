#!/bin/bash
for p in $(kubectl get ing -n prod | grep acme | awk '{print $3}'); do
        for ing in $(kubectl get ing -n prod | grep $p  | grep -v acme | awk '{print $1}'); do
                kubectl delete ing $ing -n prod
                echo "ing $ing is deleted."
        done;

    echo "====$p===="
done;

for p in $(kubectl get ing -n prod | grep acme | awk '{print $3}'); do
        for cert in $(kubectl get certificate -n prod | grep $p | awk '{print $1}'); do
                kubectl delete certificate $cert -n prod
                echo "certificate $cert is deleted."
        done;

    echo "====$p===="
done;
