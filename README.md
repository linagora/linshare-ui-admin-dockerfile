# Linshare UI-Admin

#### How to build the image

```bash
$ docker build --build-arg VERSION="LATEST" --build-arg CHANNEL="releases" -t linagora/linshare-ui-admin:latest .
```

#### How to run the container

```bash
$ docker run -d \
-e EXTERNAL_URL=<wanted_FQDN> \
-e TOMCAT_URL=<tomcat-ip> \
-e TOMCAT_PORT=<tomcat-port>
-p 443:443 \
linagora/linshare-ui-admin
```
