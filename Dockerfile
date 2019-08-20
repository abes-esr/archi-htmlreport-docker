FROM nginx:1.17.1

MAINTAINER Stéphane Gully <gully@abes.fr>

ENV ARCHI_VERSION 4.4.0
ENV ARCHI_PLUGIN_MODELREPOSITORY_VERSION 0.5.1.201904031126

# libswt-gtk2-4-jni for archimatetool system dependency
# xvfb for a headless Xserver needed by archimatetool -nosplash to run without error
# jq for package.json parsing
# git for archi model download and updates
# wget/uzip for Archi/plugins download and extracting
# vim for easy debug
RUN apt update && \
    apt install -y xvfb libswt-gtk2-4-jni jq git unzip wget vim

# download archimatetool
RUN wget https://www.archimatetool.com/downloads/${ARCHI_VERSION}/Archi-Linux64-${ARCHI_VERSION}.tgz && \
    tar -zxvf /Archi-Linux64-${ARCHI_VERSION}.tgz && \
    rm -f /Archi-Linux64-${ARCHI_VERSION}.tgz

# git plugin for archimatetool 
RUN wget https://www.archimatetool.com/downloads/plugins/org.archicontribs.modelrepository_${ARCHI_PLUGIN_MODELREPOSITORY_VERSION}.zip && \
  cd /Archi/plugins/ && \
  unzip /org.archicontribs.modelrepository_${ARCHI_PLUGIN_MODELREPOSITORY_VERSION}.zip && \
  rm -f /org.archicontribs.modelrepository_${ARCHI_PLUGIN_MODELREPOSITORY_VERSION}.zip

COPY ./package.json /usr/share/nginx/html/
COPY ./docker-entrypoint.sh /
COPY ./create-htmlreport.periodically.sh /
RUN echo "abesesr/archi-htmlreport-docker:1.2.0 generated web site is empty." > /usr/share/nginx/html/index.html && \
    echo "abesesr/archi-htmlreport-docker:1.2.0" > /version.html

# for git clone through ssh stuff
RUN mkdir -p /root/.ssh/
RUN echo "Host *" > /root/.ssh/config && echo "StrictHostKeyChecking no" >> /root/.ssh/config

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
