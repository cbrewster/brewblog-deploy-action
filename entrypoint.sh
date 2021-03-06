#!/bin/bash
set -e
set -o pipefail

if [[ -n "$TOKEN" ]]; then
    GITHUB_TOKEN=$TOKEN
fi

if [[ -z "$PAGES_BRANCH" ]]; then
    PAGES_BRANCH="gh-pages"
fi

if [[ -z "$BUILD_DIR" ]]; then
    BUILD_DIR="."
fi

if [[ -z "$GITHUB_TOKEN" ]]; then
    echo "Set the GITHUB_TOKEN env variable."
    exit 1
fi

if [[ -z "$GITHUB_REPOSITORY" ]]; then
    echo "Set the GITHUB_REPOSITORY env variable."
    exit 1
fi

main() {
    echo "Deploying site..."

    version=$(brewblog --version)
    remote_repo="https://${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
    remote_branch=$PAGES_BRANCH

    echo "Using $version"

    echo "Building in $BUILD_DIR directory"
    cd $BUILD_DIR
    
    echo Building
    brewblog build
    
    cd public

    if [[ -n "$CNAME" ]]; then
        echo "Setting CNAME $CNAME"
        echo $CNAME > CNAME
    fi

    echo "Pushing artifacts to ${GITHUB_REPOSITORY}:$remote_branch"

    git init
    git config user.name "GitHub Actions"
    git config user.email "github-actions-bot@users.noreply.github.com"
    git add .

    git commit -m "Deploy ${GITHUB_REPOSITORY} to ${GITHUB_REPOSITORY}:$remote_branch"
    git push --force "${remote_repo}" master:${remote_branch}

    echo "Deploy complete"
}

main "$@"