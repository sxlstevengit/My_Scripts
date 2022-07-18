#!/bin/bash
# 脚本用于删除部分redis中某些特征的key

#命令使用举例
#redis-cli -h 10.20.1.58 -p 6379 -a password@123 --scan --pattern 'ACTIVITY_6*' | xargs redis-cli -h 10.20.1.58 -p 6379 -a password@123 del
#redis-cli -h 10.20.1.58 -p 6379 -a password@123 --scan --pattern 'PLATFORM_GAMEE_ACTIVITY_676_WINNING_oq*' | xargs redis-cli -h 10.20.1.58 -p 6379 -a password@123 del

#定义数组和变量
KEYS_LIST=(NAME_T* AGE_T* PLATFORM_GAMEE_ACTIVITY_6* ACTIVITY_6* ACTIVITY__ACTIVITYID_6* ACTIVITY__NEW_PRIZE_* ACTIVITY__PLAYRECORDID_* ACTIVITY__PLAYRECORDID_TIMES_*)
IP=10.20.1.58
PORT=6379
PASS=password@123

#获取当前时间
Get_Time(){
now_time=`date '+%Y-%m-%d %H:%M:%S'`
echo  $now_time
}

#判断特征key是否存在
Keys_Exist(){
result=`redis-cli -h $IP -p $PORT -a $PASS --scan --pattern $1 | wc -l`
if [[ $result -eq 0 ]]
  then
    echo "该特征的key不存在"
    continue
fi
}

#遍历删除
for key in ${KEYS_LIST[@]}
do
  Keys_Exist $key
  echo -n "开始删除$key  " && Get_Time
  redis-cli -h $IP -p $PORT -a $PASS --scan --pattern $key | xargs redis-cli -h $IP -p $PORT -a $PASS del
  echo -n "结束删除$key  " && Get_Time
done
