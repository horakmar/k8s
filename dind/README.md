# Docker in docker deployment

Create DNS record:
    nsupdate <<EOF
    update add dind.infra.cl.corp 86400 A 172.28.112.239
    send
    EOF

Create dind deployment:
    kubectl apply -f dind-all.yaml

