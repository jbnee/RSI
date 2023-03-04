Pro Fresnel_test
;read,x, prompt='Input angle of incidence in degree:'
 n=1.5
;For i=10,90,10 do begin
;For i=50,60   do begin
 x=findgen(90)
 theta=x*3.1416/180

 r2=sqrt(n^2-sin(theta)^2)
 rs= ((cos(theta)-r2)/(cos(theta)+r2))
 rp=(((-n^2)*cos(theta)+r2)/((n^2)*cos(theta)+r2))
 ts=2*cos(theta)/(cos(theta)+r2)
 tp=2*n*cos(theta)/((n^2)*cos(theta)+r2)
 T=rs^2+rp^2+ts^2+tp^2
 ; print,x,rs,rp,ts,tp,T


 plots,1,0
 plots,100,0,color=5,/continue

plot,x,rs,background=-2, color=2,yrange=[-1,1],linestyle=0
oplot,x,rp,color=1,linestyle=1
stop
oplot,x,ts,color=1,linestyle=3
oplot,x,tp,color=4,linestyle=4
plots,1,0
plots,100,0,color=5,/continue
stop
oplot,x,rs^2+ts^2, color=1,linestyle=1
oplot,x,rp^2+tp^2,color=1, linestyle=6

 stop
 end
