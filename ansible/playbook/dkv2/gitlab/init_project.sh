#!/bin/bash
# 用于gitlab创建项目后，初始化本地目录，适合dikong

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

# 适合第一次创建项目且创建分支时使用
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


# git clone时，默认是按项目名自动创建目录；可以指定目录，只需要在后面指定一个目录即可。 语法：git clone url 目录。
# 此函数适合项目已经创建，需要在新的目录创建分支时。
Create_Branch(){
 if [[ $ENV == "test" ]];then
   cd ${PRO_DIR} &&  git clone ${GITLAB_URL}/${PRO_NAME}.git . && git checkout -b test && git push origin test
 elif [[ $ENV == "stag" ]];then
   cd ${PRO_DIR} &&  git clone ${GITLAB_URL}/${PRO_NAME}.git . && git checkout -b v4 && git push origin v4
 elif [[ $ENV == "prod" ]];then
   cd ${PRO_DIR} &&  git clone ${GITLAB_URL}/${PRO_NAME}.git . && git checkout -b v8 && git push origin v8
 else
  echo "什么也不做"
 fi

}






Menu(){
cat << EOF
----------------------------------------
|************请选择 ************|
----------------------------------------
`echo -e "\033[36m 请根据需要选择\033[0m"`
`echo -e "\033[35m 1)第一次初始化项目\033[0m"`
`echo -e "\033[35m 2)项目已经存在\033[0m"`
`echo -e "\033[37m 9)退出\033[0m"`
EOF

read -p "Input you num: " num

case $num in 

  1) 
    Init_Project
    ;;

  2) 
    Create_Branch
    ;;
  9)
    exit 2
    ;;
  *)
    echo "输入有误，请重新执行"
esac
}

Menu
