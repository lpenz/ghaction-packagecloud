FROM ruby:alpine

RUN set -x -e; \
    apk add --update --no-cache bash make g++; \
    gem install package_cloud

ADD entrypoint /usr/local/bin/entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint"]
