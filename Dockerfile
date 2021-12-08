FROM public.ecr.aws/lambda/ruby:2.7 as gemfile
RUN yum update -y && \
    yum groupinstall -y 'Development Tools'
RUN gem install rails
RUN rails new . --skip-keeps --skip-bundle --skip-active-record

FROM public.ecr.aws/lambda/ruby:2.7
RUN yum update -y && \
    yum groupinstall -y 'Development Tools'
RUN curl -sL https://rpm.nodesource.com/setup_17.x | bash - && \
    yum install -y nodejs sqlite-devel && \
    npm install --global yarn
COPY --from=gemfile /var/task/Gemfile /var/task/
COPY Gemfile* /var/task/
RUN bundle install
ENV DISABLE_BOOTSNAP=true
ENV GEM_HOME=/var/lang/lib/ruby/gems/2.7.0
COPY . .
CMD ["lambda.handler"]