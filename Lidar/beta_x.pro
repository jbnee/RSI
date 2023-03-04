Function beta_x,ht
 ;ht in km
 ;give backscattering of Rayleigh

 beta_x=5.45E-32*(550./532.0)^4*density(ht)  ;Rayleigh backscattering coefficient
 return,beta_x
end