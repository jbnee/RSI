pro moondistance
rm=dblarr(1)

g=9.8
T=27.3*86400.;period of moon
Re=6400000.   ;km
;rm^3=g*(T*Re/6.28)^2
c=(T*Re/6.28)^2.
rm3=g*C
rm=rm3^(1/3.)
print,c,rm3,rm; moon distance is rm
a=rm*(2*!pi/T)^2    ;moon acceleration T*Re/6.28)^2
print,a,sqrt(g/a)
stop
end