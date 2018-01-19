#!/bin/bash
set -eu
< /dev/urandom tr -dc 'a-zA-Z0-9._-' | head -c 64 | base64 -w 0; echo
