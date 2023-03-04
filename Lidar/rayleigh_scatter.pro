Pro Rayleigh_scatter
;check various formulation
;starting with cross section@532=5.31e-31
na=1.000278
nx=(na^2-1)/(na^2+2)
L1=532.e-9
q1=(128./3)*3.14^5
r=2.145e-9; vary this to get correct cross section xs1
RL6=(r^3/L1^2)^2
xs1=q1*RL6*nx^2
print,xs1
stop
;for particle
na2=1.6
nx2=(na2^2-1)/(na2^2+2)
L2=1.0e-6
r2=0.03e-6
RL6=(r2^3/L2^2)^2
xs2=q1*RL6*nx2^2
print,xs2
stop
xs1c=xs1*10000.; change to CGS
f1=(8*3.14/3)*(!pi)^5
k1=6.28/(L1*100)
a1=sqrt(xs1c/(f1*k1))
print,xs1c,k1,a1
stop
end
