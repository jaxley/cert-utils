#!/usr/bin/env bash

# This is a script to automate importing a ca certificate chain or concatenated
# list of CA certificates from a PEM file into the java cacerts keystore

# This was written on a mac so has not been tested on linux

PEMFILENAME=all.pem
PEMDIR=$(cd "$(dirname "$1")"; pwd -P)/$(basename "$1")
TEMPDIR=$(mktemp -d) || exit 1
echo "Using temp dir:  ${TEMPDIR}"
pushd $TEMPDIR

csplit -k -f cert- ${PEMDIR}/all.pem '/-----BEGIN CERTIFICATE-----/' '{99}'

JAVA_HOME=$(/usr/libexec/java_home)
KEYSTORE=${JAVA_HOME}/lib/security/cacerts

for file in cert*
do
   keytool -cacerts -trustcacerts -importcert -noprompt -storepass changeit -alias $file -file $file
done

popd
