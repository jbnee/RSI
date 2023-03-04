Pro correlation_1
 ;;first generate a cloud function
 x=findgen(300);/300.
 y1=7*sin(x/5)
 a=y1[32:47]
 y2=fltarr(300)
 y2[0:299]=0


 y=fltarr(20,300)
 y[0,*]=y2
 plot,y[0,*],x,xrange=[0,200]
b=findgen(25)*10+50

 for i=0,19 do begin

 y[i,0:b[i]-5]=0
 y[i,b[i]+2:b[i]+17]=a*2


 y[i,b[i]+18:299]=0
 oplot,y[i,*]+i*5,x
 endfor
 stop
;;;part 2 calculate correlation
 correl_y=fltarr(20,300)
 correl_y[0,*]=y[0,*]*y[1,*]
 plot,correl_y[0,*]
 sumc=fltarr(300)
 sumc=correl_y[0,*]
for j=1,18 do begin

correl_y[j,*]=y[j,*]*y[j+1,*]
oplot,correl_y[j,*]
sumc=sumc+correl_y[j,*]
endfor
stop


plot,x,sumc
stop
yfft=fft(sumc)
yfft[0]=0
plot,abs(yfft[0:150])
 stop
 end
