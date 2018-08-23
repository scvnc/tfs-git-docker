#!/bin/sh

# Relative to script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

function has_image () {
    test ! -z "$(docker images -q tfs-git)"
}

if test ! has_image; then
    pushd ${DIR}
    docker build -t tfs-git .
    popd
fi

docker run --rm -it \
    -u $(id -u) \
    -v ${PWD}:/pwd \
    -v ${HOME}/.netrc:/.netrc \
    -v ${HOME}/.git-credentials:/.git-credentials \
    -v ${HOME}/.gitconfig:/.gitconfig \
    -w /pwd \
    tfs-git /usr/bin/git ${@}