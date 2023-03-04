Pro FFT_test1
erase
N=600.; data point
;Sm=800.

t=(findgen(N)+1)/N;
;x=findgen(Ns)
X=1.0*sin(2*3.14*80*t);+1.0*sin(2*3.14*80*x);
!p.multi=[0,1,2]
plot,t*N,X
stop
YF=FFT(X)
Power=2*abs(YF)^2

nY=n_elements(power)
Power=Power[1:nY/2-1];

nyquist=0.5
xf=(findgen(nY/2.0)/(nY/2))*nyquist;  *N
xf=xf[1:nY/2-1]
!p.multi=[0,1,2]

plot,xf,Power,color=2,background=-2,xtitle='freq';xrange=[0,100]
Period=1./xf
plot,period,Power,color=2,background=-2,xrange=[0,100],xtitle='Period'
stop
end
