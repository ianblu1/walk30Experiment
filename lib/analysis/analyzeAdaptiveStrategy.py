import csvIO as csvIO
import datetime
import numpy as np
import datetime
import pylab as pl


#Python dictionaries do not naturally accept arrays of dynamic length as values,
#so we extend the class to do so. 
class listDictionary(dict):
    def valueAddition(self, key, value):
        #If key is present, append value.
        if key in self:
            self[key].append(value)
        #If key is not present, input value as only element of a list.    
        else:
            self[key]=[value]
        return

if __name__=="__main__":
    header, headerDict, x=csvIO.loadCSVDataToArrayWithHeaderDictionary('../../adaptiveStrategyData.csv')
    results=listDictionary()
    for line in x:
        print line
        nHeader=0
        
        #if line[0]=='1':
        #    continue
            
        for element in line:
            if element=='1':
                results.valueAddition(header[nHeader], 1.0)
            else:
                results.valueAddition(header[nHeader], 0.0)
                
            nHeader+=1
        
    print header
    
    percPositive=[]
    day=[]
    n=1
    for value in header:
        print value
        vals=np.array(results[value])
        meanVals=np.mean(vals)
        percPositive.append(meanVals)
        day.append(n)
        n+=1
        
    
    print percPositive
    
    pl.figure()
    pl.plot(day, percPositive)
    pl.xlabel("day in tenure")
    pl.ylabel("% positive response")
    pl.ylim(0,0.5)
    pl.xlim(0,8)
    pl.savefig('responseRate.png')
    pl.show()
    
    
    
    
        
    