PRO ATM_transm

READ,Z0, PROMPT='HEIGHT IN KM: '
;Z0=30
dz=0.024
 n=Z0/dz+1
z=findgen(n) ;ht km
xdensity=fltarr(n)
beta_r=fltarr(n)
kext=fltarr(n)
tau=fltarr(n)
tm=fltarr(n)
;density= 1.E25*(2.4498-0.22114*ht1+0.00701*ht1^2-7.75225E-5*ht1^3)  ;ht in km; in molec/m3

!p.multi=[0,1,1]
 For k=n-1,1,-1 do begin
   ht1=z[k]*dz
   Xdensity[k]=density(ht1)
   beta_r[k]=5.45E-32*(550./532.)^4*density(ht1)  ;Rayleigh backscattering coefficient @532 nm
endfor; k
 H=z*0.024
 plot,xdensity ,H, ytitle='km',xtitle='density of air /m3'
 stop
 plot,beta_r,H
 stop
   kext=(8*3.1416/3.)*beta_r   ;Rayleigh total extinction 532 nm
   ;kext=ht1
   ;Rayleigh extinction

!p.multi=[0,3,1]
plot_position1 = [0.1,0.1,0.25,0.95];
plot_position2 = [0.3,0.1,0.65,0.95];
plot_position3=  [0.7,0.1,0.95,0.95]
plot,kext/1.E-6,H,title='kext (1E-6)',ytitle='km',charsize=2.0,position=plot_position1
stop
tau[n-1]=kext[n-1]*24.0
for j=n-2,1,-1 do begin
tau[j]=kext[j]*dz*1000.+tau[j+1]
tm[j]=exp(-2*tau[j])
endfor
tau[0]=tau[1]
tm[0]=tm[1]
plot,tau,h,title='tau',charsize=2.0,position=plot_position2
stop
plot,tm,h,xrange=[0.75,1.0],title='transmission',charsize=2,position=plot_position3
stop
end