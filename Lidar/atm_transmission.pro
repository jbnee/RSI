Pro ATM_transmission
;function TM,z,dz
;TM:transmission of the atmosphere at 532 nm
;z top height in km
;dz: height resolution
Z=30 ; km
dz=0.024  ; meter or 0.0075
htnum=z/dz+1
ht=dz*INDGEN(htnum)
tau=fltarr(htnum)
Tm=fltarr(htnum)
kext=fltarr(htnum)

  Xdensity= 1.E25*(2.4498-0.22114*ht+0.00701*ht^2-7.75225E-5*ht^3)  ;ht in km; in molec/m3
  ;beta_r Rayleigh backscattering coefficient in 1/m
  ; kext=Xdensity*6.26e-32  ;6.24e-32 backscattering cross section at 532 nm
 plot,Xdensity,ht
stop
   tau[htnum-1]=0.001

   for j= htnum-1,1,-1 do begin
   ; ht=j*dz
    kext[j]=Xdensity[ht[j]]*6.26e-32
    tau[j]=kext[j]*dz*1000+tau[j-1]
    print,j,ht,tau[j]
    TM[j]=exp(-2*tau[j])
 endfor
plot,kext,ht
stop

 ; return,TM

  end