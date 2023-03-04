pro bifurcation2
a=3.2
x=fltarr(100)
dx=fltarr(100)
x[0]=3.0

for i=1,10 do begin
x[i]=(0.00002*x[i-1]+1.2)^2;  1/(1+sqrt(a))
dx[i]=x[i-1]-x[i]
print,x[i]
endfor
plot,x;yrange=[0,1]
;plot,dx
stop
end

