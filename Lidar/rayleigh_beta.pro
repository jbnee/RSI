Function Rayleigh_beta,bT,bnum
;bT: in bin time nano second such as 160
; In the first part we will read data and plot;
; In the second part, we will process signal according to Fernald
;Part I Rayleigh calcution
 ; read,bnum, prompt='Enter total number bins (eg.4096)  '
   ;constants  for the program
   ; bT=160      ;160 ns for SR430 bin width
     ;24 km  ;bin number to calculate
   ns=1.0E-9   ;nanosecond
   c=3.0E8     ;speed of light

   dz=bT*ns*C/2;  bT*ns*c/2  ;increment in height is dz=24 m
   ht=findgen(bt)*dz  ; height in km
   dz1000=dz*1000
  ;treat Rayleigh scattering

    bn=fltarr(bnum+1); bin array of 1250 for 1250*0.024=30km
  ;ITz1=fltarr(bnum)
  ;ITz2=fltarr(bnum)
 ; beta_r=fltarr(bnum+1) ;Rayleigh backscattering coefficient
  ;kext=fltarr(bnum+1)
  density=fltarr(bnum+1);air density
  beta_r=dblarr(bnum+1) ;backscattering coefficient of air
   ;TAU=fltarr(bnum+1); Rayleigh optical thickness
   ;TM=fltarr(bnum+1)  ;  Rayleigh transmission

   density= 1.E25*(2.4498-0.22114*ht+0.00701*ht^2-7.75225E-5*ht^3)  ;ht in km; in molec/m3
   Return, 5.45E-32*(550./532.)^4*density  ;Rayleigh backscattering coefficient

     ;plot,beta_r,ht, background=-2,color=2,title='Rayleigh backscattering coefficient',ytitle='km',xtitle='beta -m'

  end