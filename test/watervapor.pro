pro watervapor
;Based on MurphyQJRMS2005 Review of vapor pressure of ice
p1=dblarr(50)
p2=dblarr(50)
p3=dblarr(50)
T=findgen(50)+150.0
TT=273.16
y=-9.096853*(TT/T-1)-3.566506*alog10(tt/T)+0.876812*(1-T/tt)
q=7.5*(T/(T+237.16))
z=9.550426-5723.265/t+3.53068*alog(t)-0.00728332*T
p1=6.11*Exp(y)  ; appendix
p2=6.11*10^(q)  ; Das eq.

p3=exp(z)   ;eq 7 in the paper

print,t,(p1-p2)/p1
plot,T,p1,psym=0
oplot,t,p2
oplot,t,p3,psym=4
stop
end