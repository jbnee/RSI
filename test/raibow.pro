Pro Raibow
na=1.0
nw=1.33
f=3.1416/180.

t1x=findgen(80)+15;  incident angle in degree
t1=t1x*f   ;incident angle in radian
t2=asin((na/nw)*sin(t1))

;td=t4-(3.1416/6-t1)
td=!pi-2*(2*t2-t1)   ; deviation angle
;t1x=(t1/3.1416)*180
tdx=180-td/f
y=where(td eq max(td))
plot,t1x,tdx ;,xramge=[18,28],yrange=[9,10]
print,y,t1x(y), max(tdx)
stop
end