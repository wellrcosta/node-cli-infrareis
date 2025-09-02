name: {{projectName}}
namespace: local-services
imageRepo: docker.io/wellrcosta/{{projectName}}
tag: latest
pullPolicy: IfNotPresent
imagePullSecrets:
  - registry-cred
replicas: 2
port: 80
expose: http
host: {{projectName}}.192.168.1.150.nip.io
ingressClassName: traefik
ingressAnnotations: {}
resources:
  requests:
    cpu: 100m
    memory: 128Mi
  limits:
    cpu: 1000m
    memory: 512Mi
readinessProbe:
  enabled: true
  path: /health
  initialDelaySeconds: 5
  periodSeconds: 10
livenessProbe:
  enabled: true
  path: /health
  initialDelaySeconds: 15
  periodSeconds: 20
cron:
  enabled: false
  schedule: '*/5 * * * *'
  command:
    - node
    - scripts/run-cron.js
