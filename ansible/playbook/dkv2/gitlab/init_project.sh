#!/bin/bash
# 用于gitlab创建项目后，初始化本地目录

PRO_NAME=$1
PRO_DIR=$2
ENV=$3
GITLAB_URL="ssh://git@gitlab.abc.com:2222/rongyi"


#定义帮助函数
Usage(){
  echo "参数错误，请重新执行.参数之间以空格分隔。参数1: Project_name; 参数2: Project_dir; 参数3：Env"
  echo "请这样执行： bash init_project.sh 参数1 参数2 参数3"
  exit 1
}

#判断参数个数
if [[ $# -ne 3 ]];then
 Usage
fi

Init_Project(){
  cd ${PRO_DIR}  && git init && git remote add origin ${GITLAB_URL}/${PRO_NAME}.git && {
  touch README.md 
  git add README.md
  git commit -m "add README"
  git push -u origin master
} 
 if [[ $ENV == "test" ]];then
  git checkout -b test && touch test.md && git add test.md && git commit -m "add test" && git push origin test
 elif [[ $ENV == "stag" ]];then
  git checkout -b v4 && git push origin v4
  #git checkout -b v4 && touch v4.md && git add v4.md && git commit -m "add v4" && git push origin v4
 elif [[ $ENV == "prod" ]];then
  git checkout -b v8 && git push origin v8
  #git checkout -b v8 && touch v8.md && git add v8.md && git commit -m "add v8" && git push origin v8
 else
  echo "什么也不做"
 fi

}

Init_Project
