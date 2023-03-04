pro Gaussian

z=fltarr(50)
y=fltarr(50)

read,prompt='xo center in A ',xo
read, prompt='FWHM=  A ', sigma
read, prompt='starting wavelength in A  ',x1
read, prompt='ending wavelength in  A  ',x2
A=1/(sigma*sqrt(6.28))
d=sigma^2

for m=0,(x2-x1),1 do begin

z[m]=x1+m  ; wavelength
while (z[m] gt 0) do begin
y[m]= a*exp(-(z[m]-xo)^2/2*d)
print,m,z[m], y[m]
endwhile
endfor
plot,z,y,xrange=[x1,x2]
stop
end