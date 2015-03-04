#!/bin/sh
set -e
export LC_CTYPE=C 
export LANG=C
genpasswd() {
  local l=$1
        [ "$l" == "" ] && l=24
        tr -dc A-Za-z0-9_ < /dev/urandom | head -c ${l} | xargs
}
genpasswd