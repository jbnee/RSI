Pro Reflect_rsp
 n=2.4/1.33

 theta=findgen(90)*!pi/180
 phi=asin((sin(theta)/n))
 xt=theta*180/!pi
 xf=phi*180/!pi
  brewster=atan(n)*180/3.1416
print,'Brewster angle',brewster
 ;r2=sqrt(n^2-sin(theta)^2)
 rs=-sin(theta-phi)/sin(theta+phi)
 ts= (2*cos(theta)*sin(phi))/(sin(theta+phi))
 rp=-tan(theta-phi)/tan(theta+phi)
 tp=(2*cos(theta)*sin(phi))/(sin(theta+phi)*cos(theta-phi))

 stop

 plot,xt,rs, background=-2, color=2,xrange=[0,90], yrange=[-1,1],xtitle='Incident Angle (degree)',ytitle='reflection'
 plots,1,0
 plots,100,0,color=5,/continue
 xyouts, 50,0.3,'TM',color=2,charsize=2
 xyouts, 50,-0.5,'TE' ,color=2,charsize=2
 oplot,xt,rp, color=4,linestyle=0
 xyouts,57,0.02,'Brewster Angle',color=5,charsize=1
 stop

 oplot,xt,rs^2, color=3, linestyle=3; background=-2, color=2,xrange=[0,90], yrange=[0,1],xtitle='Incident Angle (degree)',ytitle='transmission'
 oplot,xt,rp^2, color=4,linestyle=3


 xyouts, 90,0.3,'R_TM',color=6,charsize=1
 xyouts,70,0.6,'R_TE' ,color=6,charsize=1
 xyouts,20,0.8,'n= ' ,color=6,charsize=2
 stop
 ;write_bmp,'g:\rsi\test\Reflec1.bmp',tvrd()

b1=brewster-5
b2=brewster+5

;In the region of Brewster angle: 50-60
  x1=findgen(11)+round(brewster)-5

  R1= rs[b1:b2]^2
  R2=rp[b1:b2]^2
  plot,x1,r1, color=2,background=-2,xtitle='Incident Angle (degree)',ytitle='transmission'
oplot,x1,r2,color=2
oplot,x1,r2*10, color=5,linestyle=3
xyouts,b1,0.11,'R_TE',color=3
xyouts,b1,0.005, 'R_TM',color=4
xyouts,brewster,0.01,'Brewster angle',color=6
xyouts, brewster,0.25,'R_TM*10',color=8
;write_bmp,'g:\rsi\test\Reflection55.bmp',tvrd()


 end