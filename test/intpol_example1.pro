Pro Intpol_example1
close,/all
Xpath='E:\RSI\TEST\DG_2021020100sonde.txt'
openr,1,xpath
line=''
readf,1,line
print,line
stop
read,s1,prompt='size of file'
read,s2,prompt='length of file'
Xfile=fltarr(s1,s2)
readf,1,Xfile
Ht=xfile[0,*];
T_radio=xfile[1,*]; temperature of radiosonde
P_radio=xfile[2,*]
!p.multi=[0,1,2]
plot,Ht/1000,T_radio,color=2,background=-2,charsize=1.3,xtitle='height',ytitle='temperature'
plot,Ht/1000,P_radio,color=2,background=-2,charsize=1.3,xtitle='ht',ytitle='Pressure hPa'
stop
close,1

Ht_set=findgen(100)*100.0; height 0:10km
; Define X-values where interpolates are desired:
;U = [-2.50, -2.25, -1.85, -1.55, -1.20, -0.85, -0.50, -0.10, $
   ;0.30, 0.40, 0.75, 0.85, 1.05, 1.45, 1.85, 2.00, 2.25, 2.75 ]

; Interpolate:
Temp_fit = INTERPOL(T_radio, Ht,Ht_set)
P_fit=interpol(P_radio,Ht,Ht_set);

!p.multi=[0,2,1]
plot,Ht/1000,T_radio,color=2,background=-2,charsize=1.3,xtitle='height',ytitle='temperature'

OPLOT, Ht_set, Temp_fit,psym=4,color=99;
stop
plot,Ht/1000,P_radio,color=2,background=-2,charsize=1.3,xtitle='ht',ytitle='Pressure hPa'
oplot,Ht_set,P_fit,psym=2,color=99
stop
plot,Temp_fit,Ht_set,color=2,background=-2,yrange=[0,5000],$
xtitle='Temperature',ytitle='height m',title='fitted temperature';
ST=smooth(Temp_fit,5);
Oplot,St,Ht_set,color=80
stop
fitdata=fltarr(3,100)
fitdata[0,*]=Ht_set[0:99]
 fitdata[1,*]=Temp_fit[0:99]
 fitdata[2,*]=St[0:99]
 xout='E:\RSI\test\radio_fit2.txt'
 line='fit radio,ht,T_fit,T_smooth'
 openw,2,xout
 printf,2,line
 printf,2,fitdata
 close,2

stop


end