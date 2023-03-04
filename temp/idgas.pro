Pro iceH2O  ;convert ppm of H2O into ice mg/m3 then extinction k
R=0.082
A=6.023E23
;Read,P,prompt='pressure in hPa'
p=100  ;hPa
P=P/1013.25
;Read,T,prompt='temperature in k'
T=273-80.
n=A*P/(1000.*R*T);concentration
print, P,'atm',T,'=K  ','n= ',n
stop
f=1.0   ;ppmv
;read,f,prompt='H2O in ppmv'
V=f*n/(3.1E16)  ;volume density in um^3cm^-3 by Massie 2002
;based on Massie 2002 Distribution of tropical cirrus in relation to convection
print,'V= in micron^3/cm^3 ',V  ;V=exp(c+bB+aB^2) solve for B
;convert into mg/m^3
rho=0.93  ;density ice 00.93 gram/cm3
imdensity1=V*(1.E-6)^3*rho/1.E-6  ;' in gram/cm3
imdensity=imdensity1*(1.E3/1.E-6)  ; in mg/m3
print,'ice mass density in mg/m3= ',imdensity
c=11.14
b=1.380
a=-1.976E-3
B=(-b+sqrt(b^2-4*a*c))/(2*a)
print,B
stop
k=exp(B/c)  ;extinction 1/km
print,k,'optical thickness=  ',k*1  ;for 1 km
stop
end

