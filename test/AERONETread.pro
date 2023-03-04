pro AERONETread
; Open the file test.lis:
close,/all
OPENR, 1, 'D:\Aerosol_cloud_radiation\Aeronet\AOT2NCU09.txt'
; Define a string variable:

RData=fltarr(5,1467)
A500=fltarr(1470)
Jdate=fltarr(1470)
day=intarr(1470)
D=fltarr(1470)
sum=fltarr(365)
count=fltarr(365)
line = ''
readf,1,line
; Loop until EOF is found:
;i=0
;WHILE ~ EOF(1) DO BEGIN

   READF, 1, Rdata
   ; Print the line:
   Jdate[0]=0
   day[0]=0
   D[0]=0
   sum[*]=0
   count[*]=0
  ; For j=0,4  do begin

   For i=1,1466 do begin
    Jdate[i]=Rdata[0,i]
    D[i]=round(Jdate[i])
    day[D]=D
    A500[i]=Rdata[4,i]
     if (d[i] eq d[i-1]) then sum[d[i]]=A500[i]+sum[d[i]]
    count(d[i])=count(d[i])+1

    print, D[i], count[i],sum[i]/count[i]
   endfor   ;i
  ; endfor   ;j

  stop


end