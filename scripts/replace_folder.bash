#!/bin/sh
set -e
replace_folder() {
  rm -r $1
  cp -r $2 $3
}
replace_folder $1 $2 $3
