pro bifurc
x=fltarr(501)
a=findgen(20)*0.1+3.0
x[0]=0.75
for k=0,10 do begin
;a=k*0.1+3.0
for i=0,499 do begin
x[i+1]=a[k]*x[i]*(1-x[i])
endfor ;i
;endfor  ;k
plot,x;xrange=[50,150]
print,k,a[k]
stop
oplot,x;xrange=[50,150]
endfor  ;k
end
