pro 3plots
x=findgen(1000)
 t=5.*x*3.14/180
;for 3 waves
z1=cos(t)
z2=cos(t+2.)
z3=cos(t+4.)
 !P.MULTI=[0,1,3]
plot,x,z1,background=-2,color=2
plot,x,z2,background=-2,color=3
plot,x,z3,background=-2,color=4
stop
;For 3 slits
y=1+4*cos(t)+4*(cos(t))^2
plot,x,y,background=-2,color=2

 end
