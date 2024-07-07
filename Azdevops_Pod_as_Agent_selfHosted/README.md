# Poc of Kubernetes-POD-azure-devops-pipeline-cicd

# Dockerfile and start.sh both required

docker login acrconfiguration.azurecr.io -u acrconfiguration -p C8MG1QpXzCgnKcuFxg5rkd690/dBBrLB6slqtak1KP+ACRCRo8cz
docker build -t acrconfiguration.azurecr.io/myimage:latest .
docker push acrconfiguration.azurecr.io/myimage:latest

kubectl create secret docker-registry acr-secret \
  --docker-server=acrconfiguration.azurecr.io \
  --docker-username=acrconfiguration \
  --docker-password=C8MG1QpXzCgnKcuFxg5rkd690/dBBrLB6slqtak1KP+ACRCRo8cz

# deployment.yaml file for init-agents 
apiVersion: apps/v1
kind: Deployment
metadata:
  name: init-agents-spin-off
spec:
  replicas: 5
  progressDeadlineSeconds: 1800
  selector:
    matchLabels:
      app: init-agents-spin-off
  template:
    metadata:
      labels:
        app: init-agents-spin-off
    spec:
      containers:
        - name: init-agents-spin-off
          image: acrconfiguration.azurecr.io/myimage:latest
          ports:
          - containerPort: 80
          resources:
            requests:
              cpu: 200m
              memory: 200Mi
            limits:
              cpu: 0.5
              memory: 1Gi
          env:
            - name: AZP_POOL
              value: sravanagent
            - name: AZP_TOKEN
              value: dwuffri2xnjyi2u7advcnjhi5sd46dn7elixa6b44el54sf7hiaa
            - name: AZP_URL
              value: https://dev.azure.com/aslammohammad0909
            - name: AGENT_TYPE
              value: 'spin-off'    
      imagePullSecrets:
        - name: acr-secret
