FROM ubuntu:18.04
LABEL maintainer="deric.walintukan@gmail.com"

ENV DEBIAN_FRONTEND noninteractive
ENV ERLANG_VERSION 1:21.1.1-1
ENV ELIXIR_VERSION 1.7.4
ENV PHOENIX_VERSION 1.3.4

# Elixir requires UTF-8
RUN apt-get clean && apt-get update && apt-get install -y locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y sudo wget curl inotify-tools git build-essential zip unzip

# Download and install NodeJS
RUN curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash - \
    && apt-get install -y nodejs

# Download and install Erlang package
RUN wget http://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb \
  && dpkg -i erlang-solutions_1.0_all.deb \
  && apt-get update

# Install Erlang
RUN apt-get install -y esl-erlang=$ERLANG_VERSION \
    && rm erlang-solutions_1.0_all.deb

# Install Elixir
RUN mkdir /opt/elixir \
  && cd /opt/elixir \
  && curl -O -L https://github.com/elixir-lang/elixir/releases/download/v$ELIXIR_VERSION/Precompiled.zip \
  && unzip Precompiled.zip \
  && cd /usr/local/bin \
  && ln -s /opt/elixir/bin/elixir \
  && ln -s /opt/elixir/bin/elixirc \
  && ln -s /opt/elixir/bin/iex \
  && ln -s /opt/elixir/bin/mix

# Install the Phoenix Mix archive
RUN mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phx_new-$PHOENIX_VERSION.ez

# Install Hex & Rebar
RUN mix local.hex --force \
    && mix local.rebar --force \
    && mix hex.info
