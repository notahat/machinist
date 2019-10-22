FROM ruby:1.9.3-p551
ARG BUNDLER_VERSION=1.15.4

RUN apt-get update -qq && \
    apt-get install -qy curl jq python3 python3-dev python3-pip python3-yaml && \
    pip3 install awscli && \
    apt-get clean

RUN useradd -c 'builder of ruby projs' -m -d /home/builder -s /bin/bash builder

ENV GEM_HOME /usr/local/bundle
RUN chmod -R 777 "$GEM_HOME"

USER builder
ENV HOME /home/builder
RUN mkdir -p $HOME/app
ADD --chown=builder:builder . $HOME/app/
WORKDIR $HOME/app/

RUN gem install bundler -v $BUNDLER_VERSION && bundle install