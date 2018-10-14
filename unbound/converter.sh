#!/usr/bin/sh

file=adservers

   wget -N https://raw.githubusercontent.com/missdeer/blocklist/master/toblock-without-shorturl-optimized.lst
   echo "# Converted from https://github.com/missdeer/blocklist/blob/master/toblock-without-shorturl-optimized.lst" > $file
   echo "# https://github.com/missdeer/blocklist" >> $file
   echo "# Thanks to all contributors." >> $file
   echo '' >> $file

cat toblock-without-shorturl-optimized.lst | awk '{print "0.0.0.0 " $1}' |  awk '{print "local-zone: \""$2"\" redirect\nlocal-data: \""$2" A 0.0.0.0\""}' >> $file
 
# Cleanup...
rm toblock-without-shorturl-optimized.lst

git add .
git commit -m "`date`"
git push origin master
