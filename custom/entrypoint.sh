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
SLAPD_DIRECTORY='/etc/openldap/slapd.d'

INTEGR8_OPENLDAP_ROOTPW='dadas'

# Verify the existence of slap.d directory
if [ ! -d $SLAPD_CONFIG_DIRECTORY ]; then

  if [ -z $INTEGR8_OPENLDAP_DOMAIN ] || [ -z $INTEGR8_OPENLDAP_ROOTDN ] || [ -z $INTEGR8_OPENLDAP_ROOTDN ]; then
    echo "The variables INTEGR8_OPENLDAP_DOMAIN, INTEGR8_OPENLDAP_ROOTDN and INTEGR8_OPENLDAP_ROOTDN need to be defined."
  else
    echo $(slappasswd -s "${INTEGR8_OPENLDAP_ROOTPW}")
  fi

fi

function createopenLDAPDirectory {
  mkdir -p $SLAPD_CONFIG_DIRECTORY
  chmod 750 $SLAPD_CONFIG_DIRECTORY
}
