#!/bin/bash
set +e
a=10

#set first second third
#echo $3 $2 $1
set -- redis-server "$@"
echo "$@"
aa(){
   echo "welcome to my country"
   return 1
}
aa
[[ $a -gt 11 ]] && echo "hello"

echo "I am a boy"
