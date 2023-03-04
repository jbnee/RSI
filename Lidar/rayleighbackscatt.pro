Pro Rayleighbackscatt  ;opthick,z
  nz=findgen(1000)
  dz=24.;
  z=nz*dz  ; height in meter
  ht=z/1000.   ;height in km

  wavel=0.532E-6
  density= 1.E25*(2.4498-0.22114*ht+0.00701*ht^2-7.75225E-5*ht^3)  ;ht in km; in molec/m3

   n=1.000278
   Tcross=(8*(!pi)^3/3)*((n^2-1)^2/(density[0]*waveL^2)^2) ; cross section
   beta_r=Tcross*density  ;=5.45E-32*(550./532.)^4*density  ;Rayleigh backscattering coefficient
   kext=(8*3.1416/3.)*beta_r
   opthick=kext*dz
   plot,density,ht,xtitle='density molecule/m3',ytitle='km'
   stop

   plot,beta_r,ht,xtitle='beta_r',ytitle='km'
   stop

   Ibr=beta_r*z
   plot,Ibr,ht
   dI=fltarr(1000)
   tau=fltarr(1000)
   tau2=fltarr(1000)
   tau[0]=beta_r[0]*dz
   ;;;below is the integral of beta_r from zm to z, zm is the reference point
   for j=0,998 do begin
    dI[j]=Ibr[J+1]-Ibr[J]
    tau[j+1]=tau[j]+dz*(beta_r[j+1]+beta_r[j])
    k=1000-(j+2)
   ; tau2[k+1]=tau2[k]+dz*(beta_r[k]+beta[k+1])
   endfor
   sumI=TOTAL(dI)
   print,'integration of beta_rdz=di: ',sumI
   plot,dI,ht,background=-2, color=3,xtitle='beta_r(I+1)H(I+1)-beta_r(I)H(I)',ytitle='height km'

    stop
    sumI=TOTAL(dI)
   print,'integration of di: ',sumI
    plot,tau,ht,xtitle='optical thickness',ytitle='km'
   stop
    tms=exp(-tau)
   plot,tms,ht,xtitle='transmission', ytitle='km'

   stop
   sg=fltarr(1000)
   z[0]=1.
   For IS=0,999  do begin
   Sg[is]=1.E8*beta_r[is]*((tms[is]/z[is])^2)
   endfor
   plot,alog(sg),ht, xtitle='Rayleigh signal',ytitle='km'
   stop
   end


