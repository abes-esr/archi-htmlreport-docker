#!/bin/sh

export GIT_CHECK_EACH_NBMINUTES="${GIT_CHECK_EACH_NBMINUTES:="5"}"
export GIT_REPOSITORY="${GIT_REPOSITORY:=""}"

echo "$(jq -r -M '.name' /usr/share/nginx/html/package.json) version: $(jq -r -M '.version' /usr/share/nginx/html/package.json)"
echo "Used parameters:"
echo "----------------"
env | grep -E "GIT"
echo "----------------"

if [ "$GIT_REPOSITORY" = "" ];
then
  >&2 echo "Error: GIT_REPOSITORY parameter is mandatory."
  exit 1
fi

/create-htmlreport.periodically.sh &

# exec the CMD (see Dockerfile comming from nginx docker image)
exec "$@"