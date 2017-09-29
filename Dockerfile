FROM integr8.me/alpine-base:1.0
LABEL Maintainer = "Wordbox Inc."
LABEL Description = "Base alpine image to build another images"

COPY custom/entrypoint.sh /usr/local/bin/

RUN apk --update --no-cache --virtual=build-dependencies add curl ca-certificates \
  tar openldap openldap-clients openldap-back-monitor openssl \
  && mkdir -p /ldap/ldif && chmod a+x /usr/local/bin/entrypoint.sh

RUN rm -rf /var/cache/apk/*

EXPOSE 389/tcp

# VOLUME
#
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["slapd", "-d", "32768", "-u", "ldap", "-g", "ldap"]
