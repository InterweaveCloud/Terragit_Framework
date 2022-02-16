#!/bin/sh

github_ref="${GITHUB_REF##*/}"

echo "Github Base ref is ${GITHUB_BASE_REF}" 
echo "Github ref is ${github_ref}"
echo "github event name is ${GITHUB_EVENT_NAME}"
echo "Github event name is ${github.ref}"



# If the github ref is merge, then use the base ref to get the branch
if [ "${github_ref}" = "merge" ]; then
  echo "TF_VAR_branch=${GITHUB_BASE_REF}" >> $GITHUB_ENV
elif [ "${GITHUB_EVENT_NAME}" = "delete" ]; then
  echo "TF_VAR_branch=${github.event.ref}" >> $GITHUB_ENV
else
  echo "TF_VAR_branch=${GITHUB_REF##*/}" >> $GITHUB_ENV
fi