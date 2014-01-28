#!/bin/bash

test "$#" -eq 4 && F="$4"

function baz64 {
echo $1 | base64 -d && echo;
}

function md5 {
while read l; do
  test  "$1" = $(md5pass "$l" "$2" | cut -d $ -f 4) && echo "$l" && exit
done < $F
echo "404"
}

function sha {
while read l; do
  test  "$1" = $(sha1pass "$l" "$2" | cut -d $ -f 4) && echo "$l" && exit
done < $F
echo "404"
}

function apr {
while read l; do
  test  "$1" = $(openssl passwd -apr1 -salt "$2" "$l" | cut -d $ -f 4) && echo "$l" && exit
done < $F
echo "404"
}

test "$#" -eq 1 && baz64 $1 && exit
test "$#" -eq 4 -a "$1" = "md5" && md5 $2 $3 && exit
test "$#" -eq 4 -a "$1" = "sha" && sha $2 $3 && exit
test "$#" -eq 4 -a "$1" = "apr" && apr $2 $3 && exit
echo "Are you sure to know how to use it?"
