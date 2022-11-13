#!/usr/bin/env bash 
set -e

DIR_NAME=$(basename "${PWD}")

if [[ "${DIR_NAME}" == "Kontrakcja" ]]; then
    docker compose "-f" "docker/docker-compose.yml" "exec" "devel" "haskell-language-server-wrapper" $@
else
    haskell-language-server-wrapper $@
fi
