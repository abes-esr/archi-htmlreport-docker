#!/bin/sh

# loop forever but wait $GIT_CHECK_EACH_NBMINUTES between each loops 
while true
do

  if [ ! -d /archi-model-git-repo/ ]; then
    echo "-> Git clone of archimatetool model repository: $GIT_REPOSITORY"
    git clone --depth 1 $GIT_REPOSITORY /archi-model-git-repo/
    cd /archi-model-git-repo/
    GIT_HASH_OLD=$(git rev-parse HEAD)
  else
    echo "-> Git pull archimatetool model repository: $GIT_REPOSITORY"
    cd /archi-model-git-repo/
    git checkout -q master
    git fetch origin && git reset --hard origin/master
    GIT_HASH_NEW=$(git rev-parse HEAD)
  fi

  if [ "$GIT_HASH_OLD" != "$GIT_HASH_NEW" ]; then
    echo "-> Generating HTML report from the archimatetool model."
    cd /archi-model-git-repo/
    xvfb-run /Archi/Archi -consoleLog -nosplash \
      -application com.archimatetool.commandline.app \
      --modelrepository.loadModel /archi-model-git-repo/ \
      -saveModel /archi-model-git-repo/model.archimate \
      --html.createReport /usr/share/nginx/html

    test -f ./create-htmlreport.postscript.sh && \
      echo "-> Running the create-htmlreport.postscript.sh script."
    test -f ./create-htmlreport.postscript.sh && ./create-htmlreport.postscript.sh

    GIT_HASH_OLD=$GIT_HASH_NEW
  else
    echo "-> No change on git, skip the HTML report."
  fi

  echo "-> Waiting $GIT_CHECK_EACH_NBMINUTES minutes before next model check."
  sleep ${GIT_CHECK_EACH_NBMINUTES}m

done

