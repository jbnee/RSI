function density, km
;x in km
;km=findgen(100)

 Den= 1.E25*(2.4498-0.22114*km+0.00701*km^2-7.75225E-5*km^3)  ;ht in km; density in molec/m3
return,den
 end