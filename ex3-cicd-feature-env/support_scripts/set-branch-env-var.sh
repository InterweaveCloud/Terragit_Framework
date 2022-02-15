#!/bin/sh

# If the github ref is merge, then use the base ref to get the branch
if [ "${github_ref}" = "merge" ]; then
  echo "TF_VAR_branch=${GITHUB_BASE_REF}" >> $GITHUB_ENV
else
  echo "TF_VAR_branch=${GITHUB_REF##*/}" >> $GITHUB_ENV
fi