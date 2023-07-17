FROM ruby:2

WORKDIR /usr/src/app

RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt -y install nodejs