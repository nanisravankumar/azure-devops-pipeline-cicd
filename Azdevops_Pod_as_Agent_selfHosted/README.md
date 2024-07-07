# Poc of Kubernetes-POD-azure-devops-pipeline-cicd

**Dockerfile and start.sh both required pasted below**


https://github.com/nanisravankumar/azure-devops-pipeline-cicd/blob/master/Azdevops_Pod_as_Agent_selfHosted/agents/agents/automation-agents/Dockerfile.dockerfile
https://github.com/nanisravankumar/azure-devops-pipeline-cicd/blob/master/Azdevops_Pod_as_Agent_selfHosted/agents/agents/automation-agents/start.sh

**Docker Login Command**

docker login acrconfiguration.azurecr.io -u acrconfiguration -p C8MG1QpXzCgnKcuFxg5rkd690/dBBrLB6slqtak1KP+ACRCRo8cz
docker build -t acrconfiguration.azurecr.io/myimage:latest .
docker push acrconfiguration.azurecr.io/myimage:latest

**Kubernetes secret creation command**

kubectl create secret docker-registry acr-secret \
  --docker-server=acrconfiguration.azurecr.io \
  --docker-username=acrconfiguration \
  --docker-password=C8MG1QpXzCgnKcuFxg5rkd690/dBBrLB6slqtak1KP+ACRCRo8cz

**deployment.yaml file for init-agents** 

https://github.com/nanisravankumar/azure-devops-pipeline-cicd/blob/master/Azdevops_Pod_as_Agent_selfHosted/agents/agents/deployments/init-agents/init-agents.yaml

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

------------ Dockerfile---------------------
FROM ubuntu:20.04

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

# python3 & python3-pip added only for Promotion Stage
RUN apt-get update && apt-get install -y \
    curl \
    git \
    jq \
    python3 \
    npm \
    python3-pip \
    zip \
    groovy \
    wget \
    apt-transport-https \
    vim \
    nano \
    gnupg \
    software-properties-common


RUN curl https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -o packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm -rf packages-microsoft-prod.deb
RUN apt-get update && apt-get install powershell


# Install az-cli
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash


# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x ./kubectl && \
    mv kubectl /usr/local/bin

# Install Terraform

RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg


RUN gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint

RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list

RUN apt-get update

RUN apt-get install terraform

##install maven 3.8
#RUN wget https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/3.8.1/apache-maven-3.8.1-bin.tar.gz
#RUN tar -xvf apache-maven-3.8.1-bin.tar.gz
#RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
# && curl -fsSL -o /tmp/apache-maven.tar.gz https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/3.8.1/apache-maven-3.8.1-bin.tar.gz \
# && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1
# && rm -f /tmp/apache-maven.tar.gz

#ENV MAVEN_HOME=/usr/share/maven
#ENV MAVEN_CONFIG="$USER_HOME_DIR/.m2"
#ENV M2_HOME=/usr/share/maven
#ENV PATH="${M2_HOME}/bin:${PATH}"

# Define default command.
#CMD ["mvn", "-version"]


##install NodeJS
# RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
#    apt-get update && apt-get install nodejs && \
#    npm install --global yarn

# Install latest stable Docker package
RUN curl -fsSL https://get.docker.com -o get-docker.sh && \
    chmod +x ./get-docker.sh && \
    export VERSION="20.10" && \
    sh ./get-docker.sh && \
    rm -rf ./get-docker.sh


## Install Twistlock CLI

## Install Azure DevOps Agent & dependencies
ARG TARGETARCH=amd64
ARG AGENT_VERSION=2.190.0

WORKDIR /azp/agent
RUN if [ "$TARGETARCH" = "amd64" ]; then \
      AZP_AGENTPACKAGE_URL=https://vstsagentpackage.azureedge.net/agent/${AGENT_VERSION}/vsts-agent-linux-x64-${AGENT_VERSION}.tar.gz; \
    else \
      AZP_AGENTPACKAGE_URL=https://vstsagentpackage.azureedge.net/agent/${AGENT_VERSION}/vsts-agent-linux-${TARGETARCH}-${AGENT_VERSION}.tar.gz; \
    fi; \
    curl -LsS "$AZP_AGENTPACKAGE_URL" | tar -xz

RUN /azp/agent/bin/installdependencies.sh

RUN rm -rf /var/lib/apt/lists/*


COPY ./start.sh .
RUN chmod +x start.sh

CMD ["./start.sh"]

------------------------------------
---- start.sh ----------------------
#!/bin/bash
set -e

if [ -z "$AZP_URL" ]; then
  echo 1>&2 "error: missing AZP_URL environment variable"
  exit 1
fi

if [ -z "$AZP_TOKEN_FILE" ]; then
  if [ -z "$AZP_TOKEN" ]; then
    echo 1>&2 "error: missing AZP_TOKEN environment variable"
    exit 1
  fi

  AZP_TOKEN_FILE=/azp/.token
  echo -n $AZP_TOKEN > "$AZP_TOKEN_FILE"
fi

unset AZP_TOKEN

if [ -n "$AZP_WORK" ]; then
  mkdir -p "$AZP_WORK"
fi

# rm -rf /azp/agent
# mkdir /azp/agent
cd /azp/agent

export AGENT_ALLOW_RUNASROOT="1"

cleanup() {
  if [ -e config.sh ]; then
    print_header "Cleanup. Removing Azure Pipelines agent..."

    ./config.sh remove --unattended \
      --auth PAT \
      --token $(cat "$AZP_TOKEN_FILE")
  fi
}

print_header() {
  lightcyan='\033[1;36m'
  nocolor='\033[0m'
  echo -e "${lightcyan}$1${nocolor}"
}

# Let the agent ignore the token env variables
export VSO_AGENT_IGNORE=AZP_TOKEN,AZP_TOKEN_FILE

print_header "1. Determining matching Azure Pipelines agent..."

AZP_AGENT_RESPONSE=$(curl -LsS \
  -u user:$(cat "$AZP_TOKEN_FILE") \
  -H 'Accept:application/json;api-version=3.0-preview' \
  "$AZP_URL/_apis/distributedtask/packages/agent?platform=linux-x64")

if echo "$AZP_AGENT_RESPONSE" | jq . >/dev/null 2>&1; then
  AZP_AGENTPACKAGE_URL=$(echo "$AZP_AGENT_RESPONSE" \
    | jq -r '.value | map([.version.major,.version.minor,.version.patch,.downloadUrl]) | sort | .[length-1] | .[3]')
fi

if [ -z "$AZP_AGENTPACKAGE_URL" -o "$AZP_AGENTPACKAGE_URL" == "null" ]; then
  echo 1>&2 "error: could not determine a matching Azure Pipelines agent - check that account '$AZP_URL' is correct and the token is valid for that account"
  exit 1
fi

print_header "2. Downloading and installing Azure Pipelines agent..."

# curl -LsS $AZP_AGENTPACKAGE_URL | tar -xz & wait $!

source ./env.sh

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

print_header "3. Configuring Azure Pipelines agent..."

# ./bin/installdependencies.sh

./config.sh --unattended \
  --agent "${AZP_AGENT_NAME:-$(hostname)}" \
  --url "$AZP_URL" \
  --auth PAT \
  --token $(cat "$AZP_TOKEN_FILE") \
  --pool "${AZP_POOL:-Default}" \
  --work "${AZP_WORK:-_work}" \
  --replace \
  --acceptTeeEula & wait $!

# remove the administrative token before accepting work
rm $AZP_TOKEN_FILE

print_header "4. Running Azure Pipelines agent..."

# `exec` the node runtime so it's aware of TERM and INT signals
# AgentService.js understands how to handle agent self-update and restart
exec ./externals/node/bin/node ./bin/AgentService.js interactive --once & wait $!

# We expect the above process to exit when it runs once,
# so we now run a cleanup process to remove this agent
# from the pool
cleanup

-----------------------------------------------------------------------------------------------
