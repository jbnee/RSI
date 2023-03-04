 pro ATM_simu_cirrus
 n=30000. ; 30 km
ht1=findgen(n)/1000. ;ht km
density=fltarr(n)
beta_r=fltarr(n)
kext=fltarr(n)
tau=fltarr(n) ; optical thickness
tm=fltarr(n)  ;transmission
b_cirrus=fltarr(n)
cext=fltarr(n)
tau2=fltarr(n)
tm2=fltarr(n)

density= 1.E25*(2.4498-0.22114*ht1+0.00701*ht1^2-7.75225E-5*ht1^3)  ;ht in km; in molec/m3

   beta_r=5.45E-32*(550./532.)^4*density  ;Rayleigh backscattering coefficient @532 nm

   kext=(8*3.1416/3.)*beta_r   ;Rayleigh extinction 532 nm
   ;kext=ht1
   ;Rayleigh extinction

; !p.multi=[0,1,2]
; plot_position1 = [0.1,0.05,0.95,0.45];
; plot_position2 = [0.1,0.5,0.95,0.90];
; plot_position3=[0.1,0.65,0.95,0.95]
plot,kext/1.E-6,ht1,xtitle='kext (1E-6)',ytitle='km',charsize=1.0
stop
dz=1.0
tau[n-1]=0  ; start at 30 km
for j=n-2,0,-1 do begin
  tau[j]=kext[j]*dz+tau[j+1]
  tm[j]=exp(-tau[j]);
endfor

tm=exp(-tau)
;tm[0]=tm[1]
plot,tau,ht1,title='tau',ytitle='km',xtitle='tau:optical thickness',charsize=1.4;position=plot_position1,
stop
plot,tm,ht1,xrange=[0.75,1.0],ytitle='km',title='transmission',charsize=2.0;position=plot_position2,
stop
;simulation at 15 km cirrus cloud
cext=kext
cirrus=10*kext[15001:16000];cloud at 15-16 km
cext[15001:16000]=kext[15001:16000]+10.*cirrus; kext[15001:16000]  ;backscattering coefficient of cirrus with R=10 bk ratio
  ;Rayleigh extinction 532 nm

; !p.multi=[0,1,2]
; plot_position1 = [0.1,0.05,0.95,0.45];
; plot_position2 = [0.1,0.5,0.95,0.90];
; plot_position3=[0.1,0.65,0.95,0.95]
plot,cext,ht1,title='cext',ytitle='km',charsize=1.0
stop
tau2[0]=0
for j=1,n-1 do begin
tau2[j]=cext[j]*1000.+tau2[j-1]

endfor
tm2=exp(-2*tau2)
plot,tau2,ht1,title='tau',ytitle='km',charsize=1.0;position=plot_position1,

oplot,tau,ht1
stop
plot,tm2,ht1,ytitle='km',title='transmission';charsize=2.0;position=plot_position2,
oplot,tm,ht1
stop
end