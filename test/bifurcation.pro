pro bifurcation
a=3.2
x=fltarr(100)
dx=fltarr(100)
x[0]=0.2

for i=1,9 do begin
x[i]=a*x[i-1]*(1-x[i-1]);  1/(1+sqrt(a))
dx[i]=x[i-1]-x[i]
print,x[i]
endfor
plot,x,yrange=[0,1]
;plot,dx
stop
end

