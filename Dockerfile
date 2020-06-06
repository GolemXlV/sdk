FROM ubuntu:20.04

RUN apt-get update && apt-get install -y software-properties-common
RUN apt-get install -y curl git
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable edge"
RUN apt-cache policy docker-ce

RUN apt-get install -y docker-ce

RUN curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

WORKDIR /var/gram
RUN git clone https://github.com/gram-net/gram-sdk
RUN cd gram-sdk && yes | ./bin/install
