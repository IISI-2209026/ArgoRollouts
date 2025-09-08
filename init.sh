# 創建集群
kind create cluster --config=kind-config.yaml --wait=300s

# 驗證集群
kubectl cluster-info
kubectl get nodes

# 安裝 NGINX Ingress Controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

# 等待 Ingress Controller 就緒
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s


# 創建命名空間
kubectl create namespace argo-rollouts

# 安裝 Argo Rollouts
kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml

# 等待部署完成
kubectl rollout status deployment/argo-rollouts -n argo-rollouts

# 安裝 kubectl plugin
curl -LO https://github.com/argoproj/argo-rollouts/releases/latest/download/kubectl-argo-rollouts-linux-amd64
chmod +x ./kubectl-argo-rollouts-linux-amd64
sudo mv ./kubectl-argo-rollouts-linux-amd64 /usr/local/bin/kubectl-argo-rollouts

# 驗證安裝
kubectl argo rollouts version

# 啟動 Dashboard
kubectl argo rollouts dashboard &

# 在瀏覽器訪問: http://localhost:3100