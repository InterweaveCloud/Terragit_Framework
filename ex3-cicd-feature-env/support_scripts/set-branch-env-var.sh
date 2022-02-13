#!/bin/sh
export test352=test352
echo "test352 is ${test352} in subshell"

if [ -z "${GITHUB_BASE_REF}" ]; then
  echo "GITHUB_BASE_REF is empty"
else
  echo "GITHUB_BASE_REF is not empty"
fi