#!/usr/bin/env bash

# Clone repo
rm -rf ASH_TEST
git clone git@github.com:kidqueb/ash-server.git ASH_TEST

# Change directory, install deps, gen resource
cd ASH_TEST

mix deps.get
mix deps.update ash --no-archives-check
MIX_ENV=test mix ecto.drop

git init
git add .
git commit -am "initial testing setup"

cd ..
./ash-run-test.sh