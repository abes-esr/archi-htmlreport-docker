FROM nginx:1.17.1

MAINTAINER Stéphane Gully <gully@abes.fr>

ENV ARCHI_VERSION 4.4.0
ENV ARCHI_PLUGIN_MODELREPOSITORY_VERSION 0.5.1.201904031126

# libswt-gtk2-4-jni for archimatetool system dependency
# xvfb for a headless Xserver needed by archimatetool -nosplash to run without error
# jq for package.json parsing
# git for archi model download and updates
# wget/uzip for Archi/plugins download and extracting
RUN apt update && \
    apt install -y xvfb libswt-gtk2-4-jni jq git unzip wget

# download archimatetool
RUN wget https://www.archimatetool.com/downloads/${ARCHI_VERSION}/Archi-Linux64-${ARCHI_VERSION}.tgz && \
    tar -zxvf /Archi-Linux64-${ARCHI_VERSION}.tgz && \
    rm -f /Archi-Linux64-${ARCHI_VERSION}.tgz

# git plugin for archimatetool 
RUN wget https://www.archimatetool.com/downloads/plugins/org.archicontribs.modelrepository_${ARCHI_PLUGIN_MODELREPOSITORY_VERSION}.zip && \
  cd /Archi/plugins/ && \
  unzip /org.archicontribs.modelrepository_${ARCHI_PLUGIN_MODELREPOSITORY_VERSION}.zip && \
  rm -f /org.archicontribs.modelrepository_${ARCHI_PLUGIN_MODELREPOSITORY_VERSION}.zip

# TODO: a retirer et a remplacer par un process de git clone dans l'entrypoint
COPY ./SI_ABES/ /archi-model-git-repo/
COPY ./create-htmlreport.postscript.sh /archi-model-git-repo/

COPY ./package.json /usr/share/nginx/html/
COPY ./docker-entrypoint.sh /
COPY ./create-htmlreport.periodically.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
