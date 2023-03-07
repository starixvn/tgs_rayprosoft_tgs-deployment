
// install jaeger


https://www.jaegertracing.io/docs/1.29/cli/#jaeger-all-in-one-elasticsearch

kubectl create namespace observability # <1>
kubectl create -f https://github.com/jaegertracing/jaeger-operator/releases/download/v1.29.0/jaeger-operator.yaml -n observability # <

kubectl apply -f 1.RoleBinding.yml
kubectl apply -f configmap.yml
kubectl apply -f ingress.yml

helm repo add jaegertracing https://jaegertracing.github.io/helm-charts

helm -n observability upgrade --install jaeger jaegertracing/jaeger --set provisionDataStore.cassandra=false \
	--set provisionDataStore.elasticsearch=true \
	--set storage.type=elasticsearch 

helm -n observability template jaeger jaegertracing/jaeger --set provisionDataStore.cassandra=false \
	--set provisionDataStore.elasticsearch=true \
	--set storage.type=elasticsearch 



kubectl edit statefulsets elasticsearch-master -n observability


			- mountPath: /usr/share/elasticsearch/config/elasticsearch.yml
              name: elasticsearch
              readOnly: true
              subPath: elasticsearch.yml
      volumes:
        - name: elasticsearch
          configMap:
            name: configmap-elasticsearch
            items:
              - key: elasticsearch
                path: elasticsearch.yml


kubectl edit daemonsets jaeger-agent  -n observability

	  tolerations:
	  - effect: NoSchedule
		key: dedicated
		operator: Exists
		

kubectl delete  daemonsets jaeger-agent -n observability


// uninstall jaeger

helm uninstall jaeger -n observability
kubectl delete pvc elasticsearch-master-elasticsearch-master-0  -n observability
kubectl delete pvc elasticsearch-master-elasticsearch-master-1  -n observability
kubectl delete pvc elasticsearch-master-elasticsearch-master-2  -n observability

kubectl delete -f https://github.com/jaegertracing/jaeger-operator/releases/download/v1.29.0/jaeger-operator.yaml -n observability


///////////////////////////////////////////////////


// install kibana


https://github.com/elastic/helm-charts/tree/main/kibana

helm repo add elastic https://helm.elastic.co


helm install kibana elastic/kibana \
	--set imageTag=7.15.2 \
	--set ingress.enabled=true \
	--set ingress.hosts[0].host=kibana.srvptt.com \
	--set ingress.hosts[0].paths[0]=/ 
	-n observability
	

helm install kibana elastic/kibana \
	--set imageTag=7.15.2 \
	--set ingress.enabled=true \
	--set ingress.hosts[0].host=kibana.rpgp.cc \
	--set ingress.hosts[0].paths[0]=/ \
	-n observability

helm template kibana elastic/kibana \
	--set imageTag=7.15.2 \
	--set ingress.enabled=true \
	--set ingress.hosts[0].host=kibana.rpgp.cc \
	--set ingress.hosts[0].paths[0]=/ \
	-n observability
	
cd observability/kibana/helm-chart
helm template kibana . -f values.yaml -n observability
	
	
helm upgrade --install kibana elastic/kibana -n observability
	
helm upgrade --install kibana elastic/kibana --set imageTag=7.15.2,ingress.enabled=true,ingress.hosts[0].host=kibana.rpgp.cc,ingress.hosts[0].path[0]=/ -n observability

helm template kibana elastic/kibana --set imageTag=7.15.2,ingress.enabled=true,ingress.hosts[0].host=kibana.rpgp.cc,ingress.hosts[0].path[0]=/ -n observability


https://artifacthub.io/packages/helm/elastic/kibana
