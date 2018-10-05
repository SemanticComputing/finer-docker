FROM ubuntu:xenial-20180123

MAINTAINER Arttu Oksanen
EXPOSE 3000
WORKDIR /opt/hfst
RUN cd /opt/hfst \
   && apt-get -qq update \
   && apt-get -qq -y install wget \
   && wget http://apertium.projectjj.com/apt/nightly/pool/main/h/hfst/libhfst52_3.15.0+g3676~e98973ad-1~xenial1_amd64.deb \
   && wget http://apertium.projectjj.com/apt/nightly/pool/main/h/hfst/hfst_3.15.0+g3676~e98973ad-1~xenial1_amd64.deb \
   && dpkg -i libhfst52_3.15.0+g3676~e98973ad-1~xenial1_amd64.deb \
   && dpkg -i hfst_3.15.0+g3676~e98973ad-1~xenial1_amd64.deb \
   && apt-get install -qq -y nodejs \
   && apt-get install -qq -y npm
RUN apt-get install -qq -y python3
RUN apt-get -y install locales \
   && locale-gen en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LANG en_US.UTF-8
COPY finer /opt/finer
COPY webservice /opt/finer-webservice
RUN cd /opt/finer-webservice \
   && rm -rf node_modules \
   && npm install \
   && cd /opt/finer \
   && chown -R daemon .
WORKDIR /opt/finer-webservice
USER daemon
CMD nodejs server.js
