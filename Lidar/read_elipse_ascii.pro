PRO READ_Elipse_ascii
close,/all
;filename='f:\rsi\testidl\35data.txt'
filename='F:\ozone&2017Eclipse\houston_sounding.txt'
line=''
openr,1,filename
readf,1,line
print,line
close,1

B=READ_ASCII(filename)
;PRINT,B
A=B.(0)
h=size(A)
col=h[1]
row=h[2]
ALT=fltarr(row)
O3=fltarr(row)
O3a=fltarr(row)
O3b=fltarr(row);dobson O3
T=fltarr(row)
stop

FOR i=2,row-1 do begin

Alt[i]=A[2,i]
if (Alt[i] gt 1000.) then Alt[i]=Alt[i-1]
O3[i]=A[5,i]
if (O3[i] gt 1000) then O3[i]=O3[i-1]

O3a[i]=A[6,i]
if (O3a[i] gt 1000) then O3a[i]=O3a[i-1]

O3b[i]=A[7,i]
if (O3b[i] gt 1000) then O3b[i]=O3b[i-1]
T[i]=A[4,i]
if (T[i] gt 1000) then T[i]=T[i-1]

endfor
plot,O3,alt,psym=3
oplot,O3a,alt,psym=2

oplot,O3b,alt,psym=5
stop
plot,T,alt,psym=3
stop
end