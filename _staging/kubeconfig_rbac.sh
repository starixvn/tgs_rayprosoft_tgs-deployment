#!/bin/bash
export account=staging-admin
export namespace=staging
kubectl -n $namespace create serviceaccount $account
cat << EOF | kubectl apply -n $namespace -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: ${account}
  namespace: ${namespace}
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: admin
subjects:
- kind: ServiceAccount
  name: ${account}
  namespace: ${namespace}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: ${account}-view-all
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: view
subjects:
- kind: ServiceAccount
  name: ${account}
  namespace: ${namespace}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: ${account}-view-node
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: view-node
subjects:
- kind: ServiceAccount
  name: ${account}
  namespace: ${namespace}
EOF