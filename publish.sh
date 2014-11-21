#!/bin/sh -ex

SOURCE_BRANCH=$(git rev-parse HEAD)
SOURCE_PARENT=$(git rev-parse -q --verify $SOURCE_BRANCH)
SOURCE_MESSAGE=$(git log -1 --pretty=%B)
PUBLISH_BRANCH=master
PUBLISH_PARENT=$(git rev-parse -q --verify $PUBLISH_BRANCH)

if [ "$SOURCE_BRANCH" = "$PUBLISH_BRANCH" ]; then
    echo "Cannot publish from branch $SOURCE_BRANCH"
    exit 1
fi

rm -rf build
git clone . build
(cd build; git checkout $PUBLISH_BRANCH; rm -r *)

# build using the hardcoded config: no cleaning or watching
metalsmith

cd build
git add --all .
git update-ref refs/heads/$PUBLISH_BRANCH $(
    git commit-tree \
        ${PUBLISH_PARENT:+-p $PUBLISH_PARENT} \
        -p $SOURCE_PARENT \
        -m "$SOURCE_MESSAGE (built by $0)" \
        $(git write-tree)
)
git push origin $PUBLISH_BRANCH
