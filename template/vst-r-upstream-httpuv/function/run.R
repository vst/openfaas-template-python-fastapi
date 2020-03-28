## Load required source files:
source("application.R")

## Configure and launch the server application:
httpuv::runServer(host = "127.0.0.1", port = 5000, app = list(call = endpoint))
