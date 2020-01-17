FROM ruby:alpine

WORKDIR /sectools
ADD Gemfile /sectools

RUN apk --update add --virtual build-dependencies ruby-dev build-base &&\
    apk --update add curl &&\
    apk --update add git

RUN gem install wpscan bundler &&\
    bundle install &&\
    apk del build-dependencies && \
    rm -rf /var/cache/apk/*

COPY . /wpscan

HEALTHCHECK --interval=30s --timeout=5s --start-period=120s --retries=3 CMD curl --fail http://localhost:8080/status || exit 1

COPY src/ src/

RUN addgroup --system wpscan && \
    adduser --system wpscan

RUN chgrp -R 0 /sectools/ && \
    chmod -R g=u /sectools/ && \
    chown -R wpscan /sectools/

USER wpscan

EXPOSE 8080

ARG COMMIT_ID=unkown
ARG REPOSITORY_URL=unkown
ARG BRANCH=unkown
ARG BUILD_DATE
ARG VERSION

ENV SCB_COMMIT_ID ${COMMIT_ID}
ENV SCB_REPOSITORY_URL ${REPOSITORY_URL}
ENV SCB_BRANCH ${BRANCH}

LABEL org.opencontainers.image.title="secureCodeBox scanner-webserver-wordpress" \
    org.opencontainers.image.description="Wordpress_Scan integration for secureCodeBox" \
    org.opencontainers.image.authors="iteratec GmbH" \
    org.opencontainers.image.vendor="iteratec GmbH" \
    org.opencontainers.image.documentation="https://github.com/secureCodeBox/secureCodeBox" \
    org.opencontainers.image.licenses="Apache-2.0" \
    org.opencontainers.image.version=$VERSION \
    org.opencontainers.image.url=$REPOSITORY_URL \
    org.opencontainers.image.source=$REPOSITORY_URL \
    org.opencontainers.image.revision=$COMMIT_ID \
    org.opencontainers.image.created=$BUILD_DATE

ENTRYPOINT ["bundle","exec","ruby","/sectools/src/main.rb"]
