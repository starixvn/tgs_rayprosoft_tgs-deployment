客戶端安裝

先去github找最新的release，所以下載velero-v1.8.1-linux-amd64.tar.gz

wget https://github.com/vmware-tanzu/velero/releases/download/v1.8.1/velero-v1.8.1-linux-amd64.tar.gz

#載回來後解壓縮出來的資料夾裡面有一個velero的執行檔，把它放到usr/local/bin裡面

cp velero /usr/local/bin

之後直接輸入velero看有沒有跑出可輸入指令，有的話客戶端就能用了



伺服器端安裝(用helm)

helm repo add vmware-tanzu https://vmware-tanzu.github.io/helm-charts/

helm pull vmware-tanzu/velero


#因為使用AWS的S3，所以都以AWS的設定為準

#這區的原本有#號，直接移除讓這邊設定生效就好
#這區沒設定的話，pod不會啟動
initContainers:
  - name: velero-plugin-for-aws
    image: velero/velero-plugin-for-aws:v1.3.0
    imagePullPolicy: IfNotPresent
    volumeMounts:
      - mountPath: /target
        name: plugins
#這區如下設定就好，區域預設是us-east-1
configuration:
  provider: aws
  backupStorageLocation:
    name:
    provider: aws
    bucket: sealtest #連過去的S3的bucket名稱
#這區還沒測試
  volumeSnapshotLocation:
    name: snapshots
    provider: aws
    config: 
      region: us-east-1  
#這區設定連到secert的帳密
credentials:
  useSecret: true
  name: 
  existingSecret: cloud #就是剛剛上面創建secret的名稱 
  secretContents: #如果不想用secert，就照下面的填入就好，跟secert的內容一樣
    #cloud: |
      #[default]
      #aws_access_key_id=aws_access_key_id
      #aws_secret_access_key=aws_secret_access_key
  extraEnvVars: {}
  extraSecretRef: ""     
  

helm upgrade --install velero  vmware-tanzu/velero --namespace velero -f values.yaml

helm template velero  vmware-tanzu/velero --namespace velero -f values.yaml



kubectl get  BackupStorageLocation -n velero

velero backup-location get
