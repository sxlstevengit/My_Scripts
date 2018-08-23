#!/usr/bin/env python
import os,sys,json,commands



def getportlist(servername=None):
    portlist=commands.getoutput("/usr/bin/sudo /usr/bin/netstat -nltp|grep 'tcp\>'|grep -v '-'|sed 's/:/ /g'|sed 's/\// /g'|awk '{print $5,$10}'")
    #print portlist
    data={}
    ps=[]
    portlists=portlist.split('\n')
    for ports in portlists:
            port={}
            port['{#TCP_PORT}']=ports.split()[0]
            ps.append(port)
    
    data['data']=ps
    jsondata=json.dumps(data,sort_keys=True,indent=4)
    return jsondata
    print jsondata

        
if __name__ == "__main__":
    print getportlist()
