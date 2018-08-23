#!/bin/bash



#定义变量

Data_Url='http://10.20.0.55:28081/zabbix'


#  Get_Data=`curl -s ${Data_Url}`
#  T_Data=(`echo ${Get_Data}|sed -e 's/{//g' -e 's/}//g'`) 
#  echo ${T_Data[46]}
#  echo ${#T_Data[*]}

A=$1

Fun_Mon_Name(){
  Get_Data=`curl -s ${Data_Url}`
  T_Data=(`echo ${Get_Data}|sed -e 's/{//g' -e 's/}//g'`)
  i=$1
  case $i in 
    'schedule_load_fail')
        Result=`echo ${T_Data[37]}|awk -F[:,] '{print $2}'`
        Result=$(($Result+0))
     ;;
     'creative_load_fail')
        Result=`echo ${T_Data[19]}|awk -F[:,] '{print $2}'`
        Result=$(($Result+0))
     ;;
     'material_load_fail')
        Result=`echo ${T_Data[21]}|awk -F[:,] '{print $2}'`
        Result=$(($Result+0))
     ;; 
     'adloc_load_fail')
        Result=`echo ${T_Data[13]}|awk -F[:,] '{print $2}'`
        Result=$(($Result+0))
     ;; 
     'task_load_fail')
        Result=`echo ${T_Data[44]}|awk -F[:,] '{print $2}'`
        Result=$(($Result+0))
     ;; 
     'advertiser_load_fail')
        Result=`echo ${T_Data[15]}|awk -F[:,] '{print $2}'`
        Result=$(($Result+0))
     ;; 
     'ad_content_invalid')
        Result1=`echo ${T_Data[11]}|awk -F[:,] '{print $2}'`
        Result2=`echo ${T_Data[3]}|awk -F[:,] '{print $2}'`
        if [[ $Result2 -gt 0 ]];then
          Result=`echo "scale=2;$Result1/$Result2"|bc`
        else
          Result=0
        fi
     ;; 
     'ranker_get_charge_failed')
        Result=`echo ${T_Data[25]}|awk -F[:,] '{print $2}'`
        Result=$(($Result+0))
     ;; 
     'ad_content_count')
        Result=`echo ${T_Data[3]}|awk -F[:,] '{print $2}'`
        Result=$(($Result+0))
     ;; 
     'adloc_invalid')
        Result1=`echo ${T_Data[11]}|awk -F[:,] '{print $2}'`
        Result2=`echo ${T_Data[3]}|awk -F[:,] '{print $2}'`
        if [[ $Result2 -gt 0 ]];then
          Result=`echo "scale=2;$Result1/$Result2"|bc`
        else
          Result=0
        fi
     ;; 
     'screen_invalid')
        Result1=`echo ${T_Data[38]}|awk -F[:,] '{print $2}'`
        Result2=`echo ${T_Data[3]}|awk -F[:,] '{print $2}'`
        if [[ $Result2 -gt 0 ]];then
          Result=`echo "scale=2;$Result1/$Result2"|bc`
        else
          Result=0
        fi
     ;; 
     'adloc_empty_ad')
        Result1=`echo ${T_Data[10]}|awk -F[:,] '{print $2}'`
        Result2=`echo ${T_Data[3]}|awk -F[:,] '{print $2}'`
        if [[ $Result2 -gt 0 ]];then
          Result=`echo "scale=2;$Result1/$Result2"|bc`
        else
          Result=0
        fi
     ;; 
     'adloc_complement')
        Result1=`echo ${T_Data[8]}|awk -F[:,] '{print $2}'`
        Result2=`echo ${T_Data[3]}|awk -F[:,] '{print $2}'`
        if [[ $Result2 -gt 0 ]];then
          Result=`echo "scale=2;$Result1/$Result2"|bc`
        else
          Result=0
        fi
     ;; 
     'adloc_display_group_error')
        Result1=`echo ${T_Data[9]}|awk -F[:,] '{print $2}'`
        Result2=`echo ${T_Data[3]}|awk -F[:,] '{print $2}'`
        if [[ $Result2 -gt 0 ]];then
          Result=`echo "scale=2;$Result1/$Result2"|bc`
        else
          Result=0
        fi
     ;; 
     'redis_failure')
        Result=`echo ${T_Data[32]}|awk -F[:,] '{print $2}'`
        Result=$(($Result+0))
     ;; 
     'redis_latency')
        Result=`echo ${T_Data[33]}|awk -F[:,] '{print $2}'`
        Result=$(($Result+0))
     ;; 
     'ad_content_invalid_division_count')
        Result1=`echo ${T_Data[5]}|awk -F[:,] '{print $2}'`
        Result2=`echo ${T_Data[3]}|awk -F[:,] '{print $2}'`
        if [[ $Result2 -gt 0 ]];then
          Result=`echo "scale=2;$Result1/$Result2"|bc`
        else
          Result=0
        fi
     ;; 
     'adloc_invalid_division_count')
        Result1=`echo ${T_Data[11]}|awk -F[:,] '{print $2}'`
        Result2=`echo ${T_Data[3]}|awk -F[:,] '{print $2}'`
        if [[ $Result2 -gt 0 ]];then
          Result=`echo "scale=2;$Result1/$Result2"|bc`
        else
          Result=0
        fi
     ;; 
     'screen_invalid_division_count')
        Result1=`echo ${T_Data[38]}|awk -F[:,] '{print $2}'`
        Result2=`echo ${T_Data[3]}|awk -F[:,] '{print $2}'`
        if [[ $Result2 -gt 0 ]];then
          Result=`echo "scale=2;$Result1/$Result2"|bc`
        else
          Result=0
        fi
     ;; 
     'adloc_empty_ad_division_count')
        Result1=`echo ${T_Data[10]}|awk -F[:,] '{print $2}'`
        Result2=`echo ${T_Data[3]}|awk -F[:,] '{print $2}'`
        if [[ $Result2 -gt 0 ]];then
          Result=`echo "scale=2;$Result1/$Result2"|bc`
        else
          Result=0
        fi
     ;; 
     'adloc_complement_division_count')
        Result1=`echo ${T_Data[8]}|awk -F[:,] '{print $2}'`
        Result2=`echo ${T_Data[3]}|awk -F[:,] '{print $2}'`
        if [[ $Result2 -gt 0 ]];then
          Result=`echo "scale=2;$Result1/$Result2"|bc`
        else
          Result=0
        fi
     ;; 
     'adloc_displaygroup_error_division_count')
        Result1=`echo ${T_Data[9]}|awk -F[:,] '{print $2}'`
        Result2=`echo ${T_Data[3]}|awk -F[:,] '{print $2}'`
        if [[ $Result2 -gt 0 ]];then
          Result=`echo "scale=2;$Result1/$Result2"|bc`
        else
          Result=0
        fi
     ;; 
     'redis_error')
        Result1=`echo ${T_Data[33]}|awk -F[:,] '{print $2}'`
        Result2=`echo ${T_Data[32]}|awk -F[:,] '{print $2}'`
        if [[ $Result2 -gt 0 ]];then
          Result=`echo "scale=2;$Result1/$Result2"|bc`
        else
          Result=0
        fi
     ;; 
       
      '*')
        echo "Argument error" 
  esac
  echo $Result
  #return $Result

}

if [[ $# -ne 1 ]];then
  echo "Error,You must input one argument"
  exit 128     
fi
Fun_Mon_Name $A




