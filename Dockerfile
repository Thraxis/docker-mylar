FROM lsiobase/alpine:3.11

# set version label
ARG BUILD_DATE
ARG VERSION
ARG MYLAR_COMMIT
LABEL build_version="Thraxis'  version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="Thraxis"

RUN \
echo "**** install build packages ****" && \
apk add --no-cache --virtual=build-dependencies \
 autoconf \
 automake \
 freetype-dev \
 g++ \
 gcc \
 jpeg-dev \
 lcms2-dev \
 libffi-dev \
 libpng-dev \
 libwebp-dev \
 libxml2-dev \
 libxslt-dev \
 linux-headers \
 make \
 openjpeg-dev \
 openssl-dev \
 libffi-dev \
 python3-dev \
 tiff-dev \
 zlib-dev && \
 echo "**** install system packages ****" && \
 apk add --no-cache \
  curl \
  freetype \
  git \
  lcms2 \
  libjpeg-turbo \
  libwebp \
  libxml2 \
  libxslt \
  openjpeg \
  openssl \
  p7zip \
  python3 \
  py3-pip \
  tar \
	tiff \
	unrar \
	unzip \
	vnstat \
	wget \
	xz \
	zlib \
	nodejs && \
 echo "**** install pip packages ****" && \
 ln -s /usr/bin/pip3 /usr/bin/pip && \
 pip install --upgrade pip && \
 pip install --no-cache-dir -U \
	comictagger==1.1.32rc1 \
	configparser \
	html5lib \
	requests \
	tzlocal \
 	cheetah \
 	lxml \
 	ndg-httpsclient \
 	notify \
 	paramiko \
 	pillow \
 	psutil \
 	pyopenssl \
 	requests \
 	setuptools \
 	urllib3 \
 	virtualenv && \
 echo "**** install app ****" && \
 if [ -z ${MYLAR_COMMIT+x} ]; then \
	MYLAR_COMMIT=$(curl -sX GET https://api.github.com/repos//mylar3/mylar3/commits/python3-dev \
	| awk '/sha/{print $4;exit}' FS='[""]'); \
 fi && \
 git clone -b python3-dev https://github.com/mylar3/mylar3.git /app/mylar && \
 cd /app/mylar && \
 git checkout ${MYLAR_COMMIT} && \
 pip install -r requirements.txt && \
 echo "**** cleanup ****" && \
 apk del --purge \
     build-dependencies && \
 rm -rf \
	/root/.cache \
	/tmp/*

# add local files
COPY root/ /

# ports and volumes
VOLUME /config /comics /downloads
EXPOSE 8090
