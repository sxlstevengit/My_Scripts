#!/bin/bash

func(){
  echo " 'basename $0' -[h t c p f m b g] args." >&2
  exit 0
}



declare -A deploy_args
declare -a targets

targets=(ryv4 ryv8 wccv4 wcc8)


echo $1
while getopts "ht:c:p:f:m:b:g:" options

do 
    case $options in
     t)  echo "You enter -t as an option. ${OPTARG}--${OPTIND}"; deploy_args["target"]=${OPTARG};;
     c)  echo "You enter -c as an option. ${OPTARG}--${OPTIND}"; deploy_args["class"]=${OPTARG};;
     p)  echo "You enter -p as an option. ${OPTARG}--${OPTIND}"; deploy_args["project"]=${OPTARG};;
     f)  echo "You enter -f as an option. ${OPTARG}--${OPTIND}"; deploy_args["filename"]=${OPTARG};;
     m)  echo "You enter -m as an option. ${OPTARG}--${OPTIND}"; deploy_args["md5"]=${OPTARG};;
     h)  echo "${OPTARG}--${OPTIND}" ; func;;
     ?)  func ;;
     :) echo "No argument value for option $OPTARG";;
    esac
done

#echo ${deploy_args["target"]}
#echo ${#deploy_args[@]}

if [[ "${targets[@]}"=~"${deploy_args['target']}" ]];then
  echo "in"
else
  echo "out"
fi
