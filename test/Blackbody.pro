Pro blackbody
h=6.62E-34
k=1.38E-23
 c=3.E8
 T=6000.0

Lamda=fltarr(700)
IB=fltarr(700)
openw,1,'d:\temp\bbrad.txt'

For N=0,699 do begin
lamdanm=(N+300) ; nm.
lamda(N)=lamdanm*1.E-9 ; meters
nu=c/lamda(N)   ;frequency

   fR=(2*3.14)*(h*c^2/lamda(N)^5)
   Ib(N)=fR/(exp(h*nu/(k*T))-1)   ;intensity

 printf,1,lamdanm,IB(N)
 ;stop
 endfor
plot,lamda,IB

stop
close,1
end
