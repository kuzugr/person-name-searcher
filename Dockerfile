FROM ruby:2.7

ENV LANG=C.UTF-8

RUN apt-get update \
  && apt-get install curl git \
  && apt-get clean

WORKDIR /opt
RUN git clone https://github.com/taku910/mecab.git

WORKDIR /opt/mecab/mecab
RUN ./configure  --enable-utf8-only \
  && make \
  && make check \
  && make install \
  && ldconfig

WORKDIR /opt/mecab/mecab-ipadic
RUN ./configure --with-charset=utf8 \
  && make \
  && make install

WORKDIR /opt
RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git
WORKDIR /opt/mecab-ipadic-neologd
RUN ./bin/install-mecab-ipadic-neologd -n -y

ADD . /app/
WORKDIR /app
RUN gem install bundler
RUN bundle config set path vendor/bundle && bundle config set without development && bundle install

EXPOSE 8080
CMD bundle exec ruby app.rb -p 8080 -o 0.0.0.0
