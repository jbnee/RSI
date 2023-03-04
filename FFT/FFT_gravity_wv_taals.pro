pro FFT_Gravity_wv_Taals
;note:Gravity wave of temperature anomaly below 10 km
close,/all
erase
;path1='E:\radiosonde\2017-2019ªF´ä\2019\outs\';  CWB1985_2006'
;year='2002'
;yr=strmid(year,2,2)
;month='MR'
;date1='18'
Path0='D:\radiosonde\test\'
F1=''
; input single CWB data file as T2003may.txt

;F1='E:\Radiosonde\2017-2019DongGang\2019\07\20190701_0000.46750.edt';enr,1,F1;0
F1='D:\radiosonde\test\98433_Feb08Z12_2020.txt'

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
Ht=H[1,0:49]
P=H[0,0:49]
Temp=H[2,0:49]
RH=H[4,0:49]
WS=H[7,0:49]*0.514;   knots to m/s
WD=H[8,0:49]
km=Ht/1000

!P.MULTI = [0,3,1]
 plot_position1= [0.1,0.15,0.45,0.45];
  plot_position2= [0.1,0.6,0.45,0.95]
 ; plot_position3 = [0.6,0.15,0.95,0.45];
 ; plot_position4=[0.6,0.6,0.95,0.95]

!p.background=255
WINDOW,0
plot,Temp,km,background=-2,color=1,yrange=[0,10],xtitle='Temperature',ytitle='km',charsize=1.5;,position=plotposition1
plot,WD,km,background=-2,color=1,yrange=[0,10],xtitle='WIND DIRECTION',ytitle='km',charsize=1.5;,position=plotposition3
;plot,RH,km,color=2,xtitle='RH ',ytitle='km',charsize=1.5
plot,ws,km,background=-2,color=1,yrange=[0,10],xtitle='WIND SPEED',ytitle='km',charsize=1.5;,position=plotposition2
;plot,wD,km,background=-2,color=1,yrange=[0,10],xtitle='WIND DIRECTION',ytitle='km',charsize=1.5;,position=plotposition4
;
fout=strmid(F1,40,9)
;read,outfile,prompt='name of the outfile as Taals: '
;fout1=path1+'DG-'+fout+'.bmp'
;write_bmp,fout1,tvrd()
;printf,2,meanH

stop
T_fit=poly_fit(km, Temp, 3, MEASURE_ERRORS=measure_errors, SIGMA=sigma)
Fit_T=poly(km,T_fit);
!P.multi=[0,1,1]
plot,temp,km,color=1,background=-2,xrange=[-20,20],yrange=[0,10],xtitle='temperature',ytitle='km',charsize=1.3
oplot,Fit_T,km,color=90;
stop


;WINDOW,1
erase
ANMT=Temp-Fit_T  ;temperature anomaly
plot,ANMT,km,color=1,background=-2,title='temperature anomaly'
stop
N=n_elements(temp)
;A=indgen(N);/2)
x=indgen(N);
T_FFT=fft(ANMT)
ns=n_elements(T_FFT)/2;
;A=indgen(ns);
;freq=findgen(ns)
power=abs(T_FFT[0:ns-1])^2;
power_T=power[1:ns-1];
nyquist=0.5
freq=nyquist*findgen(ns)/ns;;A[0:ns-1]/ns
Peri=0.19/freq[1:ns-1]
!P.multi=[0,2,1]
plot,Temp,km,background=-2,color=1,yrange=[0,10],xtitle='Temperature',ytitle='km',charsize=1.5;,position=plotposition1
plot,peri,power_T,color=1,background=-2,xtitle='Period km',Ytitle='power',title='FFT temperature anomaly'
stop
;fignm=path0+'98443.bmp'
;write_bmp,fignm,tvrd()
;;;;;;********** FFT of pressure

P_fit=poly_fit(km, P, 3, MEASURE_ERRORS=measure_errors, SIGMA=sigma)
Fit_P=poly(km,P_fit);
ANMP=P-Fit_P ;
P_FFT=fft(anmP)
P_power=abs(P_fft[0:ns-1])^2;
Power_P=P_power[1:ns-1];
;Peri_P=0.19/freq[1:ns]
!p.multi=[0,2,1]

window,1
plot,ANMP,km,color=2,background=-2,title='Pressure anomaly'
plot,peri,Power_P,color=2,title='FFT pressure'

stop
FFT_TP=fltarr(3,NS-1);
FFT_TP[0,*]=Peri;
FFT_TP[1,*]=power_T
FFT_TP[2,*]=power_P

;Pathout='E:\RSI\current\
TP_fft=path0+'FFT_TPwv.txt'
openw,1,TP_fft
printf,1,FFT_TP
close,1

pltname2 =path0+'FFT_wv_Taals.bmp'
WRITE_bmp, pltname2, TVRD()

stop
end



