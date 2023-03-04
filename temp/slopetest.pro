pro slopetest
x=findgen(100)
A=50.
S=10.
Y=fltarr(100)
b=fltarr(100)
v=fltarr(100)
for I=0,99 do begin
Y(I)=exp(-(I-A)^2/(2*S))+0.2*exp(-(I-30)^2/(2*S))+ 0.3*exp(-(I-60.)^2/(0.5*S))+1.
endfor
plot,Y,yrange=[0,2]
stop
b=deriv(x,Y)
v=b/Y
oplot,v+1
;print,v
stop
end