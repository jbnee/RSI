Pro auto_find_date_2021
;file data file name and data number such as 2009Ja  2222
path0='D:\lidar_data\'
year=''
read,year,prompt='year as 2021:  '
path1=path0+year;
xpath=path1'\*' ; assign month
Dnm=''
Bnm=''
f1=file_search(xpath)
;nf1=size(f1)
IX=n_elements(f1);
print,'Total files: ',IX
;print,'Files: ', F1
;stop

A=strarr(2,IX)
NQ=intarr(IX)

for k=0,IX-1 do begin
print,k,'   ',F1[k]
dnm=strmid(F1[k],19,12)
Bnm=f1[k]+'\*'
Q2=file_search(Bnm);
Nx=n_elements(Q2)
;A[k]=strmid(f1[k],19,4)
;print,dnm,Nx
A[0,k]=dnm
A[1,k]=Nx
endfor;k
stop
;read,Iend,prompt=' ith file to list: '
;AF=A[*,0:Iend-1]
;outpath='D:\lidar_data\Data_list\'
;outfile=outpath+'Files2009.txt'
;openw,1,outfile
;print,1,AF
;close,1

;STOP
;;************* set date***************
;Mn='au'
;read,MN,prompt='month to work as AP : ';=strmid(A,0,2);

;fnm='';
read,fnm,prompt='which F1 file to search: '
file_path=F1[fnm]+'\*'
fls=file_search(file_path)
help,fls
Nsum=n_elements(fls)
xdate=strarr(Nsum)

sdate=strarr(31)
Jdate=fltarr(31)  ; number of data for this date
Sum_Day=fltarr(31)
print,'fls[0]= ',fls[0]
stop

read,x0,prompt='position of date as 32: '
stop

sum_day[0]=0



sdate[0]=xdate[0]

xdate[0]=strmid(fls(0),x0,2);

j=1
ix=1

for n=1,Nsum-1 do begin
xdate[n]=strmid(fls(n),x0,2);
if (xdate[n] EQ xdate[n-1]) then begin
sdate[j]=xdate[n-1]

endif else begin
 sdate[j]=xdate[n]

 JN=n;;Jdate[j-1]
 sum_day[j]=total(Jdate)
 Jdate[J]=n-sum_day[j]

 print,'sdate:  ',sdate[j]
 print,j,', FLS, ',strmid(FLS[n],24,20),', num=  ',Jdate[j]

j=j+1
endelse

endfor; n
Jdate[j]=n-total(Jdate); last data
stop

print,'J, number of data of this month: ',J
print,Jdate[0:J]
print,sdate
stop


end


