pro random_phase
phi=fltarr(1200)
phi2=fltarr(1200)
dphi=fltarr(1200)
x=findgen(1000)
seed=1.5
tao=12.0
sum=0
for n=0,100 do begin
s=randomu(seed)
J=n*10
phi(J:J+9)=s;*2*!pi
;print,n,x,phi(J:J+9)
;phi2(J+tao:J+9+tao)=phi(J:J+9)
;phi2(J:J+9)=
endfor
for k=0,999 do begin
phi2[0:999]=phi(tao:999+tao)
endfor
dphi=abs(phi-phi2)*2*!pi
plot,x,phi,background=-2,color=2,xrange=[0,100],yrange=[0,6.28]
oplot,x,dphi,linestyle=3,color=2
Sum=sum+cos(dphi(k))

stop
print,sum

end