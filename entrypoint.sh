#!/bin/sh

# Put version tag
git config --global --add safe.directory /github/workspace
if [ $( git rev-parse --abbrev-ref HEAD )  = 'main' ]; then
    INPUT_PREFIX='v'
elif  [ $( git rev-parse --abbrev-ref HEAD )  = 'unstable' ]; then
    INPUT_PREFIX='u'
fi

version=${INPUT_PREFIX}$(cat VERSION)${INPUT_SUFFIX}
message=$(echo $INPUT_MESSAGE | sed s/__VERSION__/$version/g)
git config user.name $(git log -1 --pretty=format:'%an')
git config user.email $(git log -1 --pretty=format:'%ae')
if $INPUT_FORCE; then
    git tag -af $version -m "$message" && git push -f origin $version
else
    git ls-remote --exit-code --tags origin $version > /dev/null 2>&1 || (git tag -a $version -m "$message" && git push origin $version)
fi

# Build RPM module
rpmdev-setuptree
cp -r /github/workspace/* /root/rpmbuild/SOURCES/

rpmbuild -bb  /github/workspace/config.spec
cp /root/rpmbuild/RPMS/x86_64/*.rpm /github/workspace/

# Upload RPM module to ssh server
yumServer=${INPUT_USERNAME}'@'${INPUT_HOSTNAME}
basePath="$yumServer:/home/spatel1/test"

if [ $( git rev-parse --abbrev-ref HEAD )  = 'main' ]; then
    sshpass -p ${INPUT_PASSWORD} scp -o StrictHostKeyChecking=accept-new /github/workspace/flask_actions-$(cat VERSION)-1.x86_64.rpm $basePath/
elif  [ $( git rev-parse --abbrev-ref HEAD )  = 'unstable' ]; then
    sshpass -p ${INPUT_PASSWORD} scp -o StrictHostKeyChecking=accept-new /github/workspace/flask_actions-$(cat VERSION)-1.x86_64.rpm $basePath/
fi
