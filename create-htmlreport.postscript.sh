#!/bin/sh

GIT_FOLDER=$(pwd)
mkdir -p /usr/share/nginx/html/annuaires/
cd /usr/share/nginx/html/annuaires/

/Archi/jre/bin/java -jar ${GIT_FOLDER}/annuaires/saxon8.jar \
  ${GIT_FOLDER}/model.archimate \
  ${GIT_FOLDER}/annuaires/annuaireHtml_WS_fromArchi.xsl

/Archi/jre/bin/java -jar ${GIT_FOLDER}/annuaires/saxon8.jar \
  ${GIT_FOLDER}/model.archimate \
  ${GIT_FOLDER}/annuaires/annuaireHtml_Apps_fromArchi.xsl

/Archi/jre/bin/java -jar ${GIT_FOLDER}/annuaires/saxon8.jar \
  ${GIT_FOLDER}/model.archimate \
  ${GIT_FOLDER}/annuaires/annuaireHtml_Interfaces_fromArchi.xsl

/Archi/jre/bin/java -jar ${GIT_FOLDER}/annuaires/saxon8.jar \
  ${GIT_FOLDER}/model.archimate \
  ${GIT_FOLDER}/annuaires/annuaireHtml_FonctionsApps_fromArchi.xsl


