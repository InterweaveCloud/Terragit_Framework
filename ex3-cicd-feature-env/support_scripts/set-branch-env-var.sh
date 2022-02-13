#!/bin/sh
export test352=test352
echo "test352 is ${test352} in subshell"

# If base ref is empty, it is assumed that the branch is contained withtin the GITHUB_REF
if [ "${GITHUB_BASE_REF}" == "merge"]; then
  echo "TF_VAR_branch=${GITHUB_BASE_REF}" >> $GITHUB_ENV
else
  echo "TF_VAR_branch=${GITHUB_REF##*/}" >> $GITHUB_ENV
fi