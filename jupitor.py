#!/usr/bin/env python
import os,sys,json,requests

if __name__ == "__main__":
    monsite="http://10.20.0.55:28083/zabbix"
    r=requests.get(monsite)
    #data={}
    if len(sys.argv)==2 and r.status_code==200:
        print(r.json().get(sys.argv[1],0))
    else:
        print(0)

