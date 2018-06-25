#!/usr/bin/env bash

# Chrome
#
# Use nodejs http-server
# https://github.com/indexzero/http-server
# where nodejs is symlinked to node to avoid conflicts on Ubutnu
# ln -s /usr/bin/nodejs /usr/bin/node

printf "\n\nView in Chrome: http://127.0.0.1:8080/index.html?p=talk.md\n\n"

http-server .

# Firefox
#
# Just open the file path with Firefox (no server required)
