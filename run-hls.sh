#!/usr/bin/env bash 
set -e

DIR_NAME=$(basename "${PWD}")

if [[ "${DIR_NAME}" == "kontrakcja" ]]; then
    docker compose "-f" "docker/docker-compose.yml" "exec" "devel" "haskell-language-server-wrapper" $@
elif [[ "${DIR_NAME}" == "journey-service" ]]; then
    docker compose "exec" "devel" "haskell-language-server-wrapper" $@
elif [[ "${DIR_NAME}" == "scrive-commons" ]]; then
    docker compose "exec" "devel" "haskell-language-server-wrapper" $@
else
    haskell-language-server-wrapper $@
fi
