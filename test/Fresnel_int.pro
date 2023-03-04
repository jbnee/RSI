Pro Fresnel_int
;;set_plot, 'ps'
;;device, filename='E:\RSI\TEST\Brewster.ps'
 theta=findgen(90)*!pi/180
 x=theta*180/!pi
 n=1.5
 r2=sqrt(n^2-sin(theta)^2)
 rs= ((cos(theta)-r2)/(cos(theta)+r2))
 rp=(((-n^2)*cos(theta)+r2)/((n^2)*cos(theta)+r2))
 plot,x,rs, background=-2, color=2,xrange=[0,90], yrange=[-1,1],$
 ;title='External Reflection', xtitle='Angle of incidence (degree)',ytitle='Reflection: s&p'
 title='Internal Reflection n= 1.5', xtitle='Angle of incidence (degree)',ytitle='Reflection: s&p'

  oplot,x,rp, color=4

  plots,41,-1
  plots,41,1,color=2,/continue
  AXIS, 0,0,color=2,xticks=3, xtickv=[20,40,60,80]; for central axis
 ;Axis,41,0,color=2,Yax=0
   xyouts,15,-0.2,'Brewster Angle',color=1
   xyouts,45,0.5,color=2,'Critical angle'
  ;xyouts,60,-0.65,'TE:s',charsize=2,color=2
  ;xyouts,65,0.5,'TM:p',charsize=2,color=5
   xyouts,60,0.25,'TE:s',charsize=2,color=2
   xyouts,65,-0.5,'TM:p',charsize=2,color=5
 stop
;; device,/close_file
 ;;set_plot,'win'
 ;Image must be transpose/rotate to write_tiff as follows;
  img1=transpose(tvrd())
  img2=rotate(img1,3)
  ;write_TIFF,'E:\RSI\TEST\Fresnel_intB.tif',img2
 end