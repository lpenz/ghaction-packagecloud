FROM ruby:2.7-alpine

RUN set -e -x; \
    apk add --update --no-cache bash make g++; \
    gem install package_cloud

ADD entrypoint /usr/local/bin/entrypoint
CMD ["/usr/local/bin/entrypoint"]
