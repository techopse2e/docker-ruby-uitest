FROM ruby:2.1.2

ENV FF_VERSION=46.0
ENV GOVERSION 1.9.3
ENV GOROOT /opt/go
ENV GOPATH /root/go

RUN apt-get update && apt-get install -y --no-install-recommends \
		bash \
		g++ \
		libgtk-3-0 \
		libasound2 \
		wget \
		--fix-missing Xvfb && \
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
