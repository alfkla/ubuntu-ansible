
wget -q -O - https://packages.grafana.com/gpg.key | apt-key add -
add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
apt-get update -y
apt-get install grafana -y
systemctl enable --now grafana-server
systemctl start grafana-server

