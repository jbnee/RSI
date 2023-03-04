Pro Brewster
 theta=findgen(90)*!pi/180
 x=theta*180/!pi
 n=1.5
 r2=sqrt(n^2-sin(theta)^2)
 rs= (cos(theta)-r2)/(cos(theta)+r2)
 rp=((-n^2)*cos(theta)+r2)/((n^2)*cos(theta)+r2)
 plot,x,rs, background=-2, color=2,xrange=[0,90], yrange=[-1,1]
  oplot,x,rp, color=4

 plots,1,0
 plots,100,0,color=5,/continue
 stop

 end