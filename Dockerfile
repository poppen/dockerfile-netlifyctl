FROM alpine:3.6

ENV NETLIFYCTL_VERSION 0.2.2

ADD https://github.com/netlify/netlifyctl/releases/download/v${NETLIFYCTL_VERSION}/netlifyctl-linux-amd64-${NETLIFYCTL_VERSION}.tar.gz /tmp/netlifyctl.tar.gz

RUN cd /tmp \
  && tar -zxvf netlifyctl.tar.gz \
  && cp netlifyctl /usr/bin/netlifyctl \
  && ln -s /usr/bin/netlifyctl /usr/bin/netlify \
  && rm -rf /tmp/netlifyctl*
