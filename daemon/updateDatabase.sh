#!/bin/sh
wget http://download.wikipedia.com/zhwiki/latest/zhwiki-latest-page.sql.gz
gzip -d zhwiki-latest-page.sql.gz
wget http://download.wikipedia.com/zhwiki/latest/zhwiki-latest-pagelinks.sql.gz
gzip -d zhwiki-latest-pagelinks.sql.gz
wget http://download.wikipedia.com/zhwiki/latest/zhwiki-latest-redirect.sql.gz
gzip -d zhwiki-latest-redirect.sql.gz
mono data_processing.exe
rm -f zhwiki-*
/etc/init.d/wikker restart
