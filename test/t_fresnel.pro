pro T_Fresnel
;transmitte light for Fresnel reflection

;read,x, prompt='Input angle of incidence in degree:'
 n=1.5

 x=findgen(90)
 x=56.3
 theta=x*3.1416/180

 ;rs= ((cos(theta)-r2)/(cos(theta)+r2))
 ;rp=(((-n^2)*cos(theta)+r2)/((n^2)*cos(theta)+r2))
  Q2=2*theta  ;theta incident angle
  P2=2*Asin(sin(theta)/n);  refraction angle
 Top=sin(Q2)*sin(P2)/((sin(p2/2.+q2/2.))^2*(cos(Q2/2.-p2/2.))^2)    ;(cos(theta)/(cos(theta)+r2)
 Tos=sin(Q2)*sin(P2)/(sin(p2/2+q2/2))^2
 Rop=tan((q2/2-p2/2)^2)/(tan(q2/2+p2/2)^2)
 Ros=sin((q2/2-p2/2))^2/(sin(q2/2+p2/2))^2
 ;tp=2*n*cos(theta)/((n^2)*cos(theta)+r2)
 ;T=rs^2+rp^2+ts^2+tp^2
 ; print,x,rs,rp,ts,tp,T
 print,'transmitted',Tos,top,Tos+Top
 print,'reflection',Ros,Rop,Tos+Rop
 nt=findgen(15)
 xos=tos^nt
 xop=top^nt
 plot,nt,xop,background=-2,color=2
stop
 oplot,nt,xos,color=2
 ; for the second interface
 ; Internal n=1/1.5
  n=1/1.5
  xx=90.-56.3
  theta=xx*3.1416/180


  Q2=2*theta  ;theta incident angle
  P2=2*Asin(sin(theta)/n);  refraction angle
 Top2=sin(Q2)*sin(P2)/((sin(p2/2.+q2/2.))^2*(cos(Q2/2.-p2/2.))^2)    ;(cos(theta)/(cos(theta)+r2)
 Tos2=sin(Q2)*sin(P2)/(sin(p2/2+q2/2))^2
 Rop2=tan((q2/2-p2/2)^2)/(tan(q2/2+p2/2)^2)
 Ros2=sin((q2/2-p2/2))^2/(sin(q2/2+p2/2))^2

 print,'absolute transmitted',Tos2,top2,Tos2+Top2
 print,'corrected transmission',TOS*Tos2,TOP*top2,TOS*Tos2+Top*Top2
 print,'absolute reflection',Ros,Rop,Tos+Rop
  print,'corrected reflection',TOS*Ros,TOP*Rop,TOS*Tos+Top*Rop


 t=findgen(15)
 xos=tos^nt
 xop=top^nt
 plot,nt,xop,background=-2,color=2
stop
 oplot,nt,xos,color=2


 stop
 end



