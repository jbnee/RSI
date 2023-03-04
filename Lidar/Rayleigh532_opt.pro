 pro Rayleigh532
 n=1000
ht1=findgen(n)*0.024
density=fltarr(n)
beta_r=fltarr(n)
kext=fltarr(n)
tau=fltarr(n)
tm=fltarr(n)

 density= 1.E25*(2.4498-0.22114*ht1+0.00701*ht1^2-7.75225E-5*ht1^3)  ;ht in km; in molec/m3

   beta_r=5.45E-32*(550./532.)^4*density  ;Rayleigh backscattering coefficient

   kext=(8*3.1416/3.)*beta_r   ;Rayleigh extinction
   ;kext=ht1
   ;Rayleigh extinction

 !p.multi=[0,1,3]
 plot_position1 = [0.1,0.05,0.95,0.3];
 plot_position2 = [0.1,0.35,0.95,0.60];
 plot_position3=[0.1,0.65,0.95,0.95]
plot,kext,ht1,position=plotposition3,title='kext',ytitle='km',charsize=2.0
stop
tau[0]=0
for j=1,n-1 do begin
tau[j]=kext[j]*24+tau[j-1]
tm[j]=exp(-2*tau[j])
endfor
plot,tau,ht1,position=plot_position1,title='tau',ytitle='km',charsize=2.0
plot,tm,ht1,position=plot_position2,xrange=[0.75,1],ytitle='km',title='transmission',charsize=2.0
stop

 z=24*findgen(n)
 ztop=z[999]; top of the atmosphere 24 km
 tau1=fltarr(n)  ; for solar light from top of the atmosphere
 tau2=fltarr(n)  ;for liar : light from groun

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  tau1=qromb('opthick',z,ztop)


  tau2=qromb('opthick',0,z)

  plot,tau2,z/1000,color=2,background=-2,position=plot_position1,xtitle='tau' ,ytitle='km'
  stop
  T1=exp(-2*tau);round trip transmission
  T2=exp(-2*tau)
  plot,T2,z/1000,color=2,background=-2,position=plot_position2,xtitle='Transmission',ytitle='km'
  stop

  end
  function opthick,z
  ht1=z/1000.
  density= 1.E25*(2.4498-0.22114*ht1+0.00701*ht1^2-7.75225E-5*ht1^3)  ;ht in km; in molec/m3
   beta_r=5.45E-32*(550./532.)^4*density  ;Rayleigh backscattering coefficient
   kext=(8*3.1416/3.)*beta_r
  opthick=kext
  return,opthick
  end

