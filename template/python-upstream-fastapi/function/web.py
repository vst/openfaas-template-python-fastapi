import os
from typing import Dict

from fastapi import FastAPI

from . import __version__

## TODO: Read the Sentry DSN from the secret store instead?
if "WEBAPP_SENTRY_DSN" in os.environ:
    from sentry_sdk import init

    init(os.environ["WEBAPP_SENTRY_DSN"])


#: Provides the web aplication instance.
app = FastAPI()


@app.get("/")
async def root() -> Dict[str, str]:
    """
    Returns the application version.

    >>> import asyncio
    >>> assert asyncio.run(root()) == {"version": __version__}
    """
    return {"version": __version__}
