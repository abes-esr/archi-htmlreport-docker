#!/bin/sh


# loop forever but wait $GIT_CHECK_EACH_NBMINUTES between each loops 
while true
do

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

  echo "-> Waiting $GIT_CHECK_EACH_NBMINUTES minutes before next model check."
  sleep ${GIT_CHECK_EACH_NBMINUTES}m

done

