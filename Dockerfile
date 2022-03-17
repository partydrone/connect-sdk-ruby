ARG RUBY_VERSION
FROM ruby:${RUBY_VERSION}

ENV GEM_HOME /usr/local/bundle
ENV PATH ${GEM_HOME}/bin:${GEM_HOME}/gems/bin:${PATH}

RUN gem install yard

WORKDIR /opt/gem

COPY lib/op_connect/version.rb ./lib/op_connect/version.rb
COPY Gemfile* *.gemspec ./

RUN bundle check || bundle install -j $(nproc)
