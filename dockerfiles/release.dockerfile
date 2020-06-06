FROM ubuntu:20.04
WORKDIR /var/gram
ENV DOCKERBUILD=1
COPY . /var/gram
RUN du /var/gram
RUN ln -s /var/gram/bin/gram /usr/bin/gram
RUN ln -s /var/gram/build/validator-engine/validator-engine /usr/bin/validator-engine
RUN ln -s /var/gram/build/validator-engine-console/validator-engine-console /usr/bin/validator-engine-console
RUN ln -s /var/gram/build/lite-client/lite-client /usr/bin/lite-client
RUN ln -s /var/gram/build/crypto/fift /usr/bin/fift
RUN ln -s /var/gram/build/crypto/func /usr/bin/func
RUN ln -s /var/gram/build/json-explorer/json-explorer /usr/bin/json-explorer
RUN ln -s /var/gram/build/blockchain-explorer/blockchain-explorer /usr/bin/blockchain-explorer
RUN ln -s /var/gram/build/rldp-http-proxy/rldp-http-proxy /usr/bin/rldp-http-proxy
RUN gram init