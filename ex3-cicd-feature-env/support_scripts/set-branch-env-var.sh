#!/bin/sh
export test352=test352
echo "test352 is ${test352} in subshell"
echo "GITHUB_BASE_REF is ${GITHUB_BASE_REF}" in subshell"
echo "GITHUB_REF is ${GITHUB_REF##*/}" in subshell"


# If the github ref is merge, then use the base ref to get the branch
if ["${GITHUB_BASE_REF}" = "merge"]; then
  echo "TF_VAR_branch=${GITHUB_BASE_REF}" >> $GITHUB_ENV
else
  echo "TF_VAR_branch=${GITHUB_REF##*/}" >> $GITHUB_ENV
fi