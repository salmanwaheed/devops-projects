#!/bin/bash

HOME_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $HOME_DIR

python3 -m venv .venv
source .venv/bin/activate

pip3 install -r requirements.txt --upgrade setuptools wheel
python3 setup.py sdist bdist_wheel

deactivate

rm -rf .venv build *.egg-info # dist
