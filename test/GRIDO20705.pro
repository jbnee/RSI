Pro GRIDO20705
close,/all; ;;;;;;;;;;;;;;;;;;;;;
rgb = bytarr(3,256)
openr,2,'d:\rsi\hues.dat'
readf,2,rgb
close,2
r=bytarr(256)
g = r
b = r
r(0:255) = rgb(0,0:255)
g(0:255) = rgb(1,0:255)
b(0:255) = rgb(2,0:255)
tvlct,r,g,b

!P.BACKGROUND= 1 ; 0 = black, 1 = white
!P.COLOR=2 ;blue labels
; fileA = DIALOG_PICKFILE(/READ)
fileA='d:\rsi\data\GWLL007B.txt'
read,ndata,prompt='number of data: '
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;O2data=fltarr(3,8964); for B file
;O2data=fltarr(3,20930); for A file
Imgdata=fltarr(3,ndata); For C file
 ;fileA='e:\RSI\data\GWOH005.txt'
 openr,1,fileA
 readf,1,Imgdata


x = Imgdata[0,*]
y = Imgdata[1,*]
dataI2 =Imgdata[2,*]
dataI=smooth(dataI2,10)
cmin=min(dataI)
cmax=max(dataI)
GRID_INPUT, x, y, dataI, xSorted, ySorted, dataSorted
help,datasorted
grdata=fltarr(4,8964)
grdata[0,*]=Xsorted
grdata[1,*]=Ysorted
grdata[2,*]=dataI
grdata[3,*]=dataSorted
openw,2,'d:\rsi\data\gridO2.txt'
printf,2,grdata
close,/all
end