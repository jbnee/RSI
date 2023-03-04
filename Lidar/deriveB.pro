Pro deriveB   ;Test of differential beta_r is the Rayleigh backscattering coeff.
bnum2=1250         ; for 30 km and below

 density=fltarr(bnum2+1)
  beta_r=fltarr(bnum2+1) ;backscattering coefficient of air
  ;beta_a=fltarr(n2-n1+1,bnum2)  ;backscattering coefficient of aerosol
dz=0.024

 km=findgen(bnum2+1)*dz  ;height range in meters of 0-30 km
 ht=km*1000
 km[0]=0.01

 ; density of air is the polynomial fit of height determined from radiosonde
 density= 1.E25*(2.4498-0.22114*km+0.00701*km^2-7.75225E-5*km^3)  ;ht in km; in molec/m3
 beta_r=5.45E-32*(550/532)^4*density  ;Rayleigh backscattering coefficient

 plot, beta_r, km, background=-2, color=1
 slp1=deriv(beta_r)/0.024
 slp2=deriv(km,beta_r)
 slp3=(beta_r[550]-beta_r[552])/(2*0.024)

 print, slp1[550],slp2[550],slp3
   stop
 end
