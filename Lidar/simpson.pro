function opthick,ht1

  density= 1.E25*(2.4498-0.22114*ht1+0.00701*ht1^2-7.75225E-5*ht1^3)  ;ht in km; in molec/m3

  beta_r=5.45E-32*(550./532.)^4*density  ;Rayleigh backscattering coefficient

 ext=(8*3.1416/3.)*beta_r   ;Rayleigh extinction
  return,ext
  end

