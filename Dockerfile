from httpd:2.4

ARG VERSION="2.5.1"
ARG CHANNEL="releases"
ARG EXT="com"

RUN apt-get update && apt-get install wget bzip2 -y && apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo "$CHANNEL" | grep "releases" 2>&1 > /dev/null && \
URL="https://nexus.linagora.${EXT}/service/local/artifact/maven/content?r=linshare-${CHANNEL}&g=org.linagora.linshare&a=linshare-ui-admin&v=${VERSION}" \
|| URL="https://nexus.linagora.${EXT}/service/local/artifact/maven/content?r=linshare-${CHANNEL}&g=org.linagora.linshare&a=linshare-ui-admin&v=${VERSION}-SNAPSHOT"; \
wget --no-check-certificate --progress=bar:force:noscroll \
 -O ui-admin.tar.bz2 "${URL}&p=tar.bz2" && \
wget --no-check-certificate --progress=bar:force:noscroll \
 -O ui-admin.tar.bz2.sha1 "${URL}&p=tar.bz2.sha1" && \
sed -i 's#^\(.*\)#\1\tui-admin.tar.bz2#' ui-admin.tar.bz2.sha1 && \
sha1sum -c ui-admin.tar.bz2.sha1 --quiet && rm -f ui-admin.tar.bz2.sha1

RUN tar -jxf ui-admin.tar.bz2 -C /usr/local/apache2/htdocs && \
mv /usr/local/apache2/htdocs/linshare-ui-admin-2.5.1 /usr/local/apache2/htdocs/linshare-ui-admin && \
chown -R www-data /usr/local/apache2/htdocs/linshare-ui-admin && \
rm -f ui-admin.tar.bz2

COPY ./httpd.conf /usr/local/apache2/conf/httpd.conf
COPY ./linshare-ui-admin.conf /usr/local/apache2/conf/extra/linshare-ui-admin.conf

EXPOSE 443
