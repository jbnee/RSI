Pro density_2010
ht1=findgen(851)*24.0/1000
density= 1.E25*(2.4498-0.22114*ht1+0.00701*ht1^2-7.75225E-5*ht1^3)  ;ht in km; in molec/m3
ht=findgen(400)*50
A1=[ -8.049587172910795E11,	7.3015504534817456E16,	-2.282943190007955E21,2.4899816683730153E25]
A7=[-6.522697308928408E11,	6.2953122127651584E16,	-2.081364293891804E21,	2.3777127514345375E25]
den1=A1(0)*ht^3 +A1(1)*ht^2+A1(2)*ht+A1(3)
den7=A7(0)*ht^3 +A7(1)*ht^2+A7(2)*ht+A7(3)
plot,den1,ht,psym=3
stop
oplot,den7,ht
stop
k=50.0/24.0
denx=fltarr(400)
for i=0,399 do begin
denx[i]=density[k*i]
endfor
oplot,denx,ht,psym=2
stop
plot,(denx-den1)/denx
oplot,(denx-den7)/denx,psym=1

stop
end




