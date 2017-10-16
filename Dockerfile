FROM integr8.me/alpine-base:1.0.0
LABEL Maintainer = "Integr8 Inc."
LABEL Description = "OpenLDAP image"

RUN apk --update --no-cache --virtual=build-dependencies add curl ca-certificates \
  openldap openldap-clients openldap-back-monitor openssl

RUN rm -rf /var/cache/apk/*

COPY custom/entrypoint.sh /usr/local/bin/

RUN chmod a+x /usr/local/bin/entrypoint.sh

EXPOSE 389/tcp 636/tcp

# VOLUME
#
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
# CMD ["slapd", "-d", "32768", "-u", "ldap", "-g", "ldap"]
