FROM ubuntu:18.04

RUN apt-get -qq update \
 && apt-get -qq install wget \
 && wget https://apertium.projectjj.com/apt/install-nightly.sh -O - | bash \
 && apt-get -qq install hfst libhfst52 python3 python3-pip python3-libhfst locales unzip git swig \
 && locale-gen en_US.UTF-8

ENV LC_ALL en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LANG en_US.UTF-8

COPY requirements.txt ./requirements.txt
RUN pip3 install -r requirements.txt

RUN pip3 install gunicorn

WORKDIR /app

ENV TAGTOOLS_VERSION v1.5
ENV TAGTOOLS_DIR finnish-tagtools-1.5.0
RUN wget https://korp.csc.fi/download/finnish-tagtools/$TAGTOOLS_VERSION/$TAGTOOLS_DIR.zip \
 && unzip $TAGTOOLS_DIR.zip \
 && mv $TAGTOOLS_DIR finnish-tagtools \
 && rm $TAGTOOLS_DIR.zip

RUN git clone https://github.com/Traubert/FinnPos
RUN cd FinnPos/src/tagger \
 && sed -i s/python3\.5-config/python3-config/ Makefile \
 && make swig \
 && cp -p finnpos.py _finnpos.so omorfi_postag.py ../../../ \
 && cd ../../.. \
 && rm -rf FinnPos

RUN wget https://raw.githubusercontent.com/Traubert/nlp-tools/master/scripts/finer.py

RUN tr '\n' '§' < finer.py | sed 's/self\.proper_tag1/self\.proper_tag2/2' | tr '§' '\n' > finer.py

RUN sed -i 's/morpho\.index/morph\.index/; s/morpho\ =\ morpho\[/morph\ =\ morph\[/' finer.py

COPY lemma-morph-exceptions.txt /app/
RUN sed -i '/morph\[/ r lemma-morph-exceptions.txt' finer.py

COPY server.py ./

ENV GUNICORN_WORKER_AMOUNT 4
ENV GUNICORN_TIMEOUT 300
ENV GUNICORN_RELOAD ""

EXPOSE 3000

USER 9008

COPY run /run.sh

ENTRYPOINT [ "/run.sh" ]