FROM ubuntu

RUN apt update
RUN apt install -y --no-install-recommends unzip

VOLUME /local/fever-common
WORKDIR /local/fever-common

RUN mkdir -pv data/index
RUN mkdir -pv data/fever

ADD https://s3-eu-west-1.amazonaws.com/fever.public/wiki_index/fever-tfidf-ngram%3D2-hash%3D16777216-tokenizer%3Dsimple.npz data/index/fever-tfidf-ngram=2-hash=16777216-tokenizer=simple.npz
ADD https://s3-eu-west-1.amazonaws.com/fever.public/wiki_index/fever.db data/fever/fever.db
ADD https://s3-eu-west-1.amazonaws.com/fever.public/wiki-pages.zip data/wiki-pages.zip

RUN unzip -d data/wiki-pages data/wiki-pages.zip