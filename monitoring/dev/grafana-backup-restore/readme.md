### grafana backup/restore
sudo apt install -y python-pip
sudo apt install -y python3-pip

git clone https://github.com/ysde/grafana-backup-tool.git
cd grafana-backup-tool
apt install python3-pip
sudo pip install .

cp examples/grafana-backup.example.json grafana-backup.json
cp examples/grafana-backup.example.json grafana-restore.json

sudo grafana-backup save --config=/root/tgs-deployment/monitoring/dev/grafana-backup-restore/backup-dev.json
sudo grafana-backup restore --config=restore-dev.json   _OUTPUT_/202211250207.tar.gz


# create token of grafana
https://grafana.com/docs/grafana/latest/developers/http_api/create-api-tokens-for-org/

on postman

eyJrIjoiMEV2aHNEOUFKQm5RTjVzaEdKY25aYXNlQWdybzZoZGwiLCJuIjoiYXBpa2V5Y3VybCIsImlkIjoyfQ

### k8s grafana backup

kubectl apply -f backup-cronjob-dev.yaml

#### dev

grafana 
password: EvTZYjTJ0eIDrWsIuo9GqGiNdQflRtneQnStkICJ
backup 
token: eyJrIjoiUEVzWTgxT2tobGxBMUt3TE4wQUdpQ2NZaE5maTlEWHYiLCJuIjoiYmFja3VwIiwiaWQiOjF9
curl -H "Authorization: Bearer eyJrIjoiUEVzWTgxT2tobGxBMUt3TE4wQUdpQ2NZaE5maTlEWHYiLCJuIjoiYmFja3VwIiwiaWQiOjF9" https://grafana.rpgp.cc/api/dashboards/home


grafana2 
password: E4aY66CizH8aYT8TDQkiJkVZCamRXtndS1OB2GLw
backup
token: eyJrIjoiMms0UjNaTW40WjZhMHJpZDJhT2dKSFlBSkhtbVhWT2kiLCJuIjoicmVzdG9yZSIsImlkIjoxfQ==
curl -H "Authorization: Bearer eyJrIjoiMms0UjNaTW40WjZhMHJpZDJhT2dKSFlBSkhtbVhWT2kiLCJuIjoicmVzdG9yZSIsImlkIjoxfQ==" https://grafana2.rpgp.cc/api/dashboards/home

sudo grafana-backup restore --config=grafana-restore.json   _OUTPUT_/202211250207.tar.gz

### Notification Settings

go to Alert > Contact points > New contact point


tgs_user_bot TOKEN: 1652136804:AAFWBATSiBh-6wNIpoUXHCRNwSOa5J3fVfw
