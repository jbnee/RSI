Pro FFT_test2
erase
N=600.; data point
;Sm=800.

t=(findgen(N)+1)/N;
;x=findgen(Ns)
f=80;
X=1.0*sin(2*3.14*80*t);+1.0*sin(2*3.14*80*x);
!p.multi=[0,1,2]
plot,t*N,X
stop
YF=FFT(X)
nY=n_elements(YF)
YF=YF[1:nY-1];
stop
Power=2*abs(YF[0:NY/2])^2


;Power=Power[1:nY/2-1];

nyquist=0.5
freq=(findgen(nY/2.0)/(nY/2))*nyquist;
;xf=freq[1:nY/2-1]
!p.multi=[0,1,2]

plot,freq,Power,color=2,background=-2,xtitle='freq';xrange=[0,100]
Period=1./freq;
plot,period,Power,color=2,background=-2,xrange=[0,100],xtitle='Period'
stop
end
