function Xmission,z,dz
;XM:transmission of the atmosphere at 532 nm
;z top height in km
;dz: height resolution
htnum=z/dz
ht=dz*INDGEN(htnum)
tau=fltarr(htnum)
Tm=fltarr(htnum)
kext=fltarr(htnum)

  Xdensity= 1.E25*(2.4498-0.22114*ht+0.00701*ht^2-7.75225E-5*ht^3)  ;ht in km; in molec/m3
  ;beta_r Rayleigh backscattering coefficient in 1/m
  ; kext=Xdensity*6.26e-32  ;6.24e-32 backscattering cross section at 532 nm
   tau[htnum-1]=0
   for j= htnum-1,1,-1 do begin
    ht=j*dz
    kext[j]=xdensity[j]*6.26e-32
    tau[j]=kext[j]*dz*1000+tau[j-1]
    TM[j]=exp(-2*tau[j])
  endfor
    Xmission=TM
  return,Xmission

  end