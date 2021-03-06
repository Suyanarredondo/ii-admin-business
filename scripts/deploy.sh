#!/bin/sh
set -e

# setup ssh-agent and provide the GitHub deploy key
openssl aes-256-cbc -K $encrypted_4d2af9b6eaf6_key -iv $encrypted_4d2af9b6eaf6_iv -in ci_rsa.enc -out deploy -d

# 对解密后的私钥添加权限
chmod 600 deploy

# 启动 ssh-agent
eval "$(ssh-agent -s)"

ssh-add deploy

# 删除解密后的私钥
rm deploy

git config --global user.name 'Travis'
git config --global user.email 'travis@travis-ci.com'

# commit the assets in docs-dist/ to the gh-pages branch and push to GitHub using SSH
./node_modules/.bin/gh-pages -d docs-dist/ -b gh-pages -r git@github.com:${TRAVIS_REPO_SLUG}.git
