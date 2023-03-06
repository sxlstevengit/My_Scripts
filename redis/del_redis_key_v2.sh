#!/bin/bash

IP=10.20.1.58
PORT=6379
PASS="password@123"
DB=0

#获取当前时间
Get_Time(){
now_time=`date '+%Y-%m-%d %H:%M:%S'`
echo  $now_time
}

#判断特征key是否存在
Keys_Exist(){
result=`redis-cli -h $IP -p $PORT -a $PASS -n $DB get $1`
if [[ $result == '' ]]
  then
    echo "该特征的key不存在"
    continue
else
 echo "存在"
fi
}


#遍历1.txt,把key添加到一个数组中keyslist，这个没有必要，直接遍历文件就可以。 key少的情况下，直接放一个数组里方便，如keyslist=(name sex age)
x=0
while read line
do
 keyslist[x]=$line
 #echo $line
 let x=x+1
done  < 1.txt

#echo  ${keyslist[*]}


for key in ${keyslist[@]}
do
  Keys_Exist $key
  echo -n "开始删除$key  " && Get_Time
  redis-cli -h $IP -p $PORT -a $PASS -n $DB --scan --pattern "$key" | xargs redis-cli -h $IP -p $PORT -a $PASS -n $DB del
  #redis-cli -h $IP -p $PORT -a $PASS -n $DB del "$key"
  echo -n "结束删除$key  " && Get_Time
done



#遍历一个文本文件
#for i in `cat 1.txt`;do echo $i;done
#while read line;do echo $line;done <1.txt
