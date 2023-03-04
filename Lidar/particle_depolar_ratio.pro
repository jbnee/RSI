Pro particle_depolar_ratio
;calculate particle depolarization ratio from volume depolarization ratio
 dr=0.014  ;Rayleigh depolarization ratio
 dv=0.3  ;volume depolarization ratio
   ;backscattering ratio
 ; particle depolarization ratio
 dA=fltarr(10)
 RT=fltarr(10)

FOR i=0 ,9 do begin
 Rt[i]=I*10+10  ;backscattering ratio
 dA11=(1+dR)*dv*Rt[i]
 da12=(1+dv)*dR
 da21=(1+dR)*Rt[i]
 da22=1+dv


  da[i]=(da11-da12)/(da21-da22)
  print,da
  endfor
;stop
plot,RT,dA
stop
;;;now vary dv volume depolarization ratio
dV=fltarr(100)
da=fltarr(100)
RT=100  ;fixed backscattering ratio 100
FOR i=0 ,9 do begin
 dv[i]=I*0.010+0.010  ;backscattering ratio
 dA11=(1+dR)*dv[i]*RT
 da12=(1+dv[i])*dR
 da21=(1+dR)*RT
 da22=1+dv[i]


  da[i]=(da11-da12)/(da21-da22)
 ; print,da
  endfor
plot,dv,da,psym=2

stop
plot,dv,(da-dv)/dv,psym=4; error
stop
end