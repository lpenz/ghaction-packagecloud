FROM ruby:2.7-alpine

RUN echo 'http://dl-4.alpinelinux.org/alpine/v3.15/main' >> /etc/apk/repositories

RUN set -x -e; \
    apk add --update --no-cache bash make g++; \
    gem install package_cloud

ADD entrypoint /usr/local/bin/entrypoint
CMD ["/usr/local/bin/entrypoint"]
