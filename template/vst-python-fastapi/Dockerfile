## Use of-watchdog:
FROM openfaas/of-watchdog:0.7.2 as watchdog

## Use Python 3.7-alpine:
FROM python:3.7-alpine

## Copy watchdog and make it executable:
COPY --from=watchdog /fwatchdog /usr/bin/fwatchdog
RUN chmod +x /usr/bin/fwatchdog

## Perform essential installation and configuration:
RUN apk update                                                                    && \
    apk add --no-cache --virtual .build-deps git openssh-client gcc libc-dev make && \
    pip install --no-cache-dir --upgrade pip pipenv                               && \
    addgroup -S -g 1001 app                                                       && \
    adduser -S -D -h /app -u 1001 -G app app

## Switch working directory:
WORKDIR /app

## Copy Pipenv stuff:
COPY function/Pipfile .
COPY function/Pipfile.lock .

## Install:
RUN pipenv install --system --deploy --clear

## Clean-up:
RUN apk del .build-deps

## Copy the program:
COPY function/src src

## Change user:
USER app

## Set up of-watchdog:
ENV cgi_headers="true"
ENV fprocess="gunicorn src.web:app -k uvicorn.workers.UvicornWorker --workers 1"
ENV mode="http"
ENV upstream_url="http://127.0.0.1:8000"

## Setup healthcheck:
HEALTHCHECK --interval=3s CMD [ -e /tmp/.lock ] || exit 1

CMD ["fwatchdog"]
