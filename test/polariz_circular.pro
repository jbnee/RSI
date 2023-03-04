Pro Polariz_circular
k=200.
w=30.
z=10.
t=40.0
x1=findgen(100)
y1=findgen(100)
zz=fltarr(100)
plot,x1,y1,background=-2, color=-11
zz=findgen(200)
Efield=fltarr(2,100)
;stop

for i=0,399 do begin
;z=2*i
z=0
t=0.005*i
plots,50,50
;plots,z-10,z-10
ex=50*cos(k*z-w*t)+50.
ey=50*sin(k*z-w*t)+50
er=sqrt(ex^2+ey^2)
Efield[0,i]=ex
Efield[1,i]=ey
plots,ex,ey,/continue,thick=3, color=4
;oplot,z,er,/polar,
wait,0.1
endfor
stop
;iplot,efield[0,*],efield[1,*],thick=3, color=4
stop
end
