pro auto_READ_radiosonde


close,/all
path0='E:\radiosonde\'
spath='donggang\2021\04';
;read,Spath,prompt='path of data:  '

Fx=path0+Spath+'\*'

nF=file_search(Fx)
help,nf

;read,nx,prompt='Day files position as 42:  '
FOR nx=1,62 do begin
print,'nx: ',nx
F1=nf[nx-1]
print,F1
da=strmid(F1,41,6)  ; file name
;stop
;fname='F:\rsi\test\Radioson2000_120612.txt'
;read,data1,prompt=' where is data? AS d:\rsi\test\Lidar_T2001ja16.txt'
;fname=path1+fileN
OPENR,1,F1;  fname
;stop
line=''
cols=8
rows=10000 ;

for L=0,4 do begin

readf,1,line
print,line
endfor
;STOP
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
;stop

Ht=H[1,*];
h1=0.0  ;km'
h2=5000.0 ; km
b1=0
b2x=where(Ht gt h2)
b2=min(b2x)
;print,'top height: ',H(1,b2)
;stop

Ht0=H[1,b1:b2]
P0=H[2,b1:b2]
Temp0=H[3,b1:b2]
Tk0=Temp0+273.15
RH0=H[4,b1:b2]
WS0=H[5,b1:b2]*0.514;
WD0=H[6,b1:b2]
km0=Ht0/1000
phi=fltarr(N)
phi=270-WD0;U=WS*sin(phi*3.14/180.);
V0=WS0*cos(phi*3.14/180.);
U0=WS0*sin(phi*3.14/180.);

;stop
!p.background=255
;WINDOW,0

;
;da=strmid(F1,41,4) ; date
;U_fit=poly_fit(km, U, 4, MEASURE_ERRORS=measure_errors, SIGMA=sigma)
;Fit_U=poly(km,U_fit);
;U_sm=smooth(u,5)

;V_fit=poly_fit(km, V, 4, MEASURE_ERRORS=measure_errors, SIGMA=sigma)
;Fit_V=poly(km,V_fit);
;V_sm=smooth(V,5)

!p.multi=[0,4,1]

;;;;;;;;;;;************* Interpolation *************************
;stop
dz=Ht(b2)/b2 ; height range 3.2 km to 10.0 km in 0.2km interval
Z=findgen(b2)*dz
Temp=interpol(Temp0,km0,Z)
Tk=Temp+273.15;
U=interpol(U0,km0,Z)
V=interpol(V0,km0,Z)

plot,Temp0,z,color=2,background=-2,yrange=[h1,h2],xtitle='Temperature',ytitle='km',$
  title=da,charsize=1.5;,position=plotposition1
oplot,Temp0,km0,color=100
;oplot,Temp,z,color=100,psym=2
plot,U0,z,background=-2,color=2,yrange=[h1,h2],xtitle='U:zonal speed',ytitle='km',$
title=da,charsize=1.5;,position=plotposition3
oplot,U,z,color=100
U_sm=smooth(U,5)
oplot,U_sm,Z,color=100

plot,V0,z,color=2,background=-2,yrange=[h1,h2],xtitle='V:meridional SPEED',ytitle='km',$
  title=da,charsize=1.5;,position=plotposition2
V_sm=smooth(V,5)
oplot,V,z,color=80
oplot,V_sm,Z,color=100,psym=2

plot,phi,z,psym=2,color=2,title=da,charsize=1.5
;stop
wait,2
  opath='E:\radiosonde\outputs\2021_04\'
  outname =opath+da+'_radio_out.bmp'
  openw,2,outname
  WRITE_bmp, outname, TVRD(/true)

close,/all
endfor; nx
stop

end