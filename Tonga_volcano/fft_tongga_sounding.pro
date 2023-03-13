pro FFT_TongGa_sounding
;note:Gravity wave of temperature anomaly below 10 km
close,/all
erase

;Path0='E:\Aerosol_dust\Taal_volcano\'
 path0='E:\Tonga volcano 2022\radioSound\'
 fx='91765 NSTU Pago Pago Jan10_20.txt'
 ; fx='98433_May1z12_2021.txt'
 F1=path0+fx; input single CWB data file as T2003may.txt


date=strmid(F1,25,7)

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
Interp_T=interpol(yT,x,z)

!P.multi=[0,2,1]

plot,interp_T,z,color=2,background=-2,xtitle='temperature interpolated',ytitle='km'
oplot,interp_T,z,psym=4,color=2

stop

T_fit=poly_fit(z, Interp_T,3, MEASURE_ERRORS=measure_errors, SIGMA=sigma)
Fit_T=poly(z,T_fit);

plot,Interp_T,Z,color=1,background=-2,xtitle='temperature',ytitle='km',charsize=1.3
oplot,Fit_T,z,color=90;

stop
ANMT=Interp_T-Fit_T  ;temperature anomaly
oplot,10*anmt,z,psym=2,color=120
;;;;;;;;;;oplot,temp[b1:b2],Z,color=80
print,stddev(ANMT)
print,mean(ANMT)

stop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Interp_P=interpol(yP,x,z)
;P_fit=poly_fit(z, Interp_P,3, MEASURE_ERRORS=measure_errors, SIGMA=sigma)
;Fit_P=poly(z,P_fit);

;plot,P,Z,color=2,background=-2
;oplot,Fit_P,z,psym=5,color=2
;stop
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

;N=n_elements(ANMT)
;A=indgen(N);/2)
;x=indgen(N);
nx=n_elements(Z)
T_FFT=fft(ANMT)
N1=n_elements(T_FFT);
;N1=floor(N0)
N2=floor(N1/2)
;A=indgen(ns);
nyquist=0.5
;freq=findgen(N1)*nyquist   ;findgen(ns)
freq = (findgen(n1)+1)/(n1/2)*nyquist;
   ;freq=freq[1:N1-1] ; remove 0
power=abs(T_FFT[1:N1-1])^2;   (0:ns-1])^2;
;power_T=power[1:ns-1];
 !p.multi=[0,1,2]
 plot,freq, power,color=2,background=-2,ytitle='power'
 DFT=T_FFT(1:N1/2);
 ;PSD_T0=(1.0/(nx*N))*abs(DFT)^2
 PSD=abs(DFT)^2/(n1*N1)
 L2=n_elements(PSD);
 PSD_T=fltarr(L2)
 PSD_T(1:N2-1)=2*PSD(1:N2-1);
 ;xfreq=findgen(floor(N/2)); 0:N/L:N/2   ;nyquist*A/ns;;A[0:ns-1]/ns
 plot,freq,10*alog10(PSD_T),color=2,background=-2,ytitle='10*alog10(PSD)'
 stop
window,1
n2=n_elements(freq);
;DZ=(h2-h1)/N2
Peri=dh/freq  ;freq[1:n-1]

!P.multi=[0,2,1]
plot,peri,PSD_T,color=2,background=-2,xtitle='km',ytitle='PSD '
oplot,peri,psd_T,color=25,psym=2

plot,freq,psd_T,color=2,background=-2,xtitle='freq',ytitle='PSD'
;plot,Temp[b1:b2],Z,background=-2,color=2,yrange=[h1,h2],xtitle='Temperature',ytitle='km',charsize=1.5;,position=plotposition1
;oplot,fit_t,Z,color=50
;oplot,anmt,Z,color=120
;plot,peri,power_T,color=1,background=-2,xtitle='Period km',Ytitle='power',title='FFT temperature anomaly'

;oplot,peri,power_T,color=2,psym=4
stop


fignm='E:\raidosonde\taals\'
fignm=path0+date+'.bmp'
;write_bmp,fignm,tvrd()
File3='FFT_'+date
F3=fignm+file3
T_FFT=fltarr(2,n/2)
T_FFT[0,*]=peri
T_FFT[1,*]=PSD_T
;openw,2,F3
;printf,2,T_FFT
close,2

stop

stop
;
end
