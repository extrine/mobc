#!/bin/bash

git config merge.ours.driver true
git config user.name "u"
git config user.email "u@u"
git config color.ui auto

git config diff.mnemonicPrefix true
git config diff.renames true

git reset --hard
git pull origin

node ./compile/watch.js
