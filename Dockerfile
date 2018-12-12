FROM ubuntu:18.04

EXPOSE 3000

RUN apt-get -qq update \
 && apt-get -qq install wget \
 && wget https://apertium.projectjj.com/apt/install-nightly.sh -O - | bash \
 && apt-get -qq install hfst libhfst52 nodejs npm python3 locales unzip \
 && locale-gen en_US.UTF-8

ENV LC_ALL en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LANG en_US.UTF-8

WORKDIR /app

ENV FINER_VERSION v1.3
ENV FINER_DIR finnish-tagtools-1.3.0
RUN wget https://korp.csc.fi/download/finnish-tagtools/$FINER_VERSION/$FINER_DIR.zip \
 && unzip $FINER_DIR.zip \
 && mv $FINER_DIR finer \
 && rm $FINER_DIR.zip
RUN sed -i 's|PMATCH=\$TAG/hfst-pmatch|PMATCH=hfst-pmatch|' finer/finnish-nertag
RUN sed -i 's|TOKENIZE="\$TAG/hfst-tokenize|TOKENIZE="hfst-tokenize|' finer/finnish-nertag
RUN chown -R daemon finer

COPY package.json server.js ./
RUN npm install

USER daemon

CMD nodejs server.js