pro watervapor2   ;  vapor pressure based on Murray et al 2005
p1=dblarr(100)
p2=dblarr(100)
p3=dblarr(100)
T=findgen(100)-100  ;T=-100 to 0 C
T0=273.16
tk=t+T0
y=-9.096853*(T0/Tk-1)-3.566506*alog10(T0/Tk)+0.876812*(1-Tk/T0)
q=7.5*(Tk/(Tk+237.16))
z=9.550426-5723.265/tk+3.53068*alog(tk)-0.00728332*Tk
p1=6.11*Exp(y)
p2=6.11*10^(q)

p3=exp(z)

ew = 6.112* exp(17.62* tk/(243.12 + tk))
;print,t,(p1-p2)/p1
plot,T,p1,psym=0
oplot,t,p2
oplot,t,p3,psym=4
stop
end