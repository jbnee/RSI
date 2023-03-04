PRO fft_TEST;
erase
Np=10000.
X=findgen(Np)
PK=findgen(Np)/INDGEN(Np)-1

;for j=0,999 do begin
;seed1=ulong(j^2)
;PK[j]=PK[j]+0.5*randomu(seed1*j)
;PK=findgen(1000);
;endfor
;plot,PK
;stop
FOR N=0,Np-1,50 DO BEGIN
 pk[N]=25.
;seed2=ulong(sin(n))
;PK[N]=10.*RANDOMu(SEED2)^2
ENDFOR
PLOT,X,pk,title='PK function'
stop
erase
;;;********* FFT *********************
Y=fft(PK)

n1=n_elements(Y);
Y=Y[1:n1-1];
nyquist=0.5

freq = findgen(n1/2)/(n1/2)*nyquist;

freq=freq[1:(n1/2-1)];

power = abs(Y[0:floor(n/2)])^2;
;power=abs(Y(1:n1/2-1))^2;
nf=findgen(Np/2)


;stop
plot,freq,power,xrange=[0,1],color=2,background=-2,xtitle='frequency',title='frequency spectrum';
stop
T=1./freq  ; change to Period
plot,T,power,color=2,background=-2,xrange=[0,100], xtitle='#',title='Power in period';
;print,JMAX, T(Jmax)  ; index of Peak period


stop
; Close the file:
;x=transpose(X)
X=indgen(n1)

lomb_Sg= LNP_TEST(x, PK, WK1 = freq, WK2 = amp, JMAX = jmax)
CLOSE, 1
plot,freq,amp,color=2,background=-2 ; periodogram in frequency
T=1/freq  ; change to Period
plot,T,amp,color=2,background=-2,xrange=[0,30]



STOP

end