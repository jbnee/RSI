pro NLOSC1
;from Marion problems 4.22
tt=findgen(100)
x=fltarr(100)
y=fltarr(100)
x[0]=0.1
y[0]=0.1
k=0.112
B=11.0
h=0.01
for i=1,99 do begin
t=h*i
x[i]=y[i-1]*t
y[i]=-k*y[i-1]-x[i-1]^3+B*cos(t)
endfor
plot,x
stop
plot,y
stop
end