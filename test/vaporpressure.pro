Pro vaporpressure
; Vapor pressure over liquid water below 0¢XCl
;   Guide to Meteorological Instruments and Methods of Observation (CIMO Guide)  (WMO, 2008)
; http://cires.colorado.edu/~voemel/vp.htm
;    ew = 6.112 e(17.62 t/(243.12 + t))
 ;   with t in [¢XC] and ew in [hPa]
N=150
t=dblarr(N)
ei=dblarr(N)
x=dblarr(N)
k=findgen(N)+150
t=k-273.00
ew = 6.112* exp(17.62* t/(243.12 + t))
ei = 6.112* exp(22.46* t/(272.62 + t))
q=7.5*(T/(T+237.3))
ex=6.11*10^q
plot,t,ew,xrange=[-100,0],yrange=[0,1];psym=0
oplot,t,ei,psym=2
oplot,t,ew-ei,psym=1
stop
oplot,t,ex,psym=3
g=0.623*(ex/(100-ex))
plot,t,g

;write_bmp,'D:\RSI\TEST\vapor_press.bmp',tvrd()
stop
end

