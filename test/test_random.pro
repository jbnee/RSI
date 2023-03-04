pro test_random
phi=fltarr(120)
phi2=fltarr(120)
dphi=fltarr(120)
x=findgen(100)
seed=1.5
tao=6.0

for n=0,10 do begin
s=randomu(seed)
J=n*10
phi(J:J+9)=s;*2*!pi
;print,n,x,phi(J:J+9)
;phi2(J+tao:J+9+tao)=phi(J:J+9)
;phi2(J:J+9)=
endfor
for k=0,99 do begin
phi2[0:99]=phi(tao:99+tao)
endfor
dphi=phi-phi2
plot,x,phi,background=-2,color=2,yrange=[-1,1]
oplot,x,dphi,linestyle=3,color=2
stop

end