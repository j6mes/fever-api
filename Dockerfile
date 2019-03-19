FROM ubuntu

RUN apt update
RUN apt install -y --no-install-recommends unzip

VOLUME /local/fever-common
WORKDIR /local/fever-common

RUN mkdir -pv data/index
RUN mkdir -pv data/fever
RUN mkdir -pv data/fever-data

ADD https://s3-eu-west-1.amazonaws.com/fever.public/wiki_index/fever-tfidf-ngram%3D2-hash%3D16777216-tokenizer%3Dsimple.npz data/index/fever-tfidf-ngram=2-hash=16777216-tokenizer=simple.npz
ADD https://s3-eu-west-1.amazonaws.com/fever.public/wiki_index/fever.db data/fever/fever.db
ADD https://s3-eu-west-1.amazonaws.com/fever.public/wiki-pages.zip data/wiki-pages.zip
ADD https://s3-eu-west-1.amazonaws.com/fever.public/train.jsonl data/fever-data/train.jsonl
ADD https://s3-eu-west-1.amazonaws.com/fever.public/paper_dev.jsonl data/fever-data/paper_dev.jsonl
ADD https://s3-eu-west-1.amazonaws.com/fever.public/paper_test.jsonl data/fever-data/paper_test.jsonl
ADD https://s3-eu-west-1.amazonaws.com/fever.public/shared_task_dev.jsonl data/fever-data/shared_task_dev.jsonl
ADD https://s3-eu-west-1.amazonaws.com/fever.public/shared_task_test.jsonl data/fever-data/shared_task_test.jsonl