Pro INT_beta_r
; In the first part we will read data and plot;
; In the second part, we will process signal according to Fernald
; Part I Rayleigh calcution
 ; read,bnum, prompt='Enter total number bins (eg.4096)  '
   ;constants  for the program
   device, decomposed=0
   Loadct,5
   bT=50      ;160 ns for SR430 bin width

   ns=1.0E-9   ;nanosecond
   c=3.0E8     ;speed of light
    bnum= 4000  ;24 km
   dz= bT*ns*(c/2)/1000  ;increment in height is dz=
   ht=(findgen(bnum+1)+1)*dz  ; height in km start from dz meter
   dz1000=dz*1000 ;in meter
   z=ht*1000 ; in meter
  ;treat Rayleigh scattering

    bn=fltarr(bnum+1); bin array of 1250 for 1250*0.024=30km
  ;ITz1=fltarr(bnum)
  ;ITz2=fltarr(bnum)
  beta_r=fltarr(bnum+1) ;Rayleigh backscattering coefficient
  kext=fltarr(bnum+1)

  beta_r=dblarr(bnum+1) ;backscattering coefficient of air
   tau=fltarr(bnum+1); Rayleigh optical thickness
   TM=fltarr(bnum+1)  ;  Rayleigh transmission
      ;density=fltarr(bnum+1);air density
      ;density= 1.E25*(2.4498-0.22114*ht+0.00701*ht^2-7.75225E-5*ht^3)  ;ht in km; in molec/m3
     N0=density(ht) ;
     beta_r=5.45E-32*(550./532.)^4*N0 ;density(ht)  ;Rayleigh backscattering coefficient

     plot,beta_r,ht,color=60, background=-2,title='Rayleigh backscattering coefficient',ytitle='km',xtitle='beta-r'
     stop
     Sa=50; lidar ratio  ;for cirrus cloud
     Sr=8*!pi/3; lidar ratio for air

     kext=(8*3.1416/3.)*beta_r   ;Rayleigh extinction

;;;;;;;;;;;;;;;;;;;;;;Rayleigh calculation;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 tau[bnum-1]=kext[bnum-1]*dz1000
 for j=bnum-2,1,-1 do begin
    tau[j]=kext[j]*dz1000+tau[j+1]
    Tm[j]=exp(-2*tau[j])
endfor
plot,tau,ht,background=-2,color=5,xtitle='tau',ytitle='km';charsize=2.0,title='Optical thickness'
xyouts,0.02,15,'tau optical thickness'
stop
plot,Tm,ht,background=-2,color=4,xrange=[0.75,1],ytitle='km',xtitle='transmission';
xyouts,0.85,15,'laser atmospheric transmission'
stop
INTB=fltarr(bnum+1); integral of beta_r from top down
INTB[bnum]=beta_r[bnum]*dz1000
SINTB=fltarr(bnum+1); integral of beta_r from top down
SINTB[bnum]=beta_r[bnum]*dz1000

FOR I1=bnum-1,0,-1 do begin

 INTB[I1]=INTB[I1+1]+(beta_r[I1]+beta_r[I1+1])*(dz1000/2)
 SINTB[I1]=SINTB[I1+1]+(beta_r[I1]+beta_r[I1+1])*(dz1000/2)
 ENDFOR

plot,INTB,ht,color=12,background=-2,xtitle='integrated beta_r top down', ytitle='km'

stop
end