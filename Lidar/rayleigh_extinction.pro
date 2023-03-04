 function Rayleigh_extinction,km

    ; density= 1.E25*(2.4498-0.22114*ht+0.00701*ht^2-7.75225E-5*ht^3)  ;ht in km; in molec/m3
   N=density(km)
   beta=5.45E-32*(550./532.)^4*N;  density  ;Rayleigh backscattering coefficient



   return,beta

end