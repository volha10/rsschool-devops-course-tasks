#!/bin/bash

# Function to check if a required environment variable is set
check_env_var() {
  for var in "$@"; do
    if [ -z "${!var}" ]; then
      echo "ERROR: Environment variable $var is not set!"
      exit 1
    fi
  done
}

# Check required environment variables.
check_env_var \
  "PROMETHEUS_HOST" \
  "GRAFANA_ADMIN_PASSWORD" \
  "GRAFANA_SMTP_USER" \
  "GRAFANA_SMTP_PASSWORD" \
  "GRAFANA_SMTP_HOST" \
  "GRAFANA_SMTP_FROM_ADDRESS" \
  "GRAFANA_ALERT_RECEIVER_EMAIL"

# Install k3s.
curl -sfL https://get.k3s.io | sh -

mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $(id -u):$(id -g) ~/.kube/config
chmod 600 ~/.kube/config

export KUBECONFIG=~/.kube/config

k3s kubectl get nodes

# Install helm.
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

# Install Prometheus.
kubectl create namespace monitoring

helm upgrade --install prometheus oci://registry-1.docker.io/bitnamicharts/kube-prometheus \
  --set prometheus.service.type=NodePort \
  --set prometheus.service.nodePorts.http=30090 \
  -n monitoring

sleep 100

kubectl get pods -n monitoring

kubectl create secret generic grafana-admin-secret \
  --from-literal=password="$GRAFANA_ADMIN_PASSWORD" \
  --namespace monitoring

envsubst < grafana/datasources.yml | kubectl create secret generic datasource-secret \
  --from-file=datasources.yml=/dev/stdin \
  -n monitoring

kubectl create configmap basic-metrics-dashboard \
  --from-file=grafana/dashboard_layout.json \
  -n monitoring

kubectl create secret generic smtp-secret \
  --from-literal=user="$GRAFANA_SMTP_USER" \
  --from-literal=password="$GRAFANA_SMTP_PASSWORD" \
  --namespace monitoring

envsubst < grafana/alerts.yml | kubectl create configmap grafana-alerts \
  --from-file=alerts.yml=/dev/stdin \
  -n monitoring

# Install Grafana.
envsubst < grafana/values.yml | helm upgrade --install grafana oci://registry-1.docker.io/bitnamicharts/grafana \
    --values /dev/stdin \
    --namespace monitoring \
    --set service.type=NodePort \
    --set service.nodePorts.grafana=31030

sleep 100

kubectl get pods -n monitoring

