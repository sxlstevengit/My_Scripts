#!/bin/bash
# 用于创建新项目且初始化目录
# 语法定义： 全局变量用大写；函数首字母小写；函数内的变量小写；

# 在输入时，可以退格删除
stty erase '^H'

GITLAB_URL="http://192.168.10.74:9080"
ADMIN_TOKEN="FCq1uYzu9isp73hbX2ET"
NAMESPACE_ID=7
NAMESPACE="rongyi"
GITLAB_URL_SSH="ssh://git@gitlab.abc.com:2222/rongyi"
PRO_NAME=$1
BASE_DIR="/etc/ansible/new_playbook/dkparkv3/ry"
ENV=$2
CLASS=$3


# 如果curl不需要任何输出，请这样执行curl -s -o /dev/null

Create_Project(){
 project_name=$PRO_NAME
 result=`curl -s --request POST --header "PRIVATE-TOKEN: $ADMIN_TOKEN" --data "name=${project_name}&namespace_id=${NAMESPACE_ID}" ${GITLAB_URL}/api/v4/projects`
 echo $result |grep "has already been taken" >/dev/null
 if [[ $? -ne 0 ]];then
   echo "gitlab项目$project_name 创建成功"
 else
   echo "项目已存在，请确认"
   exit 1
 fi
}


#定义帮助函数
Usage(){
  echo "参数错误，请重新执行.参数之间以空格分隔。参数1: Project_name; 参数2：Env [stag|prod] ; 参数3： Class [java|fe|etc]"
  echo "请这样执行：bash `basename $0` 参数1 参数2 参数3"
  exit 1
}



#gitlab项目：  
#java/php/etc等共用一个项目，但是分支分v4和v8
#fe分v4和v8项目， 分别对应相应的v4和v8分支
#
#初始化脚本： 
#
#如果是fe的情况，则v4和v8都需要新建gitlab项目。
#如果其它，则v4和v8共同一个gitlab项目。
#
#那么如果环境是v4，则都进行gitlab初始化；
#如果环境是v8，则进行判断：fe进行gitlab初始化，其它直接clone项目，然后新建v8分支并提交v8分支到远程。



Init_Project(){
 if [[ $ENV == "stag" ]];then
  Create_Project
  mkdir -p ${BASE_DIR}/v4/${CLASS}/${PRO_NAME}
  cd ${BASE_DIR}/v4/${CLASS}/${PRO_NAME} && git init && git remote add origin ${GITLAB_URL_SSH}/${PRO_NAME}.git && {
  touch README.md
  git add README.md
  git commit -m "add README"
  git push -u origin master
  git checkout -b v4 
  git push origin v4
 } 
 elif [[ $ENV == "prod" ]];then
   [[ ${CLASS} == "fe" ]] && Create_Project && mkdir -p ${BASE_DIR}/v8/${CLASS}/${PRO_NAME} && {
   cd ${BASE_DIR}/v8/${CLASS}/${PRO_NAME} 
   git init 
   git remote add origin ${GITLAB_URL_SSH}/${PRO_NAME}.git
   touch README.md
   git add README.md
   git commit -m "add README"
   git push -u origin master
   git checkout -b v8
   git push origin v8
   } || {
   mkdir -p ${BASE_DIR}/v8/${CLASS} 
   cd ${BASE_DIR}/v8/${CLASS}
   git clone ${GITLAB_URL_SSH}/${PRO_NAME}.git
   cd ${BASE_DIR}/v8/${CLASS}/${PRO_NAME}
   git checkout -b v8
   git push origin v8
   }
 else
  echo "什么也不做"
 fi
 echo "${PRO_NAME}初始化完成"
}


#判断参数个数
Main(){
if [[ $# -ne 3 ]];then
 Usage
fi
Init_Project
}

Main $*
