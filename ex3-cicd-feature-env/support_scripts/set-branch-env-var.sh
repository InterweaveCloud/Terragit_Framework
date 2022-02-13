#!/bin/sh
export test352=test352
echo "test352 is ${test352} in subshell"

# If base ref is empty, it is assumed that the branch is contained withtin the GITHUB_REF
if [ -z "${GITHUB_BASE_REF}" ]; then
  export TF_VAR_branch=${GITHUB_REF##*/}
else
  export TF_VAR_branch=${GITHUB_BASE_REF}
fi