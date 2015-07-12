FROM ubuntu:latest

WORKDIR /tmp

RUN apt install -y wget
RUN wget http://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
RUN dpkg -i erlang-solutions_1.0_all.deb
RUN apt-get update
RUN apt-get install -y erlang
#I need hipe here because rebar was complaining about missing dependency
RUN apt-get install -y erlang-base-hipe
RUN apt-get install -y git
RUN apt-get install -y make

RUN git clone https://github.com/rebar/rebar3.git
RUN cd rebar3 && ./bootstrap && cp rebar3 /usr/local/bin/rebar3

WORKDIR /app