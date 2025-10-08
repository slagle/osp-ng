#!/bin/bash

set -eux

rsync -avhP --delete ${NG_DIR} stack@${HOST}:
rsync -avhP --delete ${NG_DIR}/../osp-ng-private stack@${HOST}:
