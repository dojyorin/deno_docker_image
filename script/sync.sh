function gh_tag {
    curl -Ls "https://api.github.com/repos/${1}/releases/latest" | yq '.tag_name'
}

readonly origin='denoland/deno'

readonly v_origin=$(gh_tag ${origin})
readonly v_local=$(gh_tag ${GITHUB_REPOSITORY})

if [[ ${v_local} == ${v_origin} ]]; then
    exit
fi

git tag -a ${v_origin} -m "sync latest ${origin}"
git push origin ${v_origin}