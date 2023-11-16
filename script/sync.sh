#!/bin/sh
set -eu

cd ${0%/*}

function gh_tag {
    curl -Ls "https://api.github.com/repos/${1}/releases/latest" | yq '.tag_name'
}

readonly origin='denoland/deno'

readonly v_origin=$(gh_tag ${origin})
readonly v_repo=$(gh_tag ${GITHUB_REPOSITORY})

if [[ ${v_repo} == ${v_origin} ]]; then
    exit
fi

sed -r -i -e "s/DENO_VERSION=\"v[0-9]+\.[0-9]+\.[0-9]+\"/DENO_VERSION=\"${v_origin}\"/" ../src/*.dockerfile

git tag -a ${v_origin} -m "sync latest ${origin}"
git push origin ${v_origin}