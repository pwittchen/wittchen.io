#!/usr/bin/env bash

for file in $(ls content/posts); do
    sed 's/images\///g' content/posts/$file > content/posts_migrated/$file
done
