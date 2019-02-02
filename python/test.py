class PClass(object):
    PT = "Hello PClass"
    def __init__(self,name="abc"):
        self.na = name
    def printData(self):
        print ( self.na )

class CClass(PClass):
    def showInfo(self):
        print("hello CClasss")

t1=CClass()
t1.showInfo()
t1.printData()
print (t1.PT)
print (t1.na)
