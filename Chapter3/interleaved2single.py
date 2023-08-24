#python 2.7
#script for the first interview question

import sys, getopt

def main(argv):
  inputFile = ''
  firstFasta = ''
  secondFasta = ''
   
  opts, args = getopt.getopt(argv,"hi:1:2:",["ifile=","1file=","2file="])
  for opt, arg in opts:
    if opt == '-h':
      print ('test.py -i <interleaved.fq> -1 <read1.fq> -2 <read2.fq>')
      sys.exit()
    elif opt in ("-i", "--ifile"):
      inputFile = arg
    elif opt in ("-1", "--1file"):
      firstFasta = arg
    elif opt in ("-2", "--2file"):
      secondFasta = arg
      
  inf = open(inputFile)
  f1 = open(firstFasta, 'w')
  f2 = open(secondFasta, 'w')
  

  
  for line in inf:
    if line[0] == '@':
      num = line.split('/')

       
    

    if num[1].strip() is '1':
      f1.write(line)
    elif num[1].strip() == "2":
      f2.write(line)
      
  inf.close()
  f1.close()
  f2.close()
  
if __name__ == "__main__":
   main(sys.argv[1:])