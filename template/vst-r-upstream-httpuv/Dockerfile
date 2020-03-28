## Use of-watchdog:
FROM openfaas/of-watchdog:0.7.2 as watchdog

## Use official, pinned R base Docker image:
FROM r-base:3.6.3

## Copy watchdog and make it executable:
COPY --from=watchdog /fwatchdog /usr/bin/fwatchdog
RUN chmod +x /usr/bin/fwatchdog

## Copy core build artifacts:
COPY .build /tmp/.build

## Copy custom build artifacts (not `function` for smarter caching):
COPY function/.build /home/docker/function/.build

## Run build procedure:
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN /bin/bash /tmp/.build/build.sh /tmp/.build

## Copy our code:
COPY function /home/docker/function

## Perform final cleanup:
RUN rm -rf /home/docker/function/.build

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
