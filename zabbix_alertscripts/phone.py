#!/usr/bin/env python
#_*_ coding:utf-8 _*_
import sys
reload(sys)
sys.setdefaultencoding( "utf-8" )
import os
import json
from urllib import urlopen
trigger=sys.argv[2]
doc = urlopen("http://XXXXXXXXXXXXXXXXX/activity/api/sendMobileMsg/code/XXXXXXXXXXXXXXXXXXXXXXXX?mobile="+sys.argv[1]+"&code=trigger|down|message|"+sys.argv[3]).read()
#doc = json.loads(doc)
print doc
#print doc.keys()
#print doc["msg"]
#print doc['data']
#print doc['ret']
