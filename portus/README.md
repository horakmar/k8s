# Portus deployment

```bash
kubectl create namespace portus

helm install --namespace portus --name portus -f mariadb.helm.config.yaml stable/mariadb

kubectl apply -f portus-secret.yaml

kubectl apply -f registry-pvc.yaml,registry-service.yaml,registry-configmap.yaml
kubectl apply -f registry-deployment.yaml

kubectl apply -f portus-configmap.yaml,portus-service.yaml
kubectl apply -f portus-deployment.yaml

kubectl apply -f nginx-configmap.yaml,nginx-service.yaml
kubectl apply -f nginx-deployment.yaml

```
