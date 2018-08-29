from httpd:2.4

MAINTAINER LinShare <linshare@linagora.com>

ARG VERSION="3.1.3"
ARG CHANNEL="releases"
ARG EXT="com"

ENV LINSHARE_SAFE_MODE=""

RUN apt-get update && apt-get install wget bzip2 -y && apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN URL="https://nexus.linagora.${EXT}/service/local/artifact/maven/content?r=linshare-${CHANNEL}&g=org.linagora.linshare&a=linshare-ui-admin&v=${VERSION}"; \
wget --no-check-certificate --progress=bar:force:noscroll \
 -O ui-admin.tar.bz2 "${URL}&p=tar.bz2" && \
wget --no-check-certificate --progress=bar:force:noscroll \
 -O ui-admin.tar.bz2.sha1 "${URL}&p=tar.bz2.sha1" && \
sed -i 's#^\(.*\)#\1\tui-admin.tar.bz2#' ui-admin.tar.bz2.sha1 && \
sha1sum -c ui-admin.tar.bz2.sha1 --quiet && rm -f ui-admin.tar.bz2.sha1

RUN tar -jxf ui-admin.tar.bz2 -C /usr/local/apache2/htdocs && \
chown -R www-data /usr/local/apache2/htdocs/linshare-ui-admin && \
rm -f ui-admin.tar.bz2

COPY ./httpd.extra.conf /usr/local/apache2/conf/extra/httpd.extra.conf
RUN cat /usr/local/apache2/conf/extra/httpd.extra.conf >> /usr/local/apache2/conf/httpd.conf

COPY ./linshare-ui-admin.conf /usr/local/apache2/conf/extra/linshare-ui-admin.conf

EXPOSE 80
