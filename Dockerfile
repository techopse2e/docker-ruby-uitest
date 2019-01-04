FROM ruby:2.6.0
  
ENV FF_VERSION=46.0
ENV GOVERSION 1.9.3
ENV GOROOT /opt/go
ENV GOPATH /root/go
ENV DOCKER_BUCKET get.docker.com
ENV DOCKER_VERSION 17.05.0-ce
ENV DOCKER_SHA256_x86_64 340e0b5a009ba70e1b644136b94d13824db0aeb52e09071410f35a95d94316d9
ENV DOCKER_SHA256_armel 59bf474090b4b095d19e70bb76305ebfbdb0f18f33aed2fccd16003e500ed1b7

RUN apt-get update && apt-get install -y --no-install-recommends \
                bash \
                g++ \
                libgtk-3-0 \
                libasound2 \
                wget \
                --fix-missing xvfb && \
        rm -rf /var/lib/apt/lists/* && \
        wget "https://ftp.mozilla.org/pub/firefox/releases/${FF_VERSION}/linux-x86_64/en-US/firefox-${FF_VERSION}.tar.bz2" \
    -O /tmp/firefox.tar.bz2 && \
    tar xvf /tmp/firefox.tar.bz2 -C /opt && \
    ln -s /opt/firefox/firefox /usr/bin/firefox && \
        cd /opt && wget https://storage.googleapis.com/golang/go${GOVERSION}.linux-amd64.tar.gz && \
    tar zxf go${GOVERSION}.linux-amd64.tar.gz && rm go${GOVERSION}.linux-amd64.tar.gz && \
    ln -s /opt/go/bin/go /usr/bin/ && \
        go get -u github.com/ForceCLI/force && \
        cd $GOPATH/src/github.com/ForceCLI/force \
        go get . && \
        cp $GOPATH/bin/force /usr/local/bin/

RUN curl -fSL "https://${DOCKER_BUCKET}/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz" -o docker.tgz && \
    echo "${DOCKER_SHA256_x86_64} *docker.tgz" | sha256sum -c - && \
    tar -xzvf docker.tgz && \
    mv docker/* /usr/local/bin/ && \
    rmdir docker && \
    rm docker.tgz && \
    chmod +x /usr/local/bin/docker
