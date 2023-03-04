 pro ATM_Rayleigh;rayleigh atmospheric transmission @532nm
 ;xsection is the Rayleigh total scattering cross section=[24(!pi)^3/(N^2*lambda^4)]*(na^2-1/na^2+2)^2;
 ;bbeta_r is the backscattering coefficient
 ;kext is the total scattering coefficient
 ;kext is the extinction=xsection*density
 ;alpha is the polarizability alpha=(3eo/N)*nx; P=alpha*E
 ;In this calculation, the transmission is from bottom to top of the atmosphere
 ;Ordinary transmission of solar radiation is the opposite: from top to bottom
  n=1000
 dz=24.0  ;height resolution 24 meter
ht1=findgen(n)*dz/1000;  0.024
density=fltarr(n)
bbeta_r=fltarr(n)
kext=fltarr(n)
tau=fltarr(n)
tm=fltarr(n)
lambda=532.E-9  ;wavelength
denSTP=6.023E23*101325.0/(8.3144*295)
 density= 1.E25*(2.4498-0.22114*ht1+0.00701*ht1^2-7.75225E-5*ht1^3)  ;ht in km; in molec/m3
;stop
   na=1.000278  ;refractive index of air
   nx=(na^2-1)/(na^2+2)
   eo=8.854e-12; Farad/meter permetivity of free space
  ; denLam=density*lambda^2
    alpha=double((3*eo/density)*nx); polarizability,,
   xsection=(24*(!pi)^3/(density*lambda^2)^2)*(nx^2);  Rayleigh cross section
   Rayb=xsection[0]*density[0]
   RaySTP=xsection[0]*denSTP[0]
   bbeta_r=5.45E-32*(550./532.)^4*density  ;Rayleigh backscattering coefficient

   kext=(8*3.1416/3.)*bbeta_r   ; Rayleigh extinction: total scattering coefficient from bbteta_r

 print, 'Rayleigh xsection',xsection[0], Rayb[0], RaySTP[0], bbeta_r[0],kext[0]
 !p.multi=[0,1,3]
 plot_position1 = [0.1,0.05,0.95,0.25];
 plot_position2 = [0.1,0.35,0.95,0.55];
 plot_position3=[0.1,0.65,0.95,0.92]
plot,kext/1.E-6,ht1,color=2,background=-2,position=plot_position3,title='total beta',ytitle='km',charsize=2.0
xyouts,10,20,'ext/1E-6',color=45
stop
tau[n-1]=kext[n-1]*dz
tausimp= fltarr(n)
tmsimp=fltarr(n)
;Simpson Integral= (dx/3)*(FIRST term+4*(sum of ODD terms)+2*(sum of EVEN terms)+ LAST terms)
tausimp[n-1]=kext[n-1]
factor=4
FOR j=n-1,1,-1 do begin
  tau[j-1]=kext[j-1]*dz+tau[j]
    if (factor eq 4) then begin
      factor=2
       endif else begin
      factor=4
    endelse

   tausimp[j]=(dz/3)*factor*kext[j]+tausimp[j-1]
   ;tm[j]=exp(-2*tau[j])
   ;tmsimp[j]=exp(-2*tausimp[j])
ENDFOR
tm=exp(-2*tau)
tausimp[n-1]=(tausimp[j]+(dz/3)*kext[n-1]) ;Simpson terms
tmsimp=exp(-2*tausimp)

plot,tau,ht1,position=plot_position1,color=2,background=-2,title='tau',ytitle='km',charsize=2.0
oplot,tausimp,ht1,color=30
xyouts,0.02,15,'tau optical thickness',color=50
plot,tm,ht1,color=2,background=-2,position=plot_position2,xrange=[0.75,1],ytitle='km',charsize=2
xyouts,0.85,15,'transmission atmosphere',color=50
stop
 !p.multi=[0,1,3]
 plot_position1 = [0.1,0.05,0.95,0.45];
 plot_position2 = [0.1,0.55,0.95,0.95];
 z=dz*findgen(n)
 ztop=z[999]; top of the atmosphere 24 km
 tau1=fltarr(n)  ; for solar light from top of the atmosphere
 tau2=fltarr(n)  ;for liar : light from groun

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  tau1=qromb('opthick',z,ztop)


  tau2=qromb('opthick',0,z)

  plot,tau2,z/1000,color=2,background=-2,position=plot_position1,xtitle='tau' ,ytitle='km',charsize=2
  oplot,tau,z/1000,color=80;position=plot_position1
  xyouts, 0.05,20,'qromb integral',color=50
  stop
  T1=exp(-2*tau1);round trip transmission
  T2=exp(-2*tau2)
  plot,T2,z/1000,color=2,background=-2,position=plot_position2,xtitle='Transmission',ytitle='km',charsize=2
  oplot,tau,z/1000,color=45;position=plot_position2
  xyouts,0.9,20,'qromb inverse'  ,color=50
  stop

  end
  function opthick,z
  ht1=z/1000.
  density= 1.E25*(2.4498-0.22114*ht1+0.00701*ht1^2-7.75225E-5*ht1^3)  ;ht in km; in molec/m3
   bbeta_r=5.45E-32*(550./532.)^4*density  ;Rayleigh backscattering coefficient
   kext=(8*3.1416/3.)*bbeta_r
  opthick=kext
  return,opthick
  end

