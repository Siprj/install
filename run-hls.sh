#/bin/bash -e

if ! command -v haskell-language-server &> /dev/null
then
    haskell-language-server-wrapper "$@"
else
    haskell-language-server "$@"
fi
