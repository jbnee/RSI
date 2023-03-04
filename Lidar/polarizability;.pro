Pro polarizability; for xe
eo=8.85e-12  ;Farad/m
NA=6.02E23
V=22414.0  ;22.4 liter
n=1.000293; N2   1.00070  ; index refr. for xenon
nx=(n^2-1)/(n^2+2)
alpha=(3./(4*3.14*Na))*nx*V
print,alpha
stop
;alpha for MKS
q=(4*3.14*eo)*1.e-6
alphamks=alpha*q;  (3*eo/NA)*nx;*1.e-6
print,alphamks,alphamks/alpha
stop
end