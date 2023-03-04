Pro groupV; group velocity
wv0=fltarr(100)
wv1=fltarr(100)
w= 3.0
n=0.251
t=findgen(100)*0.5
wv0=cos(w*t)
 wv1=cos((w+n)*t)
 ;plot,t,wv1, background=-2,color=4,xrange=[0,20]
stop
 ;oplot,t,wv1,linestyle=0
 ;stop
 plot,t,wv0+wv1,linestyle=2,xrange=[0,50], background=-2,color=6
 ;stop
 ;for I=0,99 do begin
   ;twv=wv(1)+wv(2)+wv(3)+wv(4)+wv(5)
   end

