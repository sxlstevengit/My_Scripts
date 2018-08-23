#!/bin/bash

#说明
#脚本中，全局变量采用全部大写；函数采用首字母大写，骆驼写法；函数中的变量采用小写。

#定义变量
URL1="http://api.rongyiguang.com/ry-activity/health"
URL2="http://api.rongyiguang.com/ry-activity-client/health"
URL3="http://api.rongyiguang.com/ry-activity-dayuecheng-jifenpaimai/health"
URL4="http://api.rongyiguang.com/ry-activity-helecheng-gongyi/health"


Check_Url_Code(){
  a=$1
  code_status=`curl -I -s $a | awk -F" " 'NR==1{print $2}'`
  if [[ $code_status -eq 200 ]];then
   # echo "Web is ok"
    return 0
  else 
   #echo "Web is wrong"
    return 1     
  fi
}

Check_Url_String(){
  a=$1
  string_status=`curl -s $a|sed '{s/{//g;s/"//g}' |awk -F[,:] '{print $2}'`
  if [[ $string_status == "UP" ]];then
    #echo "Service is ok"
    return 0
  else 
    #echo "Service is wrong"
    return 1
  fi
}

#Check_Url_Code $URL1
#Check_Url_String $URL1

Check_Code_String(){
  a=$1
  if Check_Url_Code $a && Check_Url_String $a ;then
    #echo "All is ok"
    echo "ok"
    return 0
  else
    #echo "All is wrong"
    echo "wrong"
    return 1
  fi
}


Check_Result(){
  a=$1
  case $a in 
   "ry-act")
      Check_Code_String $URL1
      ;;
   "ry-act-client")
      Check_Code_String $URL2
      ;;
   "ry-act-dych-jfpm")
      Check_Code_String $URL3
      ;;
   "ry-act-hlch-gy")
      Check_Code_String $URL4
      ;;
   *)
      echo "Something is wrong"  
  esac
}


#Check_Code_String $URL1

Check_Result $1
