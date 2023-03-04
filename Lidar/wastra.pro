pro Wastra ;size and cross section of ice
wl=0.532   ;micron laser wavelength
m=1.311    ;refractive index
;(1)  x=2*3.14*a/lm ;size parameter
;(2)  Q=sc/(3.14*a*a)  ;
;(3)  rho=2*x*(m-1)   ; phase lag ; =0.622*x=1.244*3.14*a/lm
;
r=fltarr(100)  ;radius
ax=fltarr(100)
Q_R=fltarr(100)
;Q_R=(8./3.)*x^4*((m^2-1)/(m^2+2))^2  ;small sphere
;Q_SJ=Q_R*(1+(6./5.)*(m^2-2)/(m^2+2))*x^4;
j=0
for i=0, 99 do begin
  rho=i;
 x=rho/(2*(m-1)); from (3) x is the diameter
 a=wl*i/(1.244*3.14)  ;
 r[i]=x
 ax[j]=a
 Q_R[j]=(8./3.)*x^4*((m^2-1)/(m^2+2))^2  ;small sphere

 j=j+1
print,i,rho,a

endfor
;plot,ax,r,psym=2
plot,r,Q_R
stop
end



