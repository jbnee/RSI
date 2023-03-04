function b_Rayleigh,ht
;ht in km
density=1.E25*(2.4498-0.22114*ht+0.00701*ht^2-7.75225E-5*ht^3)
return,5.45E-32*(550./532.)^4*density  ;Rayleigh backscattering coefficient
end