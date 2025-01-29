FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get clean && apt-get update -y

RUN apt-get install -y software-properties-common && \
  add-apt-repository ppa:ondrej/php && \
  apt-get update

ARG PHP_FPM_VERSION="8.4"

RUN apt-get install -y php${PHP_FPM_VERSION}-fpm

ARG PHP_FPM_ADDITIONAL_SYSTEM_PACKAGES=""
RUN touch /tmp/apt-packages.txt
RUN if [ -n "$PHP_FPM_ADDITIONAL_SYSTEM_PACKAGES" ]; then \
  echo "$PHP_FPM_ADDITIONAL_SYSTEM_PACKAGES" | \
  tr ',' '\n' | \
  sed 's/^[[:space:]]*//g; s/[[:space:]]*$//g' | \
  tr '[:upper:]' '[:lower:]' | \
  sort -u > /tmp/apt-packages.txt; \
  fi

RUN if [ -s /tmp/apt-packages.txt ]; then \
  apt-get update && \
  xargs -a /tmp/apt-packages.txt apt-get install -y; \
  fi

ARG PHP_FPM_ADDITIONAL_EXTENSIONS=""
RUN touch /tmp/php-extensions.txt
RUN if [ -n "$PHP_FPM_ADDITIONAL_EXTENSIONS" ]; then \
  echo "$PHP_FPM_ADDITIONAL_EXTENSIONS" | \
  tr ',' '\n' | \
  sed 's/^[[:space:]]*//g; s/[[:space:]]*$//g' | \
  tr '[:upper:]' '[:lower:]' | \
  sed 's/^/php'"$PHP_FPM_VERSION"'-/' | \
  sort -u > /tmp/php-extensions.txt; \
  fi

RUN if [ -s /tmp/php-extensions.txt ]; then \
  apt-get update && \
  xargs -a /tmp/php-extensions.txt apt-get install -y; \
  fi

RUN apt-get clean && \
  apt-get autoremove -y && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN ln -s /usr/sbin/php-fpm${PHP_FPM_VERSION} /usr/sbin/php-fpm
