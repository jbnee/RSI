Function beta_r,ht
 ;ht in km
 ;give backscattering of Rayleigh

 beta_r=5.45E-32*(550./532.0)^4*density(ht)  ;Rayleigh backscattering coefficient
 return,beta_r
end