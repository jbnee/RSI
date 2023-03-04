pro logistic
x=fltarr(20)
x(0)=0.5
u=1.0
for n=1,19 do begin
x(n)=u*x(n-1)*(1-x(n-1))*(1-x(n-1))
print,n,x(n)
endfor
plot, x, psym=5
r=findgen(20)

oplot,0.05+0.5/r^2
end
