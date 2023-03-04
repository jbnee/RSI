pro external
n1=1.35
n2=1.89
;n1=[1.0, 1.1,1.2,1.3]
;n2=[1.5,1,4,1.8,1.6]
brewster=atan(n2/n1)
brewster2=atan(n1/n2)
refract=asin((n1/n2)*sin(brewster))
refract2=asin((n2/n1)*sin(brewster2))
print,n1,n2,brewster,brewster2,refract,refract2
stop
end