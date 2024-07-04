FROM ubuntu:20.04
# # To make it easier for build and release pipelines to run apt-get,
# # configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN apt-get update && apt-get install \
    curl \
    git \
    jq \
    python3 \           
    python3-pip\
    openjdk-17-jdk \
    ca-certificates \
    apt-transport-https \
    lsb-release gnupg \
    wget \
    apt-transport-https \
    software-properties-common \
    unzip\
    groovy

## Install Maven 3.8
#RUN wget https://downloads.apache.org/maven/maven-3/3.8.4/binaries/apache-maven-3.8.4-bin.tar.gz && \
#    tar -zxvf apache-maven-3.8.4-bin.tar.gz -C /opt/ && \
#    ln -s /opt/apache-maven-3.8.4/bin/mvn /usr/bin/mvn && \
#    rm apache-maven-3.8.4-bin.tar.gz
RUN wget https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/3.8.1/apache-maven-3.8.1-bin.tar.gz
RUN mkdir /usr/share/maven
RUN tar -xzf apache-maven-3.8.1-bin.tar.gz -C /usr/share/maven --strip-components=1
ENV MAVEN_HOME=/usr/share/maven
ENV M3_HOME=/usr/share/maven
ENV PATH="${M3_HOME}/bin:${PATH}"
    
## Install Powershell package    
RUN wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb" && dpkg -i packages-microsoft-prod.deb
RUN apt-get update && apt-get install powershell
    

## Install Kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    
# Install Helm   
RUN curl https://baltocdn.com/helm/signing.asc | apt-key add -
RUN apt-get install apt-transport-https --yes \
     && echo "deb https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list \
     && apt-get update \
     && apt-get install helm  
     
# RUN helm repo add bitnami https://charts.bitnami.com/bitnami
# RUN helm repo add incubator https://charts.helm.sh/incubator --force-update

## Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

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

COPY ./ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

RUN keytool -noprompt -import -trustcacerts -alias pwc-ca-certificates -keystore /usr/lib/jvm/java-11-openjdk-amd64/lib/security/cacerts -file /etc/ssl/certs/ca-certificates.crt -storepass changeit

## Set java to point to java 8
#ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
    
COPY ./start.sh .
RUN chmod +x start.sh

CMD ["./start.sh"]