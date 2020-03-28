## Load required source files:
source("library.R")

##' Provides a utility function which prepares a response object.
##'
##' @param content  HTTP response payload.
##' @param status   HTTP response code.
##' @param mimetype Mime-type which will be used as the HTTP `Content-Type` header value.
##' @param headers  Additional HTTP headers.
##' @param ...      Additional key-value pairs to be injected into the response object.
##' @return A named-list as a response object (see `httpuv` documentation)
.respond <- function(content, status = 200L, mimetype = "application/json", headers = list(), ...) {
  list(body = content, status = status, headers = c(c("Content-Type" = mimetype), headers), ...)
}

##' Provides a sample endpoint which returns the version of the application.
##'
##' @param request Raw HTTP request (see `httpuv` documentation for details)
##' @return Response which carries a JSON payload for version information.
endpoint <- function(request) {
  .respond(jsonlite::toJSON(list(version = .version), auto_unbox = TRUE))
}
