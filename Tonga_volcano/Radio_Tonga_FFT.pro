pro Radio_Tonga_FFT
;note:Gravity wave of temperature anomaly below 10 km
close,/all
erase

;Path0='E:\Aerosol_dust\Taal_volcano\'
 path0='E:\Tonga volcano 2022\radioSound\'
 ;fx='91765 NSTU Pago Pago JAN15Z.txt'
 ;fx='47618 ROIG IshigakijimaJAN15_12Z.txt';
 fx='47678 Hachijyojima JAN15_12Z.txt';
;fx='91212 PGUM Guam JAN 14Z.txt '
 ; fx='98433_May1z12_2021.txt'
 F1=path0+fx; input single CWB data file as T2003may.txt


Station=strmid(F1,33,6)

;stop
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
dateline=''
readf,1,dateline
date='Jan15';strmid(dateline,41,6)
for L=0,3 do begin
readf,1,line
print,line
endfor
STOP
cols=11
rows=1000;
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
L1=Sz[2]-1
;L1=59;  pick 60 data
Ht=H[1,0:L1]
P=H[0,0:L1]
Temp=H[2,0:L1]
RH=H[4,0:L1]
WS=H[7,0:L1]*0.514;   knots to m/s
WD=H[8,0:L1]
km=Ht/1000

!P.MULTI = [0,2,1]
 plot_position1= [0.1,0.15,0.45,0.45];
  plot_position2= [0.1,0.6,0.45,0.95]

!p.background=255
WINDOW,0
plot,Temp,km,background=-2,color=1,yrange=[0,20],xtitle='Temperature',ytitle='km',charsize=1.5;,position=plotposition1
;plot,WD,km,background=-2,color=1,yrange=[0,10],xtitle='WIND DIRECTION',ytitle='km',charsize=1.5;,position=plotposition3
plot,P,km,color=2,background=-2,xtitle='Pressure hPa',yrange=[0,20]
 ;plot,WS, xtitle='WIND SPEED',ytitle='km',charsize=1.5;,position=plotposition2
;plot,WS,km,background=-2,color=1,yrange=[0,10],xtitle='WIND DIRECTION',ytitle='km',charsize=1.5;,position=plotposition4
;
fout=strmid(F1,40,9)
;read,outfile,prompt='name of the outfile as Taals: '
;fout1=path1+'DG-'+fout+'.bmp'
;write_bmp,fout1,tvrd()
;printf,2,meanH
h1=1.0
h2=15.0;fix(max(km)); 10.0

;read,h1,h2,prompt='height range h1 to h2 in km 1,10 :'
p1=where(km lt h1)
b1=max(p1)
p2=where(km gt h2)
b2=min(p2-1)
stop
Nx=b2-b1-1;;;50
dh=(h2-h1)/Nx
;
z=dh*findgen(Nx)+h1
x=km(b1:b2)
yT=temp(b1:b2)
yP=P(b1:b2)
;;;************** interpolation ****************************


!P.multi=[0,2,1]
Interp_T=interpol(yT,x,z)
plot,interp_T,z,color=2,background=-2,xtitle='temperature interpolated',ytitle='km'
oplot,interp_T,z,psym=4,color=2

stop

;T_fit=poly_fit(z, Interp_T,3, MEASURE_ERRORS=measure_errors, SIGMA=sigma)
;Fit_T=poly(z,T_fit);

;plot,Interp_T,Z,color=1,background=-2,xtitle='temperature',ytitle='km',charsize=1.3
;oplot,Fit_T,z,color=90;

;stop
;ANMT=Interp_T-Fit_T  ;temperature anomaly
;oplot,10*anmt,z,psym=2,color=120
;;;;;;;;;;oplot,temp[b1:b2],Z,color=80
;print,stddev(ANMT)
;print,mean(ANMT)

stop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 Interp_P=interpol(yP,x,z)
 P_fit=poly_fit(z, Interp_P,3, MEASURE_ERRORS=measure_errors, SIGMA=sigma)
 Fit_P=poly(z,P_fit);

plot,Interp_P,Z,color=1,xrange=[-10,1000],background=-2,xtitle='Pressure',ytitle='km',charsize=1.3
oplot,Fit_P,z,color=90;

stop
ANMP=Interp_P-Fit_P  ;temperature anomaly
oplot,10*anmP+100,z,psym=2,color=120
;;;;;;;;;;oplot,temp[b1:b2],Z,color=80
print,stddev(ANMP)
print,mean(ANMP)
;;***********************FFT********************


;stop
;nb=n_elements(Z)
;T_file=fltarr(5,nb)
;T_file[0,*]=Z
;T_file[1,*]=Interp_T
;T_file[2,*]=fit_T
;T_file[3,*]=anmt
; stop
;File2=''
;read,file2,prompt='file name as T0501_12.txt:  '
;F2=path0+file2
;openw,2,F2
;printf,2,T_file
;close,2
;;***************FFT, PSD ******************

Y1=fft(ANMP)
 NS=fix(n_elements(Y1)/2);
 ;Y1=Y1[1:NS-1];  remove the first term
 xpower=2*abs(Y1)^2;
 power=xpower[1:NS-1]; REMOVE DC COMPONENT
 plot,power


 stop
 ;
 nyquist=0.5
 ;read,mtime,prompt='Times in minutes of data : '
 ;DT=mtime/N0
 ;;;Timeperdata=DT/N0
 freq=nyquist*(findgen(ns)/ns)
 plot,freq,power,xtitle='frequency',ytitle='power'
 ;plot,freq,power[2:148],xrange=[0,0.1]
 stop
 xfreq=freq[1:(Ns-1)]
 T=1/xfreq; period
 ;power=powerx[1:fix((ns-1)/2)]
 plot,xpower,xrange=[0,ns-1];
 ;print,strmid(fls[nf1],20,30)
 ;print,strmid(fls[nf2-1],20,30)

 read,RAN,prompt='RANGE span as=15 KM OR ; '
 MT=Ran/(b2-b1+1)
 print,MT
 np=n_elements(xpower)
 peri=MT*T;   /freq
  !p.multi=[0,1,1]
 plot,peri,xpower,color=2,background=-2,title=Station+' FFT power',$
 xtitle='time min',ytitle='Power',charsize=1.3

 px=max(power);
 pdev=stddev(power)
 pmn=mean(power)

 power_data=[px,pdev,pmn]
; ERR=stddev(power)/mean(power)
; print,'ERR=  ',ERR
stop


fignm=path0+'FFT_output\'+station+date+'.bmp'
write_bmp,fignm,tvrd()
F3=path0+'FFT_output\'+station+date+'.txt'

T_FFT=fltarr(2,ns-1)
T_FFT[0,*]=peri
T_FFT[1,*]=power
openw,2,F3
printf,2,T_FFT
close,2

stop

stop
;
end
