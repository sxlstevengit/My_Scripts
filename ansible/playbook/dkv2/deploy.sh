#!/bin/bash
#Date: 2021-05-28
#Author: steven
#Mail: sxl_youcun@qq.com
#Function: This script function is used to deploy
#Version: 3.0
#全局变量用大写；函数首字母大写；函数内的变量用小写; 数组直接用小写，前面带array

#定义帮助函数
Func(){
  echo "  `basename $0` -[h t c p f m b g] args." >&2
  cat <<- EOF 
  ############################## 参数说明 ##############################
         -t --target=平台 ['ryv4','ryv8','wccv4','wccv8','wwjv4','wwjv8' ,'dktest','dkv4','dkv8']
         -c --class=类型 ['fe','php','java | env | etc | docker | apollo']....如配置参数 --new 及为生成新模块
         -p --project|path=项目/路径 ....
         -r --read=文件名 [多个war包配置文件]
         -f --filename=war包名
         -m --md5=md5
         -b --branch=branch
         -g --gitname=gitname
         -u --username=username
         -d --database=database
         -o --other=other [其它参数 fe配置 'key1:val1,key2:val2']
         --roll [回滚操作 默认回滚最近一次版本]
         -n --number=number [回滚至上个版本的次数，指定回滚的版本号,配合'--roll'使用]
         --new 生成新模块并部署至相应主机
         --nodatabase 授权用户访问数据，不创建数据库的,配合'-c db'使用
         --update 仅更新war/jar文件,更新JAVA模块使用
	EOF
  exit 0
}


# 定义数组： -A是定义关联数组; -a是定义普通数组; 也可以不申明
# 关联数组的下标可以为字符；普通数组下标一般只能是数字，下标从0开始。
# 问题？ 在函数中定义数组；然后其它函数中引用不到数组的值。
declare -A deploy_args
declare -a array_targets array_classes

# target数组：平台; class数组：类型
array_targets=(ryv4 ryv8 wccv4 wcc8 dktest dkv4 dkv8)
array_classes=(java php fe env etc ng db docker apollo sv supervisord)

# 判断如果没有任何参数，给出提示并退出
[[ $# -eq 0 ]] && echo "没有任何参数输入" && exit 1

# 使用循环结合getopts进行选项和参数的解析; 然后把选项的参数赋值给数组deploy_args中的元素。 
while getopts ":ht:c:p:f:m:b:g:R:" options
do 
    case $options in
     t)  deploy_args["target"]=${OPTARG};;
     c)  deploy_args["class"]=${OPTARG};;
     p)  deploy_args["project"]=${OPTARG};;
     b)  deploy_args["branch"]=${OPTARG};;
     g)  deploy_args["gitname"]=${OPTARG};;
     f)  deploy_args["filename"]=${OPTARG};;
     m)  deploy_args["md5"]=${OPTARG};;
     R)  deploy_args["roll"]=${OPTARG};;
     h)  Func;;
     ?)  Func;;
     :) echo "No argument value for option $OPTARG";;
    esac
done

# :=~：正则匹配，用来判断其左侧的参数是否符合右边的要求，如果匹配就输出1，不匹配就输出0.  
# 对平台或者类型参数进行判断，看是否包含在array_targets和array_classes数组中 
Check_Arg(){
 # 此处又对数组中的元素值进行判断，如果为空则提醒并退出
 [[ -z "${deploy_args['target']}" ||  -z "${deploy_args['class']}" ]] && echo "target or class为空值，请确认" && exit 2
 if [[ " ${array_targets[@]} " =~ " ${deploy_args['target']} " && " ${array_classes[@]} " =~ " ${deploy_args['class']} " ]] ;then
   echo "-t target和 -c class输入正确"
 else
   echo "-t target 或者 -c class输入错误,请确认"
   exit 3
 fi
}

TARGET=${deploy_args['target']}
CLASS=${deploy_args['class']}


#提交参数构建到jenkins; 调用jenkins脚本
Check_Fe_Arg(){
  
  project=${deploy_args['project']}
  branch=${deploy_args['branch']}
  gitname=${deploy_args['gitname']}
  roll_num=${deploy_args['roll']}
  module_name=${deploy_args['md5']} 
  # 此处为了和JAVA共用m这个选项，注意一下,当然也可以重新添加一个参数选项。
  if [[ -z $roll_num ]];then
    [[ -z "$project" ||  -z "$branch" || -z "$gitname" ]] && {
      echo "project or branch or gitname为空值，请确认" 
      exit 8
    }
  # [[ -z ${module_name} ]] && bash jenkins/build_fe_jenkins.sh $project $branch $gitname || {
  # bash jenkins/build_fe_jenkins.sh $project $branch $gitname $module_name
  # }
  fi
}

# 定义检测java文件md5值函数
Check_Md5(){

  #此处PROJECT指java包编译好之后的路径，FILENAME就是文件名，MD5值就是文件md5值
  project=${deploy_args['project']}
  filename=${deploy_args['filename']}
  md5=${deploy_args['md5']}
  roll_num=${deploy_args['roll']}
  if [[ -z $roll_num ]];then
    [[ -z "$project" ||  -z "$filename" || -z "$md5" ]] && {
      echo "project or filename or md5为空值，请确认" 
      exit 4
    }
 
    [[ -d $project ]] || {
      echo "${project}目录不存在,请确认"
      exit 6
    }
 
    cd ${project} && [[ -e $filename ]] || {
     echo "${filename}不存在，请确认"
     exit 7
    }

    #检查java文件的md5值
    check_md5=`cd $project && md5sum $filename | cut -d" " -f1`
    
    #回到脚本所有目录
    cd /etc/ansible/new_playbook/dkparkv3
 
    #从文件名中截取模块的名称
    #module=`echo ${filename} | cut -d"-" -f1-2`
    module=`echo ${filename} | sed 's/[0-9.].*$//g'| sed 's/-$//g'`
    [ "${check_md5}" != "$md5" ] && {
       echo "md5值不匹配,请确认"
       exit 5
    }
  fi
}

# 检测php
Check_Php_Arg(){
  project=${deploy_args['project']}
  branch=${deploy_args['branch']}
  roll_num=${deploy_args['roll']}
  if [[ -z $roll_num ]];then
    [[ -z "$project" ||  -z "$branch" ]] && {
      echo "project or branch为空值，请确认" 
      exit 9
    }
  fi
}


# 检测是否回滚
Check_Roll_Arg(){
 rolls=${deploy_args['roll']}
}


# 判断版本库日志，确定最大可回滚数
Check_Max_Roll(){
 class_dir=$1
 cd $class_dir
 max_num_ver=`git log --pretty=oneline|wc -l`
 if [[ $rolls -gt $max_num_ver ]];then
   echo "超出最大可回滚版本数"
   exit 10
 fi
}

#定义基础的目录，上面判断版本库函数需要用到
BASE_DIR="/etc/ansible/new_playbook/dkparkv3"


# 定义发布的函数
Deploy_Service() {

# 把数组的值赋值给两个变量


case $TARGET in
  dktest)
    echo "你选择的部署平台是: $TARGET, 类型是: $CLASS"
    if [ "$CLASS" = "etc" ]; then
      Check_Roll_Arg 
      [[ -z $rolls ]] && ansible-playbook -e "dkserver=bigops" -e "env=test" dk-etc.yml || {
      ansible-playbook -e "dkserver=bigops" -e "env=test" -e "rolls=$rolls" dk-etc.yml
      }
    elif [ "$CLASS" = "fe" ]; then 
      Check_Fe_Arg
      Check_Roll_Arg
      [[ -z $rolls ]] && ansible-playbook -e "dkserver=bigops" -e "env=test" -e "project=$project" dk-fe.yml || {
      ansible-playbook -e "dkserver=bigops" -e "env=test" -e "project=$project" -e "rolls=$rolls" dk-fe.yml
      }
    elif [ "$CLASS" = "java" ]; then
      Check_Md5 
      Check_Roll_Arg
      [[ -z $rolls ]] && ansible-playbook -e "dkserver=bigops" -e "env=test" -e "file_path=$project" -e "filename=$filename" -e "module=$module" dk-java.yml || {
      #如果是回滚，则只需要提供java模块的名称即可，其它变量就不用传递。
      ansible-playbook -e "dkserver=bigops" -e "env=test" -e "module=${deploy_args['project']}" -e "rolls=$rolls" dk-java.yml
      }
    else
      echo "什么也不做"
    fi
    ;;
  dkv4)
    echo "你选择的部署平台是: $TARGET, 类型是: $CLASS"
    if [ "$CLASS" = "etc" ]; then
      Check_Roll_Arg 
      [[ -z $rolls ]] && ansible-playbook -e "dkserver=h1" -e "env=stag" dk-etc.yml || {
      ansible-playbook -e "dkserver=h1" -e "env=stag" -e "rolls=$rolls" dk-etc.yml
      }
    elif [ "$CLASS" = "fe" ]; then 
      Check_Fe_Arg
      Check_Roll_Arg
      [[ -z $rolls ]] && ansible-playbook -e "dkserver=h1" -e "env=stag" -e "project=$project" dk-fe.yml || {
      ansible-playbook -e "dkserver=h1" -e "env=stag" -e "project=$project" -e "rolls=$rolls" dk-fe.yml
      }
    elif [ "$CLASS" = "java" ]; then
      Check_Md5 
      Check_Roll_Arg
      [[ -z $rolls ]] && ansible-playbook -e "dkserver=h1" -e "env=stag" -e "file_path=$project" -e "filename=$filename" -e "module=$module" dk-java.yml || {
      #如果是回滚，则只需要提供java模块的名称即可，其它变量就不用传递。
      ansible-playbook -e "dkserver=h1" -e "env=stag" -e "module=${deploy_args['project']}" -e "rolls=$rolls" dk-java.yml
      }
    else
      echo "什么也不做"
    fi
    ;;
  dkv8)
    echo "功能开发中，马上回来"
    #echo "你选择的部署平台是: $TARGET, 类型是: $CLASS"
    #if [ "$CLASS" = "etc" ]; then
    #  Check_Roll_Arg 
    #  [[ -z $rolls ]] && ansible-playbook -e "dkserver=dk-java-prod" -e "env=prod" dk-etc.yml || {
    #  ansible-playbook -e "dkserver=dk-java-prod" -e "env=prod" -e "rolls=$rolls" dk-etc.yml
    #  }
    #elif [ "$CLASS" = "fe" ]; then 
    #  Check_Fe_Arg
    #  Check_Roll_Arg
    #  [[ -z $rolls ]] && ansible-playbook -e "dkserver=dk-ng-prod" -e "env=prod" -e "project=$project" dk-fe.yml || {
    #  ansible-playbook -e "dkserver=dk-ng-prod" -e "env=prod" -e "project=$project" -e "rolls=$rolls" dk-fe.yml
    #  }
    #elif [ "$CLASS" = "java" ]; then
    #  Check_Md5 
    #  Check_Roll_Arg
    #  [[ -z $rolls ]] && ansible-playbook -e "dkserver=dk-java-prod" -e "env=prod" -e "file_path=$project" -e "filename=$filename" -e "module=$module" dk-java.yml || {
    #  #如果是回滚，则只需要提供java模块的名称即可，其它变量就不用传递。
    #  ansible-playbook -e "dkserver=dk-java-prod" -e "env=prod" -e "module=${deploy_args['project']}" -e "rolls=$rolls" dk-java.yml
    #  }
    #else
    #  echo "什么也不做"
    #fi
    ;;
  ryv4)
    echo "你选择的部署平台是: $TARGET, 类型是: $CLASS"
    if [ "$CLASS" = "etc" ]; then
      Check_Roll_Arg
      [[ -z $rolls ]] && ansible-playbook -e "ryserver=bigops" -e "env=stag" ry-etc.yml || {
      ansible-playbook -e "ryserver=bigops" -e "env=stag" -e "rolls=$rolls" ry-etc.yml
      }
    elif [ "$CLASS" = "fe" ]; then
      Check_Fe_Arg
      Check_Roll_Arg
      [[ -z $rolls ]] && ansible-playbook -e "ryserver=bigops" -e "env=stag" -e "project=$project" ry-fe.yml || {
      ansible-playbook -e "ryserver=bigops" -e "env=stag" -e "project=$project" -e "rolls=$rolls" ry-fe.yml
      }
    elif [ "$CLASS" = "java" ]; then
      Check_Md5
      Check_Roll_Arg
      [[ -z $rolls ]] && ansible-playbook -e "ryserver=bigops" -e "env=stag" -e "file_path=$project" -e "filename=$filename" -e "module=$module" ry-java.yml || {
      #如果是回滚，则只需要提供java模块的名称即可，其它变量就不用传递。
      ansible-playbook -e "ryserver=bigops" -e "env=stag" -e "module=${deploy_args['project']}" -e "rolls=$rolls" ry-java.yml
      }
    elif [ "$CLASS" = "php" ]; then
      Check_Php_Arg
      Check_Roll_Arg
      [[ -z $rolls ]] && ansible-playbook -e "ryserver=bigops" -e "env=stag" -e "project=$project" -e "branch=$branch" ry-php.yml || {
      #如果是回滚，则只需要提供php项目的名称即可，其它变量就不用传递。
      ansible-playbook -e "ryserver=bigops" -e "env=stag" -e "project=$project" -e "rolls=$rolls" ry-php.yml
      }
    else
     echo "什么也不做"
    fi
    ;;
  ryv8)
    echo "你选择的部署平台是: $TARGET, 类型是: $CLASS"
    if [ "$CLASS" = "etc" ]; then
      Check_Roll_Arg
      [[ -z $rolls ]] && ansible-playbook -e "ryserver=h1" -e "env=prod" ry-etc.yml || {
      ansible-playbook -e "ryserver=h1" -e "env=prod" -e "rolls=$rolls" ry-etc.yml
      }
    elif [ "$CLASS" = "fe" ]; then
      Check_Fe_Arg
      Check_Roll_Arg
      [[ -z $rolls ]] && ansible-playbook -e "ryserver=h1" -e "env=prod" -e "project=$project" ry-fe.yml || {
      ansible-playbook -e "ryserver=h1" -e "env=prod" -e "project=$project" -e "rolls=$rolls" ry-fe.yml
      }
    elif [ "$CLASS" = "java" ]; then
      Check_Md5
      Check_Roll_Arg
      [[ -z $rolls ]] && ansible-playbook -e "ryserver=h1" -e "env=prod" -e "file_path=$project" -e "filename=$filename" -e "module=$module" ry-java.yml || {
      #如果是回滚，则只需要提供java模块的名称即可，其它变量就不用传递。
      ansible-playbook -e "ryserver=h1" -e "env=prod" -e "module=${deploy_args['project']}" -e "rolls=$rolls" ry-java.yml
      }
    elif [ "$CLASS" = "php" ]; then
      Check_Php_Arg
      Check_Roll_Arg
      [[ -z $rolls ]] && ansible-playbook -e "ryserver=h1" -e "env=prod" -e "project=$project" -e "branch=$branch" ry-php.yml || {
      #如果是回滚，则只需要提供php项目的名称即可，其它变量就不用传递。
      ansible-playbook -e "ryserver=h1" -e "env=prod" -e "project=$project" -e "rolls=$rolls" ry-php.yml
      }
    else
     echo "什么也不做"
    fi
    ;;
  wccv4)
    echo "功能开发中"
    #echo "你选择的部署平台是: $TARGET, 类型是: $CLASS"
    #if [ "$CLASS" = "etc" ]; then
    #  ansible-playbook -e "dkserver=dk-java-prod" dk-etc.yml
    #elif [ "$CLASS" = "fe" ]; then
    #  ansible-playbook -e "dkserver=dk-ng-prod" -e "env=prod" dk-fe.yml
    #elif [ "$CLASS" = "java" ]; then
    #  Check_Md5
    #  ansible-playbook -e "dkserver=dk-java-prod" -e "env=prod" dk-java.yml
    #else
    # echo "什么也不做"
    #fi
    ;;
  wccv8)
    echo "功能开发中"
    #echo "你选择的部署平台是: $TARGET, 类型是: $CLASS"
    #if [ "$CLASS" = "etc" ]; then
    #  ansible-playbook -e "dkserver=dk-java-prod" dk-etc.yml
    #elif [ "$CLASS" = "fe" ]; then
    #  ansible-playbook -e "dkserver=dk-ng-prod" -e "env=prod" dk-fe.yml
    #elif [ "$CLASS" = "java" ]; then
    #  Check_Md5
    #  ansible-playbook -e "dkserver=dk-java-prod" -e "env=prod" dk-java.yml
    #else
    # echo "什么也不做"
    #fi
    ;;
  *)
    echo "你的输入已经被丢入太平洋"
esac
}

Main(){
 Check_Arg
 Deploy_Service
}

Main
