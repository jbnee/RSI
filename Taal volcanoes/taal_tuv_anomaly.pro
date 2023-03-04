pro Taal_TUV_anomaly
; Taal gravity wave energy
;output anomaly data for T,U,V
; Ref,Gubenko
close,/all
erase
path1='E:\radiosonde\Taal\'
F1=''
; input single CWB data file as T2003may.txt

;F1='E:\Radiosonde\2017-2019DongGang\2019\07\20190701_0000.46750.edt';enr,1,F1;0
F1=path1+'98433_Jan01Z12_2020.txt'
adate=strmid(F1,25,8)
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
z=H[1,*]/1000;
h1=1.;
h2=10;
q1=where(z gt h1)
b1=min(q1)-1
q2=where(z lt 8)
b2=max(q2);
stop
nb=b2-b1;
Ht=H[1,b1:b2]
P=H[0,b1:b2]
Temp=H[2,b1:b2]
Tk=Temp+273.15
RH=H[4,b1:b2]
WS1=H[7,b1:b2]*0.514;
WD1=H[8,b1:b2]
km=Ht/1000



 x=km[0:nb]; km[6:17]
fWS=poly_fit(x, WS1, 3, MEASURE_ERRORS=measure_errors, SIGMA=sigma)
WS2=poly(x,fWS)  ; polynomail fit of w

fWD=poly_fit(x, WD1, 3, MEASURE_ERRORS=measure_errors, SIGMA=sigma)
WD2=poly(x,fWD)  ; polynomail fit of w

 ;WS2=smooth(WS,5)
;WD2=smooth(WD,5)

!p.multi=[0,2,1]
 LOADCT, 1
plot,WS1,km,color=2,psym=5,background=-2,xtitle='WS'
loadct,10
oplot,WS2,km,color=80
plot,WD1,km,color=2,psym=5,background=-2,xtitle='WD'
oplot,WD2,km,color=120
stop


;Tk_sm=smooth(TK,5,/edge_truncate)


 V=-WS2*cos(WD2*3.14/180.);
 U=-WS2*sin(WD2*3.14/180.);
;temperature anomaly

 yT=Tk[0:nb]
; qT=poly_fit(x, yT, 3, MEASURE_ERRORS=measure_errors, SIGMA=sigma)
 QT=[310.656,-13.43,1.676,-0.104]; using 0101 data
 pT=poly(x,qT)  ; polynomail fit of T
 Tvar=pT-yT;
 AvPT=mean(pT)

 yU=U[0:nb]
  qU=poly_fit(x, yU, 3, MEASURE_ERRORS=measure_errors, SIGMA=sigma)
 ;qU=[-14.6925,15.956,-3.263,0.188]; Jan01 data
 pU=poly(x,qU); polynomial fit of U
 AvpU=mean(pU)
 Uvar=pU-yU

 yV=V[0:nb]
 qV=poly_fit(x, yV, 3, MEASURE_ERRORS=measure_errors, SIGMA=sigma)
 ;;QV=[14.653,-13.058,2.142,-0.093]  ;Jan01 data
 pV=poly(x,qV); polynomial fit of V
 AvpV=mean(pV)
 Vvar=pV-yV

window,1
loadct,0

!p.multi=[0,3,1]
 plot,yT,x,color=2,background=-2,yrange=[h1,h2],xtitle='T fit, anomaly, and data(*)',psym=2
 stop
 oplot,pT,x,color=55
 oplot,Tvar+AvPT,x,color=200
loadct,13
  plot,yU,x,color=2,background=-2,yrange=[h1,h2],xtitle='U fit, anomaly, and data(*)',psym=2
 oplot,pU,x,color=55
oplot,Uvar+AvPU,x,color=250

plot,yV,x,color=2,background=-2,yrange=[h1,h2],xtitle='V fit, anomaly, and data(*)',psym=2
oplot,pV,x,color=155
oplot,Vvar+AvPV,x,color=250

print,AVPT,AVpU,AVPV
;TUV_anm=fltarr(4,nb+1)
T_anm=fltarr(2,nb+1)
;TUV_anm[0,*]=x
;TUV_anm[1,*2=Tvar
;TUV_anm[2,*]=Uvar
;TUV_anm[3,*]=Vvar
T_anm[0,*]=x
T_anm[1,*]=Tvar
file2=path1+'T_Anomaly_'+adate+'B.txt'
openw,2,file2
printf,2,T_anm
close,2
stop
window,2
!p.multi=[0,1,1]
loadct,1
np=n_elements(Uvar)
plot,Uvar,Vvar,color=2,background=-2,psym=3;xrange=[-0.2,0.2],yrange=[-0.2,0.2]
for n1=0,np-1 do begin
plots,Uvar(n1),Vvar(n1),color=2,psym=6
;wait,1
endfor
stop
t=indgen(361)*6.28/361
p=0.03*sin(t)
q=0.04*cos(t)
b=3.14/5
px=p*cos(b)+q*sin(b)-0.03
py=-p*sin(b)+q*cos(b)
oplot,px,py,color=2,psym=3

stop
Lat=14.0
Om=7.29e-5  ;%earth rotation
f=2*Om*sin(Lat*3.1416/180);
print,'Inertial freq: ',f
g=9.8;% gravity
N=0.022; %input('BV frequency:');
Peri_BV=6.28/N; %period of BV
DT=mean(abs(Tvar))
Tb=mean(Tk) ; %mean temperature from data
T_v=DT/Tb ; %0.0113 %input temperature perturbation in K
;%HA method
;%u=4.86  %input zonal wind speed
;%v=0.46 % meridional speed
du=mean(abs(Uvar)); 0.108
;uv=0.1/0.015;
dv=mean(abs(Vvar))
w=(du/dv)*f
Lz=2700;% vertical wavelength from tempeature data
kz=6.28/Lz;
duv=sqrt(du^2+dv^2);
x1=(g/N)*(T_v/duv);
w2=sqrt(f^2/(1-x1^2))
print,'w2:',w2
T_in=6.28/w;
c_u=(N/kz)/sqrt(1-(f/w)^2)

;%``````````````````````Eq 12 Gubenko 2008`````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````
;
kx=sqrt((w^2-f^2)*kz^2/N^2) ; %Horizontal wave number
Lx=6.28/kx;   %Horizontal wave length
c=du+Lx/T_in
cu=c-du;
;%SWA method based on Eq (13) Gubenko2008
ae=(g/N^2)*kz*T_v
w3=(f/2)*(2-ae)/sqrt(1-ae) ; intrinsic frequency

print,'Intrinsic frequency:',w3
Peri_int=6.28/w3
c_u=(N/kz)/sqrt(1-(f/w3)^2)
kx=sqrt((w3^2-f^2)*kz^2/N^2)
Lx=6.28/kx
print,'horizotal wavelength:',Lx/1000

c=du+Lx/T_in
cu=c-du
stop
stop
end



