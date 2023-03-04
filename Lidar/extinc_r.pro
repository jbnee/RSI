Function extinc_r,ht
 ;ht in km
 ;give total extinction of the atmosphere
 extinc_r=(8*!pi/3)*5.45E-32*(550./532.0)^4*density(ht)  ;Rayleigh backscattering coefficient
 return,extinc_r
end