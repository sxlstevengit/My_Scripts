#!/bin/bash
# 此脚本用来上线发布
# 需要提供两个参数，参数以空格分隔。第一个参数表示平台环境,如test,stag,prod等，第二个参数表示上线类型，如fe,java等.
#set -ex

TARGET=$1
CLASS=$2

T_Array=(test stag prod)
C_Array=(etc fe java)



#定义帮助函数
Usage(){
  echo "参数错误，请重新执行. 两个参数以空格分隔。 参数1表示平台环境，如test,stag,prod; 参数2表示上线类型，如fe,java等."
  echo "请这样执行： bash deploy 参数1 参数2"
  exit 1 
}

# 判断参数个数
if [[ $# -ne 2 ]];then
  Usage
fi

# 判断平台环境是否包含在数组中.
[[ ${T_Array[@]/${TARGET}/} != ${T_Array[@]} ]] && [[ ${C_Array[@]/${CLASS}/} != ${C_Array[@]} ]] && echo "参数输入正确" || { 
  echo "参数不符号要求"  
  exit 2 
}

echo "开始部署，请稍等"

if [ "$TARGET" = "test" ]; then
 echo "你选择的部署平台是: $TARGET, 类型是: $CLASS"
 if [ "$CLASS" = "etc" ]; then
   ansible-playbook -e "dkserver=dk-java-test" -e "INFO='现在开始部署etc'" var_test.yml
 elif [ "$CLASS" = "fe" ]; then  
   ansible-playbook -e "dkserver=dk-ng-test" var_test.yml
 elif [ "$CLASS" = "java" ]; then
   ansible-playbook -e "dkserver=dk-java-test" var_test.yml
 else
   echo "什么也不做"
 fi
elif [ "$TARGET" = "stag" ]; then
 echo "你选择的部署平台是: $TARGET, 类型是: $CLASS"
 if [ "$CLASS" = "etc" ]; then
   ansible-playbook -e "dkserver=dk-java-stag" -e "INFO='现在开始部署etc'" var_test.yml
 elif [ "$CLASS" = "fe" ]; then  
   ansible-playbook -e "dkserver=dk-ng-stag" var_test.yml
 elif [ "$CLASS" = "java" ]; then
   ansible-playbook -e "dkserver=dk-java-stag" var_test.yml
 else
   echo "什么也不做"
 fi
else
 echo "你选择的部署平台是: $TARGET, 类型是: $CLASS"
 if [ "$CLASS" = "etc" ]; then
   ansible-playbook -e "dkserver=dk-java-prod" -e "INFO='现在开始部署etc'" var_test.yml
 elif [ "$CLASS" = "fe" ]; then
   ansible-playbook -e "dkserver=dk-ng-prod" var_test.yml
 elif [ "$CLASS" = "java" ]; then
   ansible-playbook -e "dkserver=dk-java-prod" var_test.yml
 else
   echo "什么也不做"
 fi
fi
