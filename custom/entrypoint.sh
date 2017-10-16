#!/bin/sh
set -e
ulimit -n 8192

###
# Variáveis definidas
#
## INTEGR8_OPENLDAP_DOMAIN
#
#
## INTEGR8_OPENLDAP_ROOTDN
#
#
## INTEGR8_OPENLDAP_ROOTPW
#
#
## INTEGR8_OPENLDAP_ADDITIONAL_SCHEMAS
#
#
## INTEGR8_OPENLDAP_ADDITIONAL_MODULES
#
#
###

FIRST_RUN=0;
INTEGR8_CONFIG_DIRECTORY='/etc/openldap/slapd.d/'
INTEGR8_OPENLDAP_CORE_SCHEMA='core,dyngroup,cosine,inetorgperson,openldap,corba,pmi,ppolicy,misc,nis'
SLAPD_CONF=""

if [ ! -d /openldap/ ]; then
  mkdir -p /openldap/config /openldap/ssl /openldap/prepopulate /openldap/schema
fi

# Verify the existence of slap.d directory
if [ ! -d $INTEGR8_CONFIG_DIRECTORY ]; then
  if [ -z $INTEGR8_OPENLDAP_DOMAIN ] ; then
    echo "The variable INTEGR8_OPENLDAP_DOMAIN need to be defined."
  else
    DISTINGUISHED_NAME=$(echo $INTEGR8_OPENLDAP_DOMAIN | sed -e 's/\([a-zA-Z0-9-]*\)/dc=\1/g' | sed -e 's/\./,/g')

    if [ -z $INTEGR8_OPENLDAP_ROOTDN ]; then
      INTEGR8_OPENLDAP_ROOTDN='cn=admin,'$DISTINGUISHED_NAME
      echo -e "The parameter \$INTEGR8_OPENLDAP_ROOTDN was not defined. The rootdn will be generated";
    fi

    if [ -z $INTEGR8_OPENLDAP_ROOTPW ]; then
      INTEGR8_OPENLDAP_ROOTPW=$(tr -cd '[:alnum:][:punct:]' < /dev/urandom | fold -w30 | head -n1)
      echo -e "The parameter \$INTEGR8_OPENLDAP_ROOTPW was not defined. The password will be generated";
    fi

    echo -e "\n\n###\n# INTEGR8_OPENLDAP_ROOTDN: $INTEGR8_OPENLDAP_ROOTDN\n# INTEGR8_OPENLDAP_ROOTPW: $INTEGR8_OPENLDAP_ROOTPW\n###\n\n"

    echo $(slappasswd -u -h '{SSHA}' -s "${INTEGR8_OPENLDAP_ROOTPW}") > /openldap/config/rootpwd
  fi

  

  cat <<-EOF >> /openldap/config/slapd.conf
	include /etc/openldap/schema/core.schema
	include /etc/openldap/schema/dyngroup.schema
	include /etc/openldap/schema/cosine.schema
	include /etc/openldap/schema/inetorgperson.schema
	include /etc/openldap/schema/openldap.schema
	include /etc/openldap/schema/corba.schema
	include /etc/openldap/schema/pmi.schema
	include /etc/openldap/schema/ppolicy.schema
	include /etc/openldap/schema/misc.schema
	include /etc/openldap/schema/nis.schema
	EOF


fi

chown -R ldap:ldap /openldap/

function createopenLDAPDirectory {
  mkdir -p $INTEGR8_CONFIG_DIRECTORY
  chmod 750 $INTEGR8_CONFIG_DIRECTORY
}
#
# while true ; do sleep 60 ; done ;
