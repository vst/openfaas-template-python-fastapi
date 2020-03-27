# OpenFAAS Template using R httpuv Application as Upstream

This template provides an R function which uses new style
`watchdog` (`of-watchdog`). Therefore:

1. Multiple endpoints can be defined for functions using this template.
2. (Almost) all essential Web application functionalities are possible
   (various HTTP verbs, full control over HTTP headers etc).

## Development Requirements

1. R
2. Docker
3. OpenFAAS CLI

## Quickstart

Create a directory and change to it:

```
mkdir sandbox
cd sandbox
```

Pull this template:

```
faas-cli template pull https://github.com/vst/openfaas-templates
```

Create your new OpenFAAS function, namely `myfunc`:

```
faas-cli new myfunc --lang vst-r-upstream-httpuv
```

Change directory to your new OpenFAAS function:

```
cd myfunc
```

Now you can make changes to code and test as you wish:

1. `run.R` You will most likely not need to edit this file.
2. `library.R` This is where your Web-agnostic code lives. Business
   logic will live here.
3. `application.R` This is where you will expose business logic
   (functionality provided in `library.R`) as an HTTP endpoint.

To build the OpenFAAS function:

```
cd ..
faas-cli build -f myfunc.yml
```

Run the Docker image that is built as an OpenFAAS function:

```
docker run --rm -p 8000:8080 myfunc
```

Now you can visit [http://localhost:8000](http://localhost:8000) or
use `curl` to check your function live:

```
curl -D - http://localhost:8000
```
