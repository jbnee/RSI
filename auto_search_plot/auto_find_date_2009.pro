Pro auto_find_date_2009
;file data file name and data number such as 2009Ja  2222

year=''
read,year,prompt='year as 2021:  '
xpath='D:\Lidar_data\'+year+'\*' ; assign month
Dnm=''
Bnm=''
f1=file_search(xpath)
;nf1=size(f1)
IX=n_elements(f1);
print,'Total files: ',IX
;print,'Files: ', F1
stop

A=strarr(2,IX)
NQ=intarr(IX)

for k=0,IX-1 do begin
print,f1[k]
dnm=strmid(f1[k],19,12)
Bnm=f1[k]+'\*'
Q2=file_search(Bnm);
Nx=n_elements(Q2)
;A[k]=strmid(f1[k],19,4)
;print,dnm,Nx
A[0,k]=dnm
A[1,k]=Nx
endfor
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
Mn='au'
;read,MN,prompt='month to work as AP : ';=strmid(A,0,2);
file_path=xpath+Mn+'\*'
fls=file_search(file_path)
help,fls
n2=n_elements(fls)
xdate=strarr(n2)
xdate[0]='01'
sdate=strarr(31)
Jdate=fltarr(31)
sdate[0]='01'
j=1
ix=1
xdate[0]=strmid(fls(0),24,2);
Jdate[0]=0
for n=1,n2-1 do begin
xdate[n]=strmid(fls(n),24,2);
if (xdate[n] EQ xdate[n-1]) then begin
sdate[j]=xdate[n-1]

endif else begin
print,'n-sdate: ',n,'-  ' ,sdate[j]
sdate[j]=xdate[n]
Jdate[j]=n-Jdate[j-1]
j=j+1

print,sdate[j]

endelse
endfor

stop

print,'J, number of data of this month: ',J,Jdate
stop
end


