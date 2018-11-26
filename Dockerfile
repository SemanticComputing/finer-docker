FROM ubuntu:18.04

MAINTAINER Arttu Oksanen
EXPOSE 3000

RUN apt-get -qq update \
   && apt-get -qq -y install wget \
   && apt-get -qq -y install unzip \
   && wget https://apertium.projectjj.com/apt/install-nightly.sh -O - | bash \
   && apt-get -qq -y install hfst libhfst52 \
   && apt-get install -qq -y nodejs \
   && apt-get install -qq -y npm
RUN apt-get install -qq -y python3
RUN apt-get -y install locales \
   && locale-gen en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LANG en_US.UTF-8
WORKDIR /opt
ENV FINER_VERSION v1.3
ENV FINER_DIR finnish-tagtools-1.3.0
RUN wget https://korp.csc.fi/download/finnish-tagtools/$FINER_VERSION/$FINER_DIR.zip \
   && unzip $FINER_DIR.zip \
   && mv $FINER_DIR finer \
   && rm $FINER_DIR.zip
RUN sed -i 's|PMATCH=\$TAG/hfst-pmatch|PMATCH=hfst-pmatch|' finer/finnish-nertag
RUN sed -i 's|TOKENIZE="\$TAG/hfst-tokenize|TOKENIZE="hfst-tokenize|' finer/finnish-nertag
COPY webservice /opt/finer-webservice

RUN cd /opt/finer-webservice \
   && rm -rf node_modules \
   && npm install \
   && cd /opt/finer \
   && chown -R daemon .
WORKDIR /opt/finer-webservice
USER daemon
CMD nodejs server.js