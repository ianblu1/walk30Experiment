import csv
#===============================================================================
# load data from a csv file
#===============================================================================
def loadData(csvFileName):
    
    # Open CSV file
    csvFile = open(csvFileName, 'rU')
    
    # Load input Array using a list comprehension
    inputArray=[row for row in csv.reader(csvFile)] 
    
    # Close csv file
    csvFile.close()
    return inputArray
#------------------------------------------------------------------------------
#===============================================================================
# Return outputArray with .csv fileName contents 
#===============================================================================
def LoadFromFile(fileName):
    #dirname= os.path.dirname(os.getcwd())
    #FileName=os.path.join(dirname,fileName)
    FileName=fileName
    ifile=open(FileName, 'rb')
    inputArray=[]
    for row in csv.reader(ifile):
        inputArray+=[row]
    ifile.close()
    
    return inputArray
#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
#===============================================================================
# Return outputArray with first n lines of .csv fileName contents
#===============================================================================
def LoadFromFileLimited(fileName,numLines):
    #dirname= os.path.dirname(os.getcwd())
    #FileName=os.path.join(dirname,fileName)
    FileName=fileName
    ifile=open(FileName, 'rb')
    inputArray=[]
    n=0
    for row in csv.reader(ifile):
        if n>numLines:
            break
        inputArray+=[row]
        n+=1
    ifile.close()
    
    return inputArray
#------------------------------------------------------------------------------

def loadCSVDataToArrayWithHeaderDictionary(csvFileName):
    
    # Load data from CSV File
    inputArray=LoadFromFile(csvFileName)
    
    # Load header (inputArray[0]) and dataArray without header (dataArray[1:])
    header=inputArray[0]
    dataArray=inputArray[1:]
    
    # Make dictionary mapping header names to column numbers
    headerNam2Num=dict(zip(header,range(len(header))))
    
    return header, headerNam2Num, dataArray

def loadCSVDataToArrayWithHeaderDictionaryLimited(csvFileName, n):
    
    # Load data from CSV File
    inputArray=LoadFromFileLimited(csvFileName,n)
    
    # Load header (inputArray[0]) and dataArray without header (dataArray[1:])
    header=inputArray[0]
    dataArray=inputArray[1:]
    
    # Make dictionary mapping header names to column numbers
    headerNam2Num=dict(zip(header,range(len(header))))
    
    return header, headerNam2Num, dataArray

def returnUnity():


    return 1.0
