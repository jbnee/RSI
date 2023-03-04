Pro Fresnel_ext2
;;set_plot, 'ps'
;;device, filename='E:\RSI\TEST\Brewster.ps'
 x=findgen(91)
 theta=x*!pi/180
 n=1/1.5
  phi=asin(sin(theta)/n)
 xphi=phi*180/!pi
 ;rs=-sin(theta-phi)/sin(theta+phi)
 ;rp=-tan(theta-phi)/tan(theta+phi)
 ts=2*cos(theta)*sin(phi)/(sin(theta+phi))
 tp=2*cos(theta)*sin(phi)/(sin(theta+phi)*cos(theta-phi))

 r2=sqrt(n^2-sin(theta)^2)
 rs= ((cos(theta)-r2)/(cos(theta)+r2))
 rp=(((-n^2)*cos(theta)+r2)/((n^2)*cos(theta)+r2))
 plot,x,rs, background=-2, color=2,xrange=[0,90], yrange=[-1,1],$
 title='External Reflection', xtitle='Angle of incidence (degree)',ytitle='Reflection: s&p'
 ;title='Internal Reflection n=1.5', xtitle='Angle of incidence (degree)',ytitle='Reflection: s&p'
  trsm=(tp^2-ts^2)/(ts^2+tp^2)     ;transmitted light
  oplot,x,trsm,linestyle=1

 stop
  oplot,x,rp, color=4

  plots,41,-1
  plots,41,1,color=2,/continue
  AXIS, 0,0,color=2,xticks=3, xtickv=[20,40,60,80]; for central axis
 ;Axis,41,0,color=2,Yax=0
   xyouts,15,-0.2,'Brewster Angle',color=1
   ;xyouts,45,0.5,color=2,'Critical angle'
   xyouts,60,-0.65,'TE:s',charsize=2,color=2      ;external
   xyouts,65,0.5,'TM:p',charsize=2,color=5        ;external
  ;xyouts,60,0.25,'TE:s',charsize=2,color=2       ;internal case
  ; xyouts,65,-0.5,'TM:p',charsize=2,color=5      ;internal case
 stop
;; device,/close_file
 ;;set_plot,'win'
 ;Image must be transpose/rotate to write_tiff as follows;
  img1=transpose(tvrd())
  img2=rotate(img1,3)
  ;write_TIFF,'E:\RSI\TEST\Fresnel_intB.tif',img2
 end