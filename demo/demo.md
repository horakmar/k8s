# Kubernetes 2

## A) Přístup do pískoviště, autokompletace, aliasy

```
ssh accessh
```

#### .bashrc
```
...
source <(kubectl completion bash)
```

#### .alias
```
# Kubernetes
kuba () {
        kubectl $@ --all-namespaces
}

kexe () {
        kubectl exec -ti $@ /bin/bash || kubectl exec -ti $@ /bin/sh
}

alias kub="kubectl"
alias kubs="kubectl -n kube-system"
alias kgp="kubectl get pods -o wide"
alias kgd="kubectl get deploy"
alias kdp="kubectl describe pod"
alias kgdw="kubectl get deploy -o wide"
alias kgs="kubectl get services -o wide"
alias kgse="kubectl get secret"
alias ksgp="kubectl -n kube-system get pods -o wide"
alias kc="kubectl config"
alias kcc?="kubectl config get-contexts"
alias kcc="kubectl config use-context"
alias kcn='kubectl config set-context $(kubectl config current-context) --namespace'

# Docker
alias dockrm='docker rm $(docker ps -qa --no-trunc --filter "status=exited")'
alias dockrmi='docker rmi $(docker images --filter "dangling=true" -q --no-trunc)'
alias drmall='docker rm -f $(docker ps -a -q)'

# OpenSSL
alias crt='openssl x509 -noout -text'
```

### Kubectl
Dokumentace Kubernetes: https://kubernetes.io/docs/home/  
Cheat sheet: https://kubernetes.io/docs/reference/kubectl/cheatsheet/

```
kubectl cluster-info
```

### Namespaces
```
kubectl get node
kubectl get namespace
```

### Konfigurace klienta
V souboru .kube/config

```
kubectl config get-contexts

export KUBECONFIG=~/.kube/config.kube5
kubectl config get-contexts

unset KUBECONFIG
kubectl config get-contexts

kubectl config use-context kube6
kcn kube-system
kubectl get pod
kcn lvik
kgp
kubectl -n kube-system get pods
```

## Image registry
[Docker Hub](https://hub.docker.com/)  
[Quay.io](https://quay.io/)  
[gcr.io](https://console.cloud.google.com/gcr/images/google-containers/GLOBAL)  


## B) Základní příkazy, jednorázové spuštění kontejneru

Je použit deklarativní princip - nastavím jak má vypadat cílový stav a cluster se ho snaží dosáhnout.

```
kubectl run --image=busybox busybox --command -- sleep 1000000
kubectl get deploy -o wide
kubectl get pod -o wide
kubectl get pod ... -o yaml
kubectl get pod ... -o json | jq .
```

### Práce s kontejnery

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

## C) Spuštění kontejneru popsaného v YAML souboru

#### Příprava - Git
```
git clone gitguard@git.cezdata.corp:lhm--k8s.git k8s
cd k8s/demo
```

### 1) Nginx v default konfiguraci přímo z Docker hubu

##### Příklad:
  - Připravíme objekt Service pro přístup k WWW socketu kontejneru
  - Vytvoříme Deployment se standardním image Nginx z Docker Hubu
  - Vyzkoušíme přístup

#### Service
```
vim nginx_svc.yaml
kub apply -f nginx_svc.yaml

kubectl describe service nginx
host nginx.lvik.svc.kube6.corp
```

#### Deployment
```
vim nginx_1.yaml
kub apply -f nginx_1.yaml

kubectl describe service nginx
```

```
curl http://nginx.lvik.svc.kube6.corp
```
Test browserem
```
kub delete deploy nginx
```

### 2) Nginx z upraveného image s konfigurací v ConfigMap

##### Příklad:
  - Připravíme modifikovaný image
  - Připravíme objekt ConfigMap s konfigurací
  - Vytvoříme Deployment s použitím ConfigMap a vlastního image
  - Vyzkoušíme rozmnožení Deploymentu do více Podů pomocí **kubectl scale**

#### Příprava image - jak pracovat s Dockerem
Dockerfile - dokumentace: https://docs.docker.com/engine/reference/builder/

Pro sestavení image je možné použít Docker lokální, nebo vzdálený:
```
export DOCKER_HOST=tcp://172.28.114.18:2375
docker images
```

#### Struktura nginx image
```
/
├─ entrypoint.sh
└─ etc/nginx/
        ├─ nginx.conf   ... v image
        └─ conf.d/
              ├─ default.conf   ...
              └─ ssl.conf       ... v ConfigMap
```

Je vhodné držet související informace na stejné úrovni (image vs deployment).  
Proto entrypoint.sh provádí v default.conf a ssl.conf nahrazení server_name hodnotou z ENV.

#### Docker build
```
cd image/nginx

docker build .
docker tag <id> <tag>

nebo

docker build -t <tag>

docker push <tag>
```

#### Vytvoření ConfigMap
```
cd config
cat default.conf
cat ssl.conf

cat Makefile

make cm_nossl
kubectl delete configmap nginx-conf
kubectl get configmap
kubectl describe configmap nginx-conf
```

#### Deployment
```
cat nginx_2.yaml
kub apply -f nginx_2.yaml

curl http://nginx.lvik.svc.kube6.corp/hostname

kubectl scale deploy/nginx --replicas=7
kubectl describe svc nginx

kubectl scale deploy/nginx --replicas=1

kub delete deploy nginx
```

### 3) Nginx s persistent storage a konfigurací v ConfigMap a Secret

##### Příklad:
  - Připravíme objekt Secret s klíči pro SSL
  - Připravíme PersistentVolumeClaim
  - Vytvoříme Deployment s použitím vytvořených objektů
  - V kontejneru zapíšeme na Persistent Volume
  - Smažeme Deployment, vytvoříme znovu
  - Zapsaná data na PV zůstanou

#### Příprava PKI - uloženo v Kubernetes jako Secret
```
cd pki
make
...
make gensecret
```

#### Příprava persistent storage

##### Storageclass - na Kube6 nakonfigurována s použitím storage z Cephu
```
kubectl get storageclass
kubectl get storageclass ceph -o json | jq .
```

##### PV a PVC
```
cat pvc.yaml
kubectl apply -f pvc.yaml
kubectl get pvc
kubectl get pv
```

#### Deployment
```
vim nginx_3.yaml
# livenessProbe

kub apply -f nginx_3.yaml

kgp
kexe ...

df
cd /usr/share/nginx/html
echo "<h1>Nejaky obsah</h1>" >index.html

curl http://nginx.lvik.svc.kube6.corp/

kub delete deploy nginx

kub get pvc
kub get pv

kub apply -f nginx_3.yaml

curl http://nginx.lvik.svc.kube6.corp/

kub delete deploy nginx

```

### 4) Nginx s persistent storage jako StatefulSet
StatefulSet je objekt podobný Deploymentu, ale Kubernetes se k němu chová trochu jinak, hlavně v oblasti storage.
Slouží pro spouštění stateful aplikací.

##### Příklad:
  - Vytvoříme StatefulSet s Nginx kontejnerem
    - V rámci StatefulSet je vytvořen Persistent Volume
  - Zkopírujeme nějaký obsah do HTML prostoru
  - Smažeme StatefulSet, PV zůstane
  - Vytvoříme StatefulSet znovu, zkopírovaná data zůstanou

```
vim nginx_4.yaml
# resources

kub apply -f nginx_4.yaml

kubectl get statefulset -o wide

cd aux
kubectl cp lion.jpg nginx4-0:/usr/share/nginx/html
kubectl cp index.html nginx4-0:/usr/share/nginx/html

kexe ...
chown ...

kubectl delete -f nginx_4.yaml

kub apply -f nginx_4.yaml

kub delete -f nginx_4.yaml
```

### 5) Kombinace nginx a sshd kontejneru
V rámci jednoho Podu je možné spustit více kontejnerů. Ty pak sdílí síť a storage *zhruba* tak jako procesy na jednom hostu.

##### Příklad:
  - Připravíme sadu SSH klíčů pro přístup do SSHD kontejneru - jako ConfigMap
  - Vytvoříme StatefulSet se dvěma kontejnery - Nginx a SSHD
  - Vyzkoušíme změnu dat v HTML prostoru Nginx serveru pomocí přístupu přes SSHD kontejner

```
cd image/sshd

cd ssh-keys

kub apply -f nginx_5.yaml
```

