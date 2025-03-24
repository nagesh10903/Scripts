import csv

file="/home/nagesh/Desktop/00001.vcf"
ofile="/home/nagesh/Desktop/contacts.csv"
i=0
fl=0
startflag=0
f=open(file,"r")
of=open(ofile,"a",newline='')
csvwriter = csv.writer(of)
    
name=""
fullname=""
tel=[]

csvwriter.writerow(["Sl.No","Full Name","Name","Numbers"])
for l in f:
    fl=fl+1
    if(l.startswith("BEGIN:VCARD")):
     startflag=1
     continue
    if(l.startswith("END:VCARD")):
     startflag=0
     if(len(tel)>0):
       i=i+1  
       csvwriter.writerow([i,fullname,name,tel])
       print(i,": ",fullname,",",name,",",tel)
       tel=[]
     continue
    if(startflag==1):
        if(l.startswith("N:")):
            name=l[2:].replace(";"," ").strip()
        if(l.startswith("FN:")):
            fullname=l[3:].strip()
        if(l.startswith("TEL;")):
            ph=l[14:].replace("TYPE=","").replace("PREF:","")
            tel.append(ph.strip())
            
    #print(fl,l)
    #if(fl>12):
      #break
f.close()
of.close()