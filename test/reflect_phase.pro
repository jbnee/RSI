Pro Reflect_phase


 n= 1.5

 ;phi=asin((sin(theta)/n))
 xt=findgen(90) ;angle in degree
 theta=xt*!pi/180  ;convert to radian
 ;s1=sin(theta)^2-n^2

 r=sqrt(sin(theta)^2-n^2)
 y_TE=2*atan(r/cos(theta))*180/!pi ;phase change for TE wv
 Y_TM=2*atan(r/(n^2*cos(theta)))*180/!pi   ;phase change for TM wv
 ;if (s1 lt 0) then begin
 Y_TM[0:33]=180.
 Y_TM[34:41]=0.
 Y_TE[0:41]=0.0
 plot,xt,y_TE, background=-2, color=2,xrange=[30,90], xtitle='Incident Angle (degree)',ytitle='Phase delta (degree)'
 ;if (s1 lt 0) then begin
 ;y_TM=180
 ;endif
 oplot,xt,y_TM, color=2,linestyle=3
 y_TEM=(cos(theta)*r)/(sin(theta)^2)
 delta=2*atan(y_TEM)*180/!pi
  y=delta
 oplot,xt,y,  color=2;xrange=[30,90], yrange=[0,50],xtitle='Incident Angle (degree)',ytitle='Phase delta (degree)'
  ;oplot,xt,rp^2, color=4,linestyle=3
  ;stop
  xyouts, 60,150,'TM',color=2,charsize=2
  xyouts,70,80,"TE",color=2,charsize=2
  xyouts,80,30,'TM-TE',color=2,charsize=2
 ; write_bmp,'g:\rsi\test\Phase_TEM.bmp',tvrd()
stop
 end