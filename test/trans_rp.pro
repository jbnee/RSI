Pro Trans_Rp
 n=1.5
 theta=findgen(90)*!pi/180
 phi=asin((sin(theta)/n))
 xt=theta*180/!pi
 xf=phi*180/!pi
 n=1.5
 ;r2=sqrt(n^2-sin(theta)^2)
 ts= (2*cos(theta)*sin(phi))/(sin(theta+phi))
 tp=(2*cos(theta)*sin(phi))/(sin(theta+phi)*cos(theta-phi))
 plot,xt,ts, background=-2, color=2,xrange=[0,90], yrange=[0,1],xtitle='Incident Angle (degree)',ytitle='transmission'
  oplot,xt,tp, color=4,linestyle=3

 plots,1,0
 plots,100,0,color=5,/continue
 xyouts, 80,0.5,'TM',color=2,charsize=2
 xyouts,60,0.4,'TE' ,color=2,charsize=2
 xyouts,20,0.2,'n=1.5',color=2,charsize=2
 stop
 write_bmp,'g:\rsi\test\transM.bmp',tvrd()

 end