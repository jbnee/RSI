Pro Xsimpson
;Integration
n=1000
;sf1=fltarr(n)
;sf2=fltarr(n)
m=findgen(n)
fx=fltarr(n)
x1=1.0
x2=5.0
fx=m^3-2.0
h=(x2-x1)/n

sf1=xf(x1)
sf2=xf(x2)

factor=2
for j=1,n-1 do begin
  jx=x1+j*h
  if (factor eq 2) then begin
  factor=4
  endif else begin
  factor=2
  endelse

  sf1=factor*xf(jx)+sf1
  sf2=(2*xf(jx))+sf2
endfor
  sf1=(h/3)*(sf1+XF(x2))
  sf2=(h/2)*(sf2+xf(x2))
print,sf1,sf2,qsimp('xf',x1,x2)

stop
end
