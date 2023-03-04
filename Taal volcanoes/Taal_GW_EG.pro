pro Taal_GW_EG
; Taal gravity wave energy
;
; Reference He Yang
close,/all
erase

F1=''
; input single CWB data file as T2003may.txt

;F1='E:\Radiosonde\2017-2019DongGang\2019\07\20190701_0000.46750.edt';enr,1,F1;0
F1='E:\radiosonde\Taal\98433_Feb08Z12_2020.txt'

;
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
;   take only 4~10 km
h1=3
h2=10
b1=10
b2=50
nb=b2-b1+1;
Ht=H[1,b1:b2]
P=H[0,b1:b2]
Temp=H[2,b1:b2]
Tk=Temp+273.15
RH=H[4,b1:b2]
WS=H[7,b1:b2]*0.514;
WD=H[8,b1:b2]
km=Ht/1000


!p.multi=[0,2,1]

WS2=smooth(WS,5)
WD2=smooth(WD,5)
plot,WS,km,color=2,background=-2,xtitle='WS'
oplot,WS2,km,color=90
plot,WD,km,color=2,background=-2,xtitle='WD'
oplot,WD2,km,color=90
stop


Tk_sm=smooth(TK,5,/edge_truncate)


V=-WS2*cos(WD2*3.14/180.);
U=-WS2*sin(WD2*3.14/180.);


U_sm=smooth(U,5,/edge_truncate)
V_sm=smooth(V,5,/edge_truncate)

;V_fit=poly_fit(km, V, 4, MEASURE_ERRORS=measure_errors, SIGMA=sigma)
;Fit_V=poly(km,V_fit);


!p.multi=[0,3,1]
plot,Tk,km,psym=4,background=-2,color=1,yrange=[h1,h2],xtitle='Temperature',ytitle='km',charsize=1.5;,position=plotposition1
oplot,Tk_sm,km,color=100
plot,U,km,psym=2,background=-2,color=1,yrange=[h1,h2],xtitle='U:zonal speed',ytitle='km',charsize=1.5;,position=plotposition3
oplot,U_sm,km,color=80

;plot,RH,km,color=2,xtitle='RH ',ytitle='km',charsize=1.5
plot,V,km,psym=2,background=-2,color=1,yrange=[h1,h2],xtitle='V:meridional SPEED',ytitle='km',charsize=1.5;,position=plotposition2
oplot,V_sm,km,color=80



stop
WINDOW,1
erase
!P.MULTI = [0,2,1]
 Tk_anm=smooth(Tk-Tk_sm,5)
 U_Anm=smooth(U-U_sm,5); anomaly zonal wind
 V_Anm=smooth(V-V_sm,5); anomaly merid wind
plot,U_sm,km,color=2,background=-2,xrange=[-10,10],yrange=[h1,h2],xtitle='m/s',ytitle='km', title='10x U_V, anomaly',charsize=1.3
oplot,10*U_anm,km,color=2,psym=4
oplot,V_sm,km,color=150;background=-2,yrange=[h1,h2],xtitle='m/s',ytitle='km',title='V merid aomaly',charsize=1.3
oplot,10*V_anm,km,color=150,psym=2
plot,U_anm,km,color=2,background=-2,xrange=[-1,1],yrange=[h1,h2],xtitle='m/s',title='U, V,anomaly'
oplot,V_anm,km,color=100

 stop
 window,0
 erase
;******************************* Brunt_Vaisala frequency *****************************************8
plot,u_anm,V_anm,color=2,background=-2,psym=6


stop
for i1=0,nb-1 do begin
plots,u_anm[i1],v_anm[i1],psym=2,color=2,/continue;,background=-2
;wait,1
endfor
stop
plot,u_anm,Tk_anm,color=2,psym=4
TAAL_ANM=fltarr(4,nb)
Taal_anm[0,*]=km
Taal_anm[1,*]=U_anm
Taal_anm[2,*]=V_anm
Taal_anm[3,*]=Tk_anm
close,1
Fanm='E:\radiosonde\Taal\UV_Anomaly.txt'
openw,1,Fanm
hd=''
printf,1,'km,Uanm,Vanm,Tanm, 2020Feb08_12'
printf,1,Taal_anm
close,1



;;;***********PE and KE  *************************88
 g=9.8   ;meter/s2
 cp=7/2
 r_d=9.8e-3  ;dry adiabatic lapse rate deg/m
 z=1000.*km
 Tk_fit=poly_fit(km, Tk, 4, MEASURE_ERRORS=measure_errors, SIGMA=sigma)
 Fit_Tk=poly(km,Tk_fit);
 T_anm=Tk-Fit_Tk
 ;Ratio_Tanm=T_anm/Fit_Tk

 r= deriv(z,Fit_Tk)
 ;P_N2=1/sqrt((r/Poten_T*(r_d-r)))  ;Period of BV freq,N square, N=Brunt-Vaisal freq
  N2=sqrt((g/Fit_Tk)*(r_d-r));
  T_N2=6.28/N2; period

  AN2=MAX(ABS(T_N2))

 PE=smooth((g^2/(2*N2^2))*(T_anm/Fit_Tk)^2,5)
 window,2
; plot,N2,km,color=2,background=-2,yrange=[h1,h2],xtitle='Brunt-Vaisala freq',charsize=1.3

 plot,PE,km,color=2,psym=2,background=-2,yrange=[h1,h2],xtitle='PE',title='Potential energy',charsize=1.3
 oplot,smooth(PE,5),km,color=100

 KE=0.5*(sqrt(U_anm^2+V_anm^2))

 plot,KE,km,color=2,psym=2,background=-2,yrange=[h1,h2],xtitle='KE',ytitle='km'

 oplot,smooth(KE,5),km,color=100

stop

  opath='E:\radiosonde\Taal\'
  cntrname =opath+'GWEnergy.bmp'

  WRITE_bmp, cntrname, TVRD()
   db=b2-b1+1
   ED=fltarr(3,db)
   ED[0,*]=km
   ED[1,*]=KE
   ED[2,*]=PE

   Fx1=opath+'GW_energy.txt'
   openw,1,Fx1
   printf,1,ED

    CLOSE, 1



stop

end



