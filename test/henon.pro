pro Henon
tt=findgen(100)
x=fltarr(10000)
y=fltarr(10000)
x[0]=0.1
y[0]=0.1
a=1.4
b=0.3
;k=0.112
;B=11.0
h=0.01
for i=1,9995 do begin
t=h*i
x[i]=y[i-1]+1-a*x[i-1]
y[i]=b*x[i-1]
;y[i]=-k*y[i-1]-x[i-1]^3+B*cos(t)
endfor
plot,x
stop
plot,y
stop
plot,x,y,xrange=[-1.5,1.5],yrange=[-0.45,0.45]
stop
end


