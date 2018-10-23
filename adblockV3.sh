#!/usr/bin/sh
set -x
# Backup hosts file.
cp /etc/hosts /etc/hosts.old

OUTPUTFILE=/etc/hosts
HEADER=/etc/hosts.head

# Set up working dir.
TMPDIR=/tmp/hostadblock.XXXXXX
mktemp -d "${TMPDIR}"

BLACKLIST=${TMPDIR}/mybase.txt 
WHITELIST=${TMPDIR}/whitelist

# Download blocklists
wget -P "${TMPDIR}" https://download.dnscrypt.info/blacklists/domains/mybase.txt
wget -P "${TMPDIR}" https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
wget -P "${TMPDIR}" https://raw.githubusercontent.com/archfate/Hosts/master/whitelist.txt

# Transform format
grep '^0\.0\.0\.0' ${TMPDIR}/hosts | awk '{print $2}' > ${TMPDIR}/alpha
sed '/#/d; /*/d; /^$/d; /^\./d' ${TMPDIR}/mybase.txt > ${TMPDIR}/beta 

# remove duplicates.
sort -u ${TMPDIR}/alpha ${TMPDIR}/beta > ${TMPDIR}/filler.txt 

# Whitelist if needed. (
sort -n ${TMPDIR}/whitelist.txt > $WHITELIST 
comm -23 ${TMPDIR}/filler.txt $WHITELIST > $BLACKLIST 
    
# Set up hosts header, finalizing formatng for hosts. 
cat $HEADER > $OUTPUTFILE 
awk '{print "0.0.0.0 " $1}' $BLACKLIST >> $OUTPUTFILE

# Clean up
rm -rf "${TMPDIR}"
