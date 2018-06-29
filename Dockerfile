FROM debian:jessie

ADD files/scripts /scripts 

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt-get update -qq && \
    apt-get install -qqy --no-install-recommends \
    apt-transport-https \
    ca-certificates \
      build-essential \
      curl \
      git \
      lsb-release \
      python-all \
      rlwrap \
      vim \
      nano \
      jq && \
    echo "deb http://ftp.debian.org/debian jessie-backports main" >> /etc/apt/sources.list && \
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ jessie main" | tee /etc/apt/sources.list.d/azure-cli.list && \
    curl -L https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    apt-get update  && \
    apt-get install -qqy  azure-cli && \
    apt-get install -qqy  certbot -t jessie-backports && \
    curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl  && mv kubectl /usr/local/bin/ && \
    chmod +x /usr/local/bin/kubectl && \
    chmod +x /scripts/* -R 

ENV EDITOR vim

LABEL Name=AzuredScript Version=0.0.5


