FROM alpine:3.10

ENV ALPINE_VERSION=3.10


ENV PACKAGES="\
  dumb-init \
  musl \
  linux-headers \
  build-base \
  ca-certificates \
  python3 \
  python3-dev \
  py-setuptools \
  supervisor \
  nginx \
"

RUN echo \
  # replacing default repositories with edge ones
  && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" > /etc/apk/repositories \
  && echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
  && echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \

  # Add the packages, with a CDN-breakage fallback if needed
  && apk add --no-cache $PACKAGES || \
    (sed -i -e 's/dl-cdn/dl-4/g' /etc/apk/repositories && apk add --no-cache $PACKAGES) \

  # turn back the clock -- so hacky!
  && echo "http://dl-cdn.alpinelinux.org/alpine/v$ALPINE_VERSION/main/" > /etc/apk/repositories  


# Add files
ADD files/nginx.conf /etc/nginx/nginx.conf
# Copy Basic FLASK HTML site ready for NGINX
ADD files/www/ /DATA/www/

# Entrypoint
ADD start.sh /
RUN chmod u+x /start.sh
CMD /start.sh
