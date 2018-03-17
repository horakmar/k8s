# Předvedení a školení Kubernetes

## Příprava klienta

### Přístup do pískoviště, autokompletace, aliasy

```bash
ssh accessh
cat .bashrc
cat .alias

ls -la /config

```
### Kubectl
Stránky Kubernetes: https://kubernetes.io/docs/home/
Cheat sheet

### Konfigurace klienta

```bash
ls -la .kube
ls -la /config/.kube
cp /config/.kube/config ~/.kube

kubectl config get-contexts
kubectl config use-context kube6-lvik
kubectl get pod
kubectl -n kube-system get pods
```

### Namespaces - pohovořit
```
kubectl get namespace
kubectl get node
```

### Ukázat aliasy
```
kcc?
kcc
```

## Základní příkazy, jednorázové spuštění kontejneru

Deklarativní princip

```
kubectl run --image=busybox busybox --command -- sleep 1000000
kgp
kgd
kubectl get pod ... -o yaml
kubectl get pod ... -o json | jq .
```

### Pohovořit o IP, DNS

```
kubectl exec -ti busybox-7dfc5b889b-lhmzm /bin/bash

cat /etc/hostname
cat /etc/hosts
cat /etc/resolv.conf
env
ip a

kubectl delete deployment busybox

kgp --watch
kgd
```

### Výstup, logy kontejnerů, ladění
```
kubectl run --image=docker.io/busybox busybox --command -- echo "Nazdar"
kubectl logs ...
kubectl describe pod ...

kubectl run --image=docker-registry.cezdata.corp/busybox busybox1 --command -- sh -c 'for i in $(seq 1 10); do echo "Nazdar vole $i."; done'
kgp
kgd
kubectl logs ...
kubectl describe pod ...

kubectl delete deploy busybox busybox1
```
## Spuštění z YAML souboru

#### Příprava - Git
```
cd devel
git pull
cd demo
```


