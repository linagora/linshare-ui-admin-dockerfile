FROM httpd:2.4

MAINTAINER LinShare <linshare@linagora.com>

ARG VERSION="5.1.0"
ARG CHANNEL="releases"
ARG LEGACY_VERSION="4.2.7-legacy1"
ARG LEGACY_CHANNEL="releases"
# ARG LEGACY_CHANNEL="snapshots"
# ARG LEGACY_VERSION="4.2.8-SNAPSHOT"

ENV LINSHARE_SAFE_MODE=""
ENV LINSHARE_VERSION=$VERSION
ENV LINSHARE_LEGACY_VERSION=$LEGACY_VERSION
ENV LS_SECURE_COOKIE=TRUE

RUN apt-get update && apt-get install curl bzip2 -y && apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV URL="https://nexus.linagora.com/service/local/artifact/maven/content?r=linshare-${LEGACY_CHANNEL}&g=org.linagora.linshare&c=legacy&a=linshare-ui-admin&v=${LEGACY_VERSION}"
RUN curl -k -s "${URL}&p=tar.bz2" -o ui-admin.tar.bz2 && curl -k -s "${URL}&p=tar.bz2.sha1" -o ui-admin.tar.bz2.sha1 \
  && sed -i 's#^\(.*\)#\1\tui-admin.tar.bz2#' ui-admin.tar.bz2.sha1 \
  && sha1sum -c ui-admin.tar.bz2.sha1 --quiet && rm -f ui-admin.tar.bz2.sha1

RUN tar -jxf ui-admin.tar.bz2 -C /usr/local/apache2/htdocs && \
chown -R www-data /usr/local/apache2/htdocs/linshare-ui-admin && \
rm -f ui-admin.tar.bz2

COPY ./httpd.extra.conf /usr/local/apache2/conf/extra/httpd.extra.conf
RUN cat /usr/local/apache2/conf/extra/httpd.extra.conf >> /usr/local/apache2/conf/httpd.conf

COPY ./linshare-ui-admin.conf /usr/local/apache2/conf/extra/linshare-ui-admin.conf

ENV URL="https://nexus.linagora.com/service/local/artifact/maven/content?r=linshare-${CHANNEL}&g=org.linagora.linshare&a=linshare-ui-admin&v=${VERSION}"
RUN curl -k -s "${URL}&p=tar.bz2" -o ui-admin.tar.bz2 && curl -k -s "${URL}&p=tar.bz2.sha1" -o ui-admin.tar.bz2.sha1 \
  && sed -i 's#^\(.*\)#\1\tui-admin.tar.bz2#' ui-admin.tar.bz2.sha1 \
  && sha1sum -c ui-admin.tar.bz2.sha1 --quiet && rm -f ui-admin.tar.bz2.sha1

RUN tar -jxf ui-admin.tar.bz2 -C /usr/local/apache2/htdocs/linshare-ui-admin && \
chown -R www-data /usr/local/apache2/htdocs/linshare-ui-admin && \
mv -v /usr/local/apache2/htdocs/linshare-ui-admin/linshare-ui-admin /usr/local/apache2/htdocs/linshare-ui-admin/new && \
rm -f ui-admin.tar.bz2

EXPOSE 80
