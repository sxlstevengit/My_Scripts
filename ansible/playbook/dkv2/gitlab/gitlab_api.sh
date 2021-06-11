#!/bin/bash
# 通过脚本创建项目、删除项目/创建删除分支/创建删除群组/创建删除用户
# 语法定义： 全局变量用大写；函数首字母小写；函数内的变量小写；

# 在输入时，可以退格删除
stty erase '^H'

GITLAB_URL="http://192.168.10.74:9080"
ADMIN_TOKEN="FCq1uYzu9isp73hbX2ET"
NAMESPACE_ID=7
NAMESPACE="rongyi"


# 如果curl不需要任何输出，请这样执行curl -s -o /dev/null

Create_Project(){
 read -p "请输入要创建的项目名称:" project_name
 result=`curl -s --request POST --header "PRIVATE-TOKEN: $ADMIN_TOKEN" --data "name=${project_name}&namespace_id=${NAMESPACE_ID}" ${GITLAB_URL}/api/v4/projects`
 echo $result |grep "has already been taken" >/dev/null
 if [[ $? -ne 0 ]];then
   echo "创建成功"
 else
   echo "项目已存在，请确认"
   exit 1
 fi
}

# 关于通过api删除仓库的，一个是在通过项目路径删除时，需要注意 "namespace/name" 这里的 "/" 需要通过URL编码,即这里的%2F
Delete_Project(){
 read -p "请输入要删除的项目名称:" project_name
 result=`curl -s -X DELETE "${GITLAB_URL}/api/v4/projects/${NAMESPACE}%2F${project_name}?private_token=$ADMIN_TOKEN"`
 echo $result |grep "404 Not Found" > /dev/null
 if [[ $? -ne 0 ]];then
   echo "删除成功"
 else
   echo "项目不存在，请确认"
   exit 1
 fi
}


Get_Pro_Num(){
  project_name=$1
  result=`curl -s --header "PRIVATE-TOKEN: $ADMIN_TOKEN" "${GITLAB_URL}/api/v4/projects?search=$project_name"`
  pro_id=`echo $result | awk -F[:,] '{print $2}'`
  echo "project_id is: $pro_id"
  return $pro_id
}


Create_Branch(){
 read -p "请输入项目名称和要创建的分支名称:" project_name branch_name
 echo "你输入的project_name: $project_name, branch_name: $branch_name"
 Get_Pro_Num $project_name >/dev/null
 project_id=$?
 result=`curl -s --request POST --header "PRIVATE-TOKEN: $ADMIN_TOKEN" "${GITLAB_URL}/api/v4/projects/${project_id}/repository/branches?branch=${branch_name}&ref=master"`
 echo $result |grep "Branch already exists" > /dev/null
 if [[ $? -ne 0 ]];then
   echo "创建分支成功"
 else
   echo "分支已存在，请确认"
   exit 1
 fi
}


Delete_Branch(){
 read -p "请输入项目名称和要删除的分支名称:" project_name branch_name
 echo "你输入的project_name: $project_name, branch_name: $branch_name"
 Get_Pro_Num $project_name >/dev/null
 project_id=$?
 result=`curl -s -X DELETE --header "PRIVATE-TOKEN: $ADMIN_TOKEN" "${GITLAB_URL}/api/v4/projects/${project_id}/repository/branches/${branch_name}"`
 echo $result |grep "404 Branch Not Found" > /dev/null
 if [[ $? -ne 0 ]];then
   echo "删除分支成功"
 else
   echo "分支不存在，请确认"
   exit 1
 fi
}



# 注意在SHELL中，发送POST和JSON数据，json数据里变量要用 '' 括起来。 如: "'$group_path'"
Create_Group(){
  read -p "请输入要创建的组名和组路径:" group_name group_path
  echo "你输入的group_name: $group_name, group_path: $group_path"
  result=`curl -s -X POST -H "PRIVATE-TOKEN: $ADMIN_TOKEN" -H "Content-Type: application/json" -d '{"path": "'$group_path'", "name": "'$group_name'"}' "${GITLAB_URL}/api/v4/groups/"`
  echo $result | grep "has already been taken" >/dev/null
  if [[ $? -ne 0 ]];then
   echo "创建组成功"
  else
   echo "组已经存在，请确认"
   exit 1
  fi
}


Get_Group_Id(){
 group_name=$1
 result=`curl -s --header "PRIVATE-TOKEN: $ADMIN_TOKEN"  "${GITLAB_URL}/api/v4/groups?search=${group_name}"`
 group_id=`echo $result | awk -F[:,] '{print $2}'`
 if [[ -z $group_id ]];then
   echo "组不存在，请确认后再次查询"
   exit 1
 else
  echo "group_id is: $group_id"
  return $group_id
 fi
}



Delete_Group(){
  read -p "请输入要删除的组名:" group_name
  echo "你输入的group_name: $group_name"
  Get_Group_Id $group_name
  group_id=$?
  echo $group_id
  result=`curl -s --request DELETE --header "PRIVATE-TOKEN: $ADMIN_TOKEN" "${GITLAB_URL}/api/v4/groups/${group_id}"`
  echo $result | grep "404 Group Not Found" >/dev/null
  if [[ $? -ne 0 ]];then
   echo "组删除成功"
  else
   echo "组不存在，请确认"
   exit 1
  fi
}


# 关于name和username的区别？  username就是你登录的用户名,name可以随意写，且称为昵称吧。
Add_User(){
  echo "开始添加用户，需要输入相关信息，中间用空格分隔"
  read -p "请输入用户名/密码/邮箱/昵称: " username password email name
  cat <<- EOF
  `echo -e "是否是管理员用户,请选择:"`
  `echo -e "\033[35m 1)Yes\033[0m"`
  `echo -e "\033[33m 2)No\033[0m"`
EOF
  read isadmin  
  echo "You input is username：$username, password: $password, email: $email, name: $name"
  if [[ $isadmin -eq 1 ]];then
    result=`curl -s -X POST -H "PRIVATE-TOKEN: $ADMIN_TOKEN" -d "password=${password}&email=${email}&username=${username}&name=${name}&admin=true" "${GITLAB_URL}/api/v4/users"`
    echo $result | grep "Email has already been taken" >/dev/null
    if [[ $? -ne 0 ]];then
      echo "用户${username}创建成功"
    else
      echo "用户${username}已经存在，请确认"
    fi
  else
    result=`curl -s -X POST -H "PRIVATE-TOKEN: $ADMIN_TOKEN" -d "password=${password}&email=${email}&username=${username}&name=${name}" "${GITLAB_URL}/api/v4/users"`
    echo $result | grep "Email has already been taken" >/dev/null
    if [[ $? -ne 0 ]];then
      echo "用户${username}创建成功"
    else
      echo "用户${username}已经存在，请确认"
    fi
  fi
}

Get_User_Id(){
 username=$1
 result=`curl -s --header "PRIVATE-TOKEN: $ADMIN_TOKEN"  "${GITLAB_URL}/api/v4/users?search=${username}"`
 #echo $result
 user_id=`echo $result | awk -F[:,] '{print $2}'`
 #echo $user_id 
 if [[ -z $user_id ]];then
   echo "用户不存在，请确认后再次查询"
   exit 1
 else
  echo "user_id is: $user_id"
  return $user_id
 fi
}


Delete_User(){
  read -p "请输入要删除的用户名: " username
  echo "You input is $username"
  Get_User_Id $username
  user_id=$?
  result=`curl -s --request DELETE --header "PRIVATE-TOKEN: $ADMIN_TOKEN" "${GITLAB_URL}/api/v4/users/${user_id}"`
  echo $result | grep "404 User Not Found" > /dev/null
  if [[ $? -ne 0 ]];then
   echo "用户删除成功"
  else
   echo "用户不存在，请确认"
   exit 1
  fi 
}





#Create_Project
#Delete_Project
#Create_Branch
#Delete_Branch
#Get_Pro_Num apitest
#Create_Group
#Get_Group_Id bb
#Delete_Group
#Add_User
#Get_User_Id lilei
#Delete_User



Menu(){
cat << EOF
----------------------------------------
|************Menu Home Page ************|
----------------------------------------
`echo -e "\033[36m 请根据需要选择\033[0m"`
`echo -e "\033[35m 1)创建项目\033[0m"`
`echo -e "\033[35m 2)删除项目\033[0m"`
`echo -e "\033[33m 3)创建分支\033[0m"`
`echo -e "\033[33m 4)删除分支\033[0m"`
`echo -e "\033[32m 5)创建分组\033[0m"`
`echo -e "\033[32m 6)删除分组\033[0m"`
`echo -e "\033[34m 7)创建用户\033[0m"`
`echo -e "\033[34m 8)删除用户\033[0m"`
`echo -e "\033[37m 9)退出\033[0m"`
EOF

read -p "Input you num: " num

case $num in
 1)
  echo "你的选择是: 创建项目"
  Create_Project
  ;;
 2)
  echo "你的选择是: 创建项目"
  Delete_Project
  ;;
 3) 
  echo "你的选择是: 创建分支"
  Create_Branch
  ;;
 4)
  echo "你的选择是: 删除分支"
  Delete_Branch
  ;;
 5)
  echo "你的选择是: 创建分组"
  Create_Group
  ;;
 6) 
  echo "你的选择是: 删除分组"
  Delete_Group
  ;;
 7)
  echo "你的选择是: 创建用户"
  Add_User
  ;;
 8)
  echo "你的选择是: 删除用户"
  Delete_User
  ;;
 9)
  echo "你的选择是: 退出"
  exit 2
  ;;
 *) 
  echo "输入错误，请重新输入"
  ;;
esac
}


while true
 do
  Menu
 done
