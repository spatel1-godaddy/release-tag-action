#!/bin/sh

# Put version tag
git config --global --add safe.directory /github/workspace

version=$(cat VERSION)
message=$(echo $INPUT_MESSAGE | sed s/__VERSION__/$version/g)
git config user.name $(git log -1 --pretty=format:'%an')
git config user.email $(git log -1 --pretty=format:'%ae')
if $INPUT_FORCE; then
    git tag -af $version -m "$message" && git push -f origin $version
else
    git ls-remote --exit-code --tags origin $version > /dev/null 2>&1 || (git tag -a $version -m "$message" && git push origin $version)
fi

echo "::set-output name=tag::$version"
