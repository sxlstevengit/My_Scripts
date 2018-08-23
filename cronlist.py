#!/usr/bin/env python
import os,sys,json,hashlib

def getcronlist():
    cronpath="/var/spool/cron/"
    data={}
    cronfiles=[]
    for ff in os.listdir(cronpath):
        if os.path.isfile(cronpath+ff):
            cronfile={}
            cronfile['{#CRON_FILE}']=cronpath+ff
            cronfiles.append(cronfile)
    
    data['data']=cronfiles
    jsondata=json.dumps(data,sort_keys=True,indent=4)
    return jsondata
    #print jsondata

def md5file(filename=None):
    try:
        f=open(filename,'rb')
        return hashlib.md5(f.read()).hexdigest()
    except:
        return None
        
if __name__ == "__main__":
    if len(sys.argv)<2:
        print getcronlist()
    else:
        print md5file(sys.argv[1])
