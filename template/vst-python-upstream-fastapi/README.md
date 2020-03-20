# OpenFAAS Template using FastAPI Application as Upstream

This template provides an upstream FastAPI application as a
Python-based OpenFAAS function. Therefore:

1. This function is deployed using `of-watchdog` instead of the classic `watchdog`.
2. Multiple endpoints can be defined for functions using this template.
3. (Almost) all essential Web application functionalities are possible
   (various HTTP verbs, full control over HTTP headers etc).

## Development Requirements

1. Python 3.7
2. Pipenv
3. Docker
4. OpenFAAS CLI

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
faas-cli new myfunc --lang vst-python-upstream-fastapi
```

Change directory to your new OpenFAAS function:

```
cd myfunc
```

Install all your production and development dependencies:

```
pipenv install --dev
```

Run tests:

```
tox
```

Now you can make changes to code and test as you wish.

To build the OpenFAAS function:

```
cd ..
faas-cli build -f myfunc.yml
```

Run the Docker image that is built as an OpenFAAS function:

```
docker run --rm -p 8000:8080 myfunc
```

Now you can visit [http://localhost:8000](http://localhost:8000) or use `curl` to check your function live:

```
curl -D - http://localhost:8000
```

## Motivation

It is not so difficult to build such a function with the [official
*dockerfile* OpenFAAS
template](https://github.com/openfaas/templates/tree/master/template/dockerfile). The
motivation behind this very template is to pull in all required
development dependencies and setup the development environment with
sane configurations like you would do for a typical Python
application:

0. Pipenv
1. **IDE configuration template:** VS Code workspace
2. **Python development dependencies:**
    - black (configured)
    - flake8 (configured)
    - ipython
    - isort (configured)
    - mypy (configured)
    - pylint (configured)
    - pytest (configured)
    - sphinx (not configured)
    - tox (configured)
