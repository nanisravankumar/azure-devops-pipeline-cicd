#FROM acrida.azurecr.io/ubuntu:20.04
FROM ubuntu:20.04
# # To make it easier for build and release pipelines to run apt-get,
# # configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

## python3 & python3-pip added only for Promotion Stage
RUN apt-get update && apt-get install \
    sudo \
    curl \
    git \
    jq \
    maven \
#    openjdk-8-jdk \
#    openjdk-11-jdk \ 
    openjdk-17-jdk \
    python3 \           
    python3-pip \       
    zip \
    groovy \
    wget
# Install JDK 17
#RUN apt-get update && apt-get install -y openjdk-17-jdk

## Install Maven 3.8
#RUN apt-get install -y maven

RUN wget https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/3.8.1/apache-maven-3.8.1-bin.tar.gz
RUN mkdir /usr/share/maven
RUN tar -xzf apache-maven-3.8.1-bin.tar.gz -C /usr/share/maven --strip-components=1
ENV MAVEN_HOME=/usr/share/maven
ENV M3_HOME=/usr/share/maven
ENV PATH="${M3_HOME}/bin:${PATH}"

#RUN   curl -sL https://aka.ms/InstallAzureCLIDeb | bash
RUN  curl -sL https://aka.ms/InstallAzureCLIDeb | bash 
    
## Setup dotnet for c# applications
RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && dpkg -i packages-microsoft-prod.deb
RUN apt-get update && apt-get install -y dotnet-sdk-6.0

##install NodeJS
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get update && apt-get install nodejs && \
    npm install --global yarn
    
## Install latest stable Docker package
RUN curl -fsSL https://get.docker.com -o get-docker.sh && \
    chmod +x ./get-docker.sh && \
    export VERSION="20.10" && \
    sh ./get-docker.sh && \
    rm -rf ./get-docker.sh

## Install Twistlock CLI
RUN curl -o twistcli.tar.gz https://cdn.twistlock.com/releases/adb3f009/prisma_cloud_compute_edition_20_04_169.tar.gz && \
    mkdir twistlock-install && tar -zxvf twistcli.tar.gz -C ./twistlock-install && \
    cp ./twistlock-install/linux/twistcli /usr/local/bin/ && \
    chmod +x /usr/local/bin/twistcli && \
    rm -rf ./twistlock-install twistcli.tar.gz

##Install trivy
RUN curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/master/contrib/install.sh | sh -s -- -b /usr/local/bin 

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


# Set java to point to java 8
#RUN update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java
#ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
# Set java to point to java 17
#RUN update-alternatives --set java /usr/lib/jvm/java-17-openjdk
#ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
#RUN java -version
#RUN mvn --version

COPY ./start.sh .
RUN chmod +x start.sh

CMD ["./start.sh"]