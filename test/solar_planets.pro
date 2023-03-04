pro solar_planets
close,/all
planet=dblarr(5,9)
openr,1, 'd:\rsi\test\solar.txt'
readf,1,planet
s=planet[0,*]   ;distance to the sun
mass=planet[1,*]
radius=planet[2,*]
Period=planet[3,*]*365*86400.  ;change year to second
w_orbit=2*3.14/period
spinperiod=planet[4,*]*86400   ; change day to seconds
w_spin=2*3.14/spinperiod
;print,s,mass,radius
;v=2*3.14*s/period
J_orbit=mass*s^2*w_orbit
Imoment=(2./5.)*mass*radius^2
J_spin=Imoment*w_spin
kepler3=s^3*w_orbit^2


print,J_orbit,J_spin,kepler3
stop
end