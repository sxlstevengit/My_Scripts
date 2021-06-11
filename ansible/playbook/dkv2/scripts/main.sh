Main(){
 cat << EOF
----------------------------------------
|************功能选择菜单************|
----------------------------------------
`echo -e "\033[36m 功能选择\033[0m"`
`echo -e "\033[35m 1)发布上线\033[0m"`
`echo -e "\033[33m 2)gitlab_api相关\033[0m"`
`echo -e "\033[34m 3)项目gitlab初始化\033[0m"`
`echo -e "\033[37m 0)退出\033[0m"`
EOF

read -p "Input you num: " num

case $num in 
  1)  
   echo "你的选择是: 发布上线"
   read -p "请输入脚本所需要参数:" arg1 arg2 arg3 arg4 arg5
   bash deploy.sh -t $arg1 -c $arg2 -p $arg3 -b $arg4 -g $arg5
   ;;
  2)
   echo "你的选择是: gitlab_api相关"
   bash gitlab/gitlab_api.sh
   ;;
  3)
   echo "你的选择是: 项目gitlab初始化"
   bash gitlab/init_project.sh
   ;;
  0)
   echo "你的选择是：退出"
   ;;
  *)
   echo "你的选择不在范围内，请重新选择"
esac
}

Main

