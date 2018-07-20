FROM ubuntu:latest

MAINTAINER Piotr Wittchen <piotr@wittchen.io>

ENV HEXO_SERVER_PORT=4000

RUN apt-get update
RUN apt-get -y install python
RUN mkdir app

WORKDIR /app

ADD public /app

EXPOSE 4000

CMD python -m SimpleHTTPServer 4000
