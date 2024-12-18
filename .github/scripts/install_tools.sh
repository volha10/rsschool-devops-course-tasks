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
check_env_var "GRAFANA_ADMIN_PASSWORD" "PROMETHEUS_HOST"

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

kubectl get all -n monitoring

kubectl create secret generic grafana-admin-secret \
  --from-literal=password="$GRAFANA_ADMIN_PASSWORD" \
  --namespace monitoring

envsubst < grafana/datasource-secret.yml | kubectl create secret generic datasource-secret --from-file=datasource-secret.yml=/dev/stdin -n monitoring

kubectl create configmap basic-metrics-dashboard \
  --from-file=grafana/dashboard_layout.json \
  -n monitoring

helm upgrade --install grafana oci://registry-1.docker.io/bitnamicharts/grafana \
    --values grafana/values.yml \
    --namespace monitoring \
    --set service.type=NodePort \
    --set service.nodePorts.grafana=31030

sleep 100

kubectl get pods -n monitoring

