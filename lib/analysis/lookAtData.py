import csvIO as csvIO
import datetime
import numpy as np
import datetime


header, headerDict, x=csvIO.loadCSVDataToArrayWithHeaderDictionary('../../adaptiveStrategyData.csv')
for line in x:
    print line
    
print header