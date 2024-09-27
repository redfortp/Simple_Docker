#!/bin/bash

gcc server.c -lfcgi -o /home/server
spawn-fcgi -p 8080 -f /home/server
nginx -g "daemon off;"