FROM ubuntu:20.04

# # To make it easier for build and release pipelines to run apt-get,
# # configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

## python3 & python3-pip added only for Promotion Stage
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

## Install latest stable Docker package
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