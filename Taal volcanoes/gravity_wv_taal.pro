pro Gravity_wv_Taal
;note:Gravity wave of temperature anomaly below 10 km
close,/all
; used to generate T_anm data for wavelet analysis
erase
 path0='D:\radiosonde\Taal\'
 fx='98433_Feb08_z12.txt'
 ; fx='98433_May1z12_2021.txt'
 F1=path0+fx; input single CWB data file as T2003may.txt

;
date=strmid(F1,26,7)
;read,f1,prompt='filename of CWB:such as T2003may '

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
    print,n,S
    n=n+1        ;Increment the counter
ENDWHILE          ;End of while loop
ers: CLOSE,1         ;Jump to this statement when an end of file is detected
H=H[*,0:n-1]
;mnths=strcompress(H[0,*])
;mn=strmid(mnths,5,2)
stop
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
;L=59;  pick 60 data
Ht=H[1,0:L]
P=H[0,0:L]
Temp=H[2,0:L]
RH=H[4,0:L]
WS=H[7,0:L]*0.514;   knots to m/s
WD=H[8,0:L]
km=Ht/1000

!P.MULTI = [0,4,1]
 plot_position1= [0.1,0.15,0.45,0.45];
  plot_position2= [0.1,0.6,0.45,0.95]
 ; plot_position3 = [0.6,0.15,0.95,0.45];
 ; plot_position4=[0.6,0.6,0.95,0.95]

!p.background=255
WINDOW,0
plot,Temp,km,background=-2,color=1,xrange=[-30,20],yrange=[0,10],xtitle='Temperature',ytitle='km',charsize=1.5;,position=plotposition1
plot,RH,km,color=2,xtitle='RH ',ytitle='km',charsize=1.5, title='RH'
plot,WD,km,background=-2,color=1,yrange=[0,10],xtitle='WIND DIRECTION',ytitle='km',charsize=1.5;,position=plotposition3

plot,ws,km,background=-2,color=1,yrange=[0,10],xtitle='WIND SPEED',ytitle='km',charsize=1.5;,position=plotposition2

;plot,wD,km,background=-2,color=1,yrange=[0,10],xtitle='WIND DIRECTION',ytitle='km',charsize=1.5;,position=plotposition4
;
fout=strmid(F1,40,9)
;read,outfile,prompt='name of the outfile as Taals: '
;fout1=path1+'DG-'+fout+'.bmp'
;write_bmp,fout1,tvrd()
;printf,2,meanH
;read,h1,h2,prompt='height range h1 to h2 in km 1,10 :'

h1=0.0
h2=10.0
p1=where(km lt h1)
b1=max(p1)
p2=where(km gt h2)
b2=min(p2)-1
stop
T_fit=poly_fit(km[b1:b2], Temp[b1:b2],2, MEASURE_ERRORS=measure_errors, SIGMA=sigma)
Fit_T=poly(km[b1:b2],T_fit);
!P.multi=[0,1,1]
plot,temp,km,color=1,background=-2,xrange=[-20,20],yrange=[0,10],xtitle='temperature',ytitle='km',charsize=1.3
oplot,Fit_T,km[b1:b2],color=90;
X0=[0,0]
y0=[0,10]
plots,X0,Y0,color=2

stop

ANMT=Temp[b1:b2]-Fit_T  ;temperature anomaly
;
 oplot,anmt,km[b1:b2],psym=2,color=120
print,stddev(ANMT)
print,mean(ANMT)
Na=b2-b1+1
TANM=fltarr(2,Na)
Tanm[0,*]=km[b1:b2]
Tanm[1,*]=ANMT


stop
nb=b2-b1+1
T_file=fltarr(5,nb)
T_file[0,*]=km[b1:b2]
T_file[1,*]=temp[b1:b2]
T_file[2,*]=fit_T
 T_file[3,*]=anmt
 stop
;File2=''
;read,file2,prompt='file name as T0501_12.txt:  '
;F2=path0+file2
;openw,2,F2
;printf,2,T_file
stop
close,2
N=n_elements(ANMT)
;A=indgen(N);/2)
x=indgen(N);
T_FFT=fft(ANMT)
ns=n_elements(T_FFT)/2;
A=findgen(ns);
;freq=findgen(ns)
power_T=abs(T_FFT[1:ns-1])^2;
;power_T=power[1:ns-1];
nyquist=0.5
;nyquist=1.0
freq=nyquist*A[1:ns-1]/ns;;A[0:ns-1]/ns
DZ=(km[b2]-km[b1])/(b2-b1+1)
Peri=DZ/freq; [1:ns-1]
!P.multi=[0,2,1]
plot,Temp[b1:b2],km[b1:b2],background=-2,color=1,yrange=[h1,h2],xtitle='Temperature',ytitle='km',charsize=1.5;,position=plotposition1
oplot,fit_t,km[b1:b2],color=50
oplot,anmt,km[b1:b2],color=120
plot,peri,power_T,color=1,background=-2,xtitle='Period km',Ytitle='power',title='FFT temperature anomaly'

oplot,peri,power_T,color=2,psym=4
stop


fignm='E:\raidosonde\taals\'
file2=path0+date+'.bmp'
;write_bmp,fignm,tvrd()
File3='FFT_'+File2

F3=path0+file3
T_FFT=fltarr(2,ns-1)
T_FFT[0,*]=peri
T_FFT[1,*]=power_T
;openw,2,F3
;printf,2,T_FFT
close,2

stop
;;;;;;********** Merra V of pressure

;Radio=''
Vpfile='V_p.txt'
F4=path0+VPfile
openr,2,F4
Bx=read_ascii(F4)
B=Bx.(0)
P2=B[0,*]
VP=B[1,*] ;in Pa/s
window,1
;!p.multi=[0,3,1]
VP2=interpol(VP,P2,P);,

plot,VP,P2,psym=4,color=2,background=-2,xtitle='Merra Vp pa/s',ytitle='Merra Pressure'
oplot,VP,P,color=80; xtitle='pressure velocity Pa/s ',ytitle='pressure hPa'
stop
;;;;next calculate dH/dP then V=(dH/dP)*(dP/dt)

dHdP=deriv(P,Ht)
VV=dHdP*VP2*100; vertical velocity

plot,Vv,Ht/1000,color=2,background=-2,xtitle='Merra V m/s',ytitle='Ht'


pltname2 =path0+date+'FFT_wv_Taals.bmp'
;WRITE_bmp, pltname2, TVRD()

stop
;
end
