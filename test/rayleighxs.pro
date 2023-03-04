Pro RayleighXS
wvl=5.32e-7
Ndensity=2.5e25
n=1.000293; for air
F1=(wvl^2*Ndensity)^2
F2=((n-1)^2)/F1
X_total=(32./3)*((!pi)^3)*F2;  *(n-1)^2)
print,X_total
stop
end


