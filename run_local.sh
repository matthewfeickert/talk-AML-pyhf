#!/usr/bin/env bash

# Chrome
#
# Use Python's http.server
# https://docs.python.org/3/library/http.server.html

printf "\n\nView in Chrome: http://0.0.0.0:8001/index.html?p=talk.md\n\n"

python3 -m http.server 8001

# Firefox
#
# Just open the file path with Firefox (no server required)

# nodejs
#
# Use nodejs http-server
# https://github.com/indexzero/http-server
# where nodejs is symlinked to node to avoid conflicts on Ubutnu
# ln -s /usr/bin/nodejs /usr/bin/node
#
# http-server .
# printf "\n\nView in Chrome: http://127.0.0.1:8080/index.html?p=talk.md\n\n"

# Convert to PDF with decktape (using the Docker image)
# docker run --rm -v $PWD:/slides/ astefanutti/decktape \
#     https://matthewfeickert.github.io/talk-AML-pyhf/index.html?p=talk.md \
#     talk.pdf
