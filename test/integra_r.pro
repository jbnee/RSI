pro integra_r

z=findgen(1250)
density=fltarr(1250)
intA=fltarr(1250)
ht=z*0.024
density= 1.E25*(2.4498-0.22114*ht+0.00701*ht^2-7.75225E-5*ht^3)
sum=0
for i=0, 1240 do begin
sum=density[i]+sum
Isum=sum*24
endfor
IntA=Qsimp('fdensity',0,30)*1000
plot,density,ht,background=-2,color=2
print,IntA,'  ',Isum
stop
end
