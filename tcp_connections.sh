#!/bin/bash
SYNRECV(){
a=`/usr/sbin/ss -ant | awk '{++s[$1]} END {for(k in s) print k,s[k]}' | grep 'SYN-RECV' | awk '{print $2}'`
if test -z "$a"
then
   echo 0
else
   echo $a
fi
}
ESTAB(){
a=`/usr/sbin/ss -ant | awk '{++s[$1]} END {for(k in s) print k,s[k]}' | grep 'ESTAB' | awk '{print $2}'`
if test -z "$a"
then
   echo 0
else
   echo $a
fi
}
TIMEWAIT(){
a=`/usr/sbin/ss -ant | awk '{++s[$1]} END {for(k in s) print k,s[k]}' | grep 'TIME-WAIT' | awk '{print $2}'`
if test -z "$a"
then
   echo 0
else
   echo $a
fi
}
TOTAL(){
a=`/usr/sbin/ss -ant | awk 'BEGIN{t=0;} { t++; } END{print t; }'`
if test -z "$a"
then
   echo 0
else
   echo $a
fi
}
$1
