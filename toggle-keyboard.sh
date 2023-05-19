#!/usr/bin/env bash

LANG=$(setxkbmap -query | grep "layout:" | sed 's/layout: *\(.*\)$/\1/')

if [ ${LANG} == "us" ]; then
    setxkbmap cz qwerty
else
    setxkbmap us
fi
