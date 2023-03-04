function density_air,ht; ht is in km
den=1.E25*(2.4498-0.22114*ht+0.00701*ht^2-7.75225E-5*ht^3)
return,den
end