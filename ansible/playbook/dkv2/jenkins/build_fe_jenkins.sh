#!/bin/bash
# 提交fe构建参数,自动构建fe.


JENKINS_SER="http://jenkins.abc.so:8080"
USER="qiaofeng"
PASSWD="abc-123"
PRO_NAME=$1
BRANCH_NAME=$2
GIT_NAME=$3
MODULE_NAME=$4

#定义帮助函数
Usage(){
  echo "参数错误，请重新执行.参数之间以空格分隔。参数1: Project_name; 参数2: Branch_name; 参数3: Git_name; 参数4: Module_name"
  echo "请这样执行： bash deploy 参数1 参数2 参数3 参数4"
  echo "注意: 参数4有些特殊，如果要提交多个模块，参数4请以双引号引起来"
  exit 1
}

#判断参数个数
if [[ $# -lt 3 ]];then
 Usage
fi

# 提交信息到jenkins
#ARGS='{"branch_name":"$2","git_name":"$3","module_name":"$4"}'

# 经过测试，只有下面两种方式可提交数据。 通过json的方式不行。
#curl -X POST "http://jenkins.abc.so:8080/job/test_node10_dikong/buildWithParameters?branch_name=master&git_name=park_cms" --user qiaofeng:abc-123
#curl -X POST -d "branch_name=branch_name&git_name=park_cms" "http://jenkins.abc.so:8080/job/test_node10_dikong/buildWithParameters" --user qiaofeng:abc-123

if [[ $# -eq 3 ]];then
  curl -X POST -d "branch_name=${BRANCH_NAME}&git_name=${GIT_NAME}" "${JENKINS_SER}/job/${PRO_NAME}/buildWithParameters" --user ${USER}:${PASSWD}
elif [[ $# -eq 4 ]];then
  curl -X POST -d "branch_name=${BRANCH_NAME}&git_name=${GIT_NAME}&module_name=${MODULE_NAME}" "${JENKINS_SER}/job/${PRO_NAME}/buildWithParameters" --user ${USER}:${PASSWD}
else
  Usage
fi

echo ""
echo "已提交到jenkins,请稍等"
sleep 10

Wait_Build_Result(){
 total_time=10
 while true
  do
   build_num=`curl --silent ${JENKINS_SER}/job/${PRO_NAME}/lastBuild/buildNumber --user qiaofeng:abc-123
   stable_num=`curl --silent ${JENKINS_SER}/job/${PRO_NAME}/lastStableBuild/buildNumber --user qiaofeng:abc-123

   #echo $build_num
   #echo $stable_num
   if [[ $build_num -ne $stable_num ]];then
     echo "正在构建，等待了${total_time}秒..."
     sleep 3
     let total_time+=3
   else
     echo "fe构建完成"
     break
   fi
  done 
}

Wait_Build_Result
