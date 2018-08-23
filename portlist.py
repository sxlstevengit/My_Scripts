#!/usr/bin/env python
import os,sys,json,commands

def getserverlist(servername=None):
    if servername:
        portlist=commands.getoutput(("/usr/bin/sudo /usr/bin/netstat -nltp|grep 'tcp\>'|grep -v '-'|sed 's/:/ /g'|sed 's/\// /g'|awk '{print $5,$10}'|grep %s") % servername)
    else:
        portlist=commands.getoutput("/usr/bin/sudo /usr/bin/netstat -nltp|grep 'tcp\>'|grep -v '-'|sed 's/:/ /g'|sed 's/\// /g'|awk '{print $5,$10}'")
    #cronpath="/var/spool/cron/"
    #print portlist
    data={}
    ps=[]
    portlists=portlist.split('\n')
    for ports in portlists:
            port={}
            port['{#MYSERVER_LIST}']=ports.split()[1]
            ps.append(port)
    
    data['data']=ps
    jsondata=json.dumps(data,sort_keys=True,indent=4)
    return jsondata
    #print jsondata




def getportlist(servername=None):
    if servername:
        portlist=commands.getoutput(("/usr/bin/sudo /usr/bin/netstat -nltp|grep 'tcp\>'|grep -v '-'|sed 's/:/ /g'|sed 's/\// /g'|awk '{print $5,$10}'|grep %s") % servername)
        #print portlist
        return portlist.split('\n')[0].split()[0]
    else:
        return None
    #cronpath="/var/spool/cron/"
    #print portlist
    #data={}
    #ps=[]
    #portlists=portlist.split('\n')
    #for ports in portlists:
    #        port={}
    #        port['{#PORT_LIST}']=ports.split()[0]
    #        ps.append(port)
    
    #data['data']=ps
    #jsondata=json.dumps(data,sort_keys=True,indent=4)
    #return jsondata
    #print jsondata

        
if __name__ == "__main__":
    if len(sys.argv)<2:
        print getserverlist()
    else:
        print getportlist(sys.argv[1])
