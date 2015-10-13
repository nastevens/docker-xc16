#!/bin/sh

: ${XC16_IMAGE:=nastevens/xc16}

docker build -t $XC16_IMAGE .
