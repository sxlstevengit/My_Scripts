#!/bin/bash

#说明:脚本中，全局变量采用全部大写；函数采用首字母大写，骆驼写法；函数中的变量采用小写。
URL1=http://bj.XXXXXX.com.cn/html/member/1/index
URL2=http://uc.int.bj.XXXXXX.com.cn/v1/user/info
URL3=http://api.bj.XXXXXX.com.cn/wcc-roa/coupon/listForCouponWechat.html
JSON="Content-type:application/json"
ARG1='{"mapping_id":"1","phone":"15900467083","platform":2}'
ARG2='{"currentPage":1,"orderBy":0,"pageSize":20}'


#定义函数

Check_Url_Code(){
  a=$1
  if [[ $a == "$URL1" ]];then
     code_status=`curl -I -s $a | awk 'NR==1{print $2}'`
  elif [[ $a == "$URL2" ]];then
     #code_status=`curl -i -s -X POST $a -d@./json/1.json -H "$JSON" | awk 'NR==1{print $2}'`
     code_status=`curl -i -s -X POST $a -d $ARG1 -H "$JSON" | awk 'NR==1{print $2}'`
  else
     #code_status=`curl -i -s -X POST $a -d@./json/2.json -H "$JSON" | awk 'NR==1{print $2}'`
     code_status=`curl -i -s -X POST $a -d $ARG2 -H "$JSON" | awk 'NR==1{print $2}'`
  fi
  if [[ $code_status -eq 200 ]] ;then
   # echo "Web is ok"
    echo 200
    return 0
  else 
   #echo "Web is wrong"
    echo 1
    return 1     
  fi
}



Check_Result(){
  a=$1
  case $a in 
   "wcc_member_api")
      Check_Url_Code $URL2
      ;;
   "wcc_cardlist_api")
      Check_Url_Code $URL3
      ;;
   "wcc_member_center")
      Check_Url_Code $URL1
      ;;
   *)
      echo "Something is wrong"  
  esac
}



Check_Result $1

