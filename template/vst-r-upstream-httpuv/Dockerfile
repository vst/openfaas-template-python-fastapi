## Use of-watchdog:
FROM openfaas/of-watchdog:0.7.2 as watchdog

## Use official, pinned R base Docker image:
FROM r-base:3.6.3

## Copy watchdog and make it executable:
COPY --from=watchdog /fwatchdog /usr/bin/fwatchdog
RUN chmod +x /usr/bin/fwatchdog

## Prepare apt-get and install base packages:
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo "debconf debconf/frontend select Noninteractive" | debconf-set-selections  && \
    apt-get update -qy                                                              && \
    apt-get install -qy --no-install-recommends                                        \
        apt-transport-https                                                            \
        ca-certificates                                                                \
        curl                                                                           \
        gnupg                                                                          \
        r-cran-httpuv                                                                  \
        r-cran-httr                                                                    \
        r-cran-jsonlite                                                                \
        r-cran-xts                                                                     \
        unzip                                                                       && \
    apt-get clean autoclean                                                         && \
    apt-get autoremove -y                                                           && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

## Copy our code:
COPY function /home/docker/function

## Change working directory:
WORKDIR /home/docker/function

## Change user:
USER docker

## Set up of-watchdog:
ENV cgi_headers="true"
ENV fprocess="Rscript run.R"
ENV mode="http"
ENV upstream_url="http://127.0.0.1:5000"

## Setup healthcheck:
HEALTHCHECK --interval=3s CMD [ -e /tmp/.lock ] || exit 1

CMD ["fwatchdog"]
