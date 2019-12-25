FROM gcr.io/google_appengine/ruby

ENV LANG=C.UTF-8

ADD . /app/

RUN cd mecab-0.996 && ./configure && make && make check && make install && ldconfig && cd -
RUN cd mecab-ipadic-2.7.0-20070801 && ./configure && make && make install

RUN CONFIGURE_OPTS="--disable-install-rdoc" rbenv install 2.5.1

RUN gem install bundler -v '1.17.3'
RUN bundle install --path vendor/bundle

CMD bundle exec ruby app.rb -p 8080
