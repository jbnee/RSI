Pro ATM_density
den=fltarr(4001)
ht=fltarr(4001)
j=0
  ;km=indgen(30)
  ;d=1.E25*(2.4498-0.22114*km+0.00701*km^2-7.75225E-5*km^3)  ;ht in km; density in molec/m3

for i=0,4000 do begin
 ;print,i,j
 ht[i]=i*0.0075
 den[j]=density(ht[i])

 j=j+1
 endfor

;loadct=1
plot,den,ht,psym=0, background=-2,color=2
stop
y=poly_fit(ht,den,3)
print,y
d=y[0]+y[1]*ht+y[2]*ht^2+y[3]*ht^3
oplot,d,ht,psym=1,color=200
;for i=1,10 do begin
oplot,d,ht,psym=0,color=220
;endfor
stop
end

function density, km
;x in km
;km=findgen(100)

 return,  1.E25*(2.4498-0.22114*km+0.00701*km^2-7.75225E-5*km^3)  ;ht in km; density in molec/m3
 end