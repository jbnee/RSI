Pro yNLeq1
H=0.01
x=0.0
q=fltarr(2,300)
for k=0, 299 do begin
y=[k,1+k]
dydx=NLEq1(x,y)
result=RK4(y,dydx,x,H,'NLEq1')
q[0,k]=result[0]
q[1,k]=result[1]
endfor
plot,q[0,*],q[1,*]
stop
end



