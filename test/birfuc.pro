pro birfuc
x=fltarr(500)
a=findgen(20)*0.1+2.0
x[0]=0
for k=0,20 do begin
for i=0,500 do begin
x[i+1]=a[k]*x[i]*(1-x[i])
endfor
plot,a,x
stop
end


