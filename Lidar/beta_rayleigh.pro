function beta_rayleigh,bnum,dz
;dz in km 0.0075 or 0.024
; valid for below 24 km bnum=
beta_r=fltarr(bnum+1) ;Rayleigh backscattering coefficient
kext=fltarr(bnum+1)

beta_r=dblarr(bnum+1) ;backscattering coefficient of air
   TAU=fltarr(bnum+1); Rayleigh optical thickness
   TM=fltarr(bnum+1)  ;  Rayleigh transmission
   ht=findgen(bnum)*dz
   ;density= 1.E25*(2.4498-0.22114*ht+0.00701*ht^2-7.75225E-5*ht^3)  ;ht in km; in molec/m3
 return, beta_r=6.245E-32*density(ht)  ;Rayleigh backscattering coefficient
 end