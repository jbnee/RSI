Pro Merra_Velocity
;unfinished
close,/all
path0='E:\radiosonde\Taal\'

fx='98433_FEB08z12_2020.txt'
 ; fx='98433_May1z12_2021.txt'
 F1=path0+fx; input single CWB data file as T2003may.txt

;F1='E:\Radiosonde\2017-2019DongGang\2019\07\20190701_0000.46750.edt';enr,1,F1;0
;F1='E:\radiosonde\Taals\98433_FEB8Z12_2020.txt'
date=strmid(F1,26,7)
;read,f1,prompt='filename of CWB:such as T2003may '

;fileN=f1 +'.txt'

;OPENR, 1,path1 +filen

; Define a string variable:

;fname='F:\rsi\test\Radioson2000_120612.txt'
;read,data1,prompt=' where is data? AS d:\rsi\test\Lidar_T2001ja16.txt'
;fname=path1+fileN
OPENR,1,F1;  fname
;stop
line=''
cols=11
rows=1000 ;
for L=0,4 do begin
readf,1,line
print,line
endfor
STOP
IF N_ELEMENTS(cols) LE 0 THEN cols=1 ;Default value for cols
IF N_ELEMENTS(rows) LE 0 THEN rows=1000    ;Default value for rows
H=FLTARR(cols,rows) ;A big array to hold the data
S=FLTARR(cols)      ;A small array to read a line
A=FLTARR(cols,rows)
ON_IOERROR,ers     ;Jump to statement ers when I/O error is detected
n=0 ; Create a counter

WHILE n LT rows DO BEGIN
    READF,1,S    ;Read a line of data
    H[*,n]=S     ;Store it in H

    n=n+1        ;Increment the counter
ENDWHILE          ;End of while loop
ers: CLOSE,1         ;Jump to this statement when an end of file is detected
H=H[*,0:n-1]
;mnths=strcompress(H[0,*])
;mn=strmid(mnths,5,2)
;stop
A=size(H)
A1=A[1]  ;column #
A2=A[2]   ;row #
ndata=A2-1
 For j=0,A1-1  do begin
   For i=0,ndata do begin
   ; A[j,i]=H[j,i]
     if (H[j,i] eq 999.9) then H[j,i]=H[j,i-1]
     if (H[j,i] EQ 999) then H[j,i]=H[j,i-1]
   endfor   ;i
   endfor   ;j
;   take only <10 km
Sz=size(H)
L=Sz[2]-1
L=59;  pick 60 data
Ht=H[1,0:L]
P=H[0,0:L]
Temp=H[2,0:L]
RH=H[4,0:L]
WS=H[7,0:L]*0.514;   knots to m/s
WD=H[8,0:L]
km=Ht/1000

!P.MULTI = [0,2,1]
 plot_position1= [0.1,0.15,0.45,0.45];
  plot_position2= [0.1,0.6,0.45,0.95]
 ; plot_position3 = [0.6,0.15,0.95,0.45];
 ; plot_position4=[0.6,0.6,0.95,0.95]

!p.background=255
WINDOW,0
plot,Temp,km,background=-2,color=1,yrange=[0,10],xtitle='Temperature',ytitle='km',charsize=1.5;,position=plotposition1
;plot,WD,km,background=-2,color=1,yrange=[0,10],xtitle='WIND DIRECTION',ytitle='km',charsize=1.5;,position=plotposition3
plot,P,km,color=2,xtitle='pressure',ytitle='km',psym=4,charsize=1.5
oplot,p,KM,color=50
;plot,ws,km,background=-2,color=1,yrange=[0,10],xtitle='WIND SPEED',ytitle='km',charsize=1.5;,position=plotposition2
;plot,wD,km,background=-2,color=1,yrange=[0,10],xtitle='WIND DIRECTION',ytitle='km',charsize=1.5;,position=plotposition4
;
fout=strmid(F1,40,9)
;read,outfile,prompt='name of the outfile as Taals: '
;fout1=path1+'DG-'+fout+'.bmp'
;write_bmp,fout1,tvrd()
;printf,2,meanH
stop
ht_p=poly_fit(km,p,2)

;;;;************Merra vertical Velocity*************

Vpfile='V_p.txt'
F4=path0+VPfile
openr,2,F4
Bx=read_ascii(F4)
B=Bx.(0)
P2=B[1,*]
VP=B[1,*] ;in Pa/s
window,1
;!p.multi=[0,3,1]
VP2=interpol(VP,P2,P);,

plot,VP,P2,psym=4,color=2,background=-2,xtitle='Merra Vp pa/s',ytitle='Merra Pressure',charsize=1.5
oplot,VP,P,color=80; xtitle='pressure velocity Pa/s ',ytitle='pressure hPa'
stop
;;;;next calculate dH/dP then V=(dH/dP)*(dP/dt)

dHdP=deriv(P,Ht)
VV=abs(dHdP)*VP2*100; vertical velocity

plot,Vv,Ht/1000,color=2,background=-2,xtitle='Merra V m/s',ytitle='Ht',charsize=1.5


close,/all

stop

end
