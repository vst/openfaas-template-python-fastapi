## Use of-watchdog:
FROM openfaas/of-watchdog:0.7.2 as watchdog

## Use Python 3.7:
FROM python:3.7

## Copy watchdog and make it executable:
COPY --from=watchdog /fwatchdog /usr/bin/fwatchdog
RUN chmod +x /usr/bin/fwatchdog

## Upgrade pip and install pipenv
RUN pip install --upgrade pip pipenv

## Add non root user:
RUN adduser --disabled-password --gecos "Application" appuser

## Switch user:
USER appuser

## Switch working directory:
WORKDIR /home/appuser/

## Copy pipenv stuff:
COPY src/Pipfile .

## Install:
RUN pipenv install

## Copy the program:
COPY src/function function

## Set up of-watchdog:
ENV cgi_headers="true"
ENV fprocess="pipenv run gunicorn function.web:app -k uvicorn.workers.UvicornWorker --workers 1"
ENV mode="http"
ENV upstream_url="http://127.0.0.1:8000"

## Setup healthcheck:
HEALTHCHECK --interval=3s CMD [ -e /tmp/.lock ] || exit 1

CMD ["fwatchdog"]
