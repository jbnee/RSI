pro plots3D
erase
x=findgen(1000)/2000.
 t=5.*x*3.14
;for 3 waves
z1=cos(t^2)
z2=cos(5*t)
z3=50 *cos(cos(t+4))
 !P.MULTI=[0,1,3]
plot,x,z1,background=-2,color=2
plot,x,z2,background=-2,color=3
plot,x,z3,background=-2,color=4
stop

Y=Z1
plot,x,y,color=2,background=-2
plot,y,z3,color=100
plot,x,z3,color=20
stop

X=z1
PLOT_3DBOX,x, Y, Z3, /XY_PLANE, /YZ_PLANE, /XZ_PLANE,color=2,background=-2, $
   /SOLID_WALLS, GRIDSTYLE=1, XYSTYLE=3, XZSTYLE=4, $
   YZSTYLE=5, AZ=40, TITLE='Example Plot Box', $
   XTITLE='X Coordinate', YTITLE='Y Coodinate', $
   ZTITLE='Z Coordinate', SUBTITLE='Sub Title', $
   /YSTYLE, ZRANGE=[0,20], XRANGE=[0,20], $
   PSYM=-4, CHARSIZE=1.6
 end
