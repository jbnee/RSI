  pro Rayleigh,N,dz
;;;;Rayleigh backscattering coefficient
;;;;;;;; density of air is the polynomial fit of height determined from radiosonde
  ;lidar eq: S=k*J*[beta_a+beta_c]*T/z^2  a:air; c: clouds
   ;N=2000
   ;dz=7.5
   bin=findgen(N)
   ht1=bin*dz/1000
   sig=fltarr(N)
   density=dblarr(N)
   beta_r=fltarr(N)
   kext=fltarr(N)
   tau=fltarr(N)
   TM=fltarr(N)      ;transmission
   z=1000*ht1  ;height limit
   ;nz=10/0.024
   density= 1.E25*(2.4498-0.22114*ht1+0.00701*ht1^2-7.75225E-5*ht1^3)  ;ht in km; in molec/m3
   beta_r=5.45E-32*(550./532.)^4*density  ;Rayleigh backscattering coefficient
   kext=(8*3.1416/3.)*beta_r   ;Rayleigh extinction
   cxsray=kext/density                   ;Rayleigh extinction

   ;plot,kext,ht1,background=-2,color=2,xtitle='K-EXT',ytitle='km'
  ; stop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   tau[N-1]=Kext[N-1]*dz
   TM[N-1]=exp(-2*tau[n-1])

   for j=N-2,0,-1 do begin
    tau[j]=tau[j+1]+(kext[j]+kext[j+1])*dz/2
    Tm[j]=exp(-2*tau[j])
    endfor
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;y=(Sig*ht1^2)/(transm*beta_r); pr^2/T
 ;plot,tau,ht1,color=2,background=-2,xtitle='tau:opt thick',ytitle='km'
  ;stop
  ;plot,Tm,ht1,background=-2,color=2,xtitle='Transmission',ytitle='km'

 return,kext
;;stop
end
;
;''''''''''''''''''''''''''''''''''''''''

;function opthick,ht1

  ;density= 1.E25*(2.4498-0.22114*ht1+0.00701*ht1^2-7.75225E-5*ht1^3)  ;ht in km; in molec/m3

 ; beta_r=5.45E-32*(550./532.)^4*density  ;Rayleigh backscattering coefficient

  ;ext=(8*3.1416/3.)*beta_r   ;Rayleigh extinction
  ;return,ext
  ;end