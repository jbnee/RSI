Pro Rayleigh_test
;check various formulation
;starting with cross section@532=5.31e-31
f1=(8*3.14/3)*(!pi)^5  ;constant1
eo=8.854e-12; permitivity
Nd=2.69e25  ; density of air
;q=k4*3.14*eo
na=1.000278  ;index of refraction at 532 nm
nx=(na^2-1)/(na^2+2)
L1=532.e-9   ; 532 nm
k1=6.28/L1  ;wavenumber
a1x=(3*eo/Nd)*nx
r=2.8e-9; vary this to get correct cross section xs1
RL6=(r^3/L1^2)^2
xs1=f1*RL6*nx^2
a1=sqrt(xs1/(f1*k1))
print,'Rayleigh cross section:',xs1,a1x,a1
stop
;consider a case of for particle of radius 0.03 micron, at wavelength 1.0 micron
; calculate the cross section
na2=1.6  ; index of refraction
nx2=(na2^2-1)/(na2^2+2)
L2=1.0e-6
r2=0.03e-6
RL6=(r2^3/L2^2)^2
xs2=f1*RL6*nx2^2

print,'Rayleigh cross section:',xs2
stop
; by using first example to find alpha: polarizability

xs1c=xs1*10000.; change to CGS

k1c=6.28/(L1*100) ; change wavelength to CGS
a1c=sqrt(xs1c/(f1*k1c))  ;polarizability alpha in CGS
a2c=(3/(4*3.14*Nd))*nx
print,xs1c,k1,a1c,a2c
stop
end
