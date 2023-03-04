Pro FFT_example
erase
!p.multi=[0,1,1];
loadct,30
L = 1500.        ;    % Length of signal
Fs = 500.0;            % Sampling frequency
PS = 1./Fs;
t1 = indgen(L)*PS;        % Time vector

S1 = 0.7*sin(2*!pi*50*t1/5) + sin(2*!pi*120*t1/5);
plot,t1,S1,color=2,psym=4,background=-2,title='t,S:',xrange=[0,1]
oplot,t1,s1, color=2
stop

L2=300;
t2=indgen(L2)*PS*5
S2= 0.7*sin(2*!pi*50*t2) + sin(2*!pi*120*t2);
L3=100
  t3=indgen(L3)*PS*15
S3 = 0.7*sin(2*!pi*50*t3) + sin(2*!pi*120*t3);
oplot,t2,S2,color=25,psym=6,symsize=1.3;,background=-2,title='t3,S3:'
oplot,t2,S2,color=25
oplot,t3,S3,color=190,psym=2
oplot,t3,S3,color=190
; oplot,t2,S3,color=120,psym=6,symsize=1.3
stop

erase
!p.multi=[0,1,2]
nf=indgen((L)/2)


Y0 = fft(S1);
Power2 = abs(Y0/L);
;P1 = P2(1:L/2+1);
P10=Power2[0:(L-1)/2+1]
NP=n_elements(P10)
P10[2:np-2] = 2*P10[2:np-2];
nyquist=1./2; % max freq
freq1 = Fs*(nf)/L/2 *nyquist;

window,1
plot,P10,color=2,background=-2,title='P10',xtitle='freq*100'
oplot,freq1*100,P10,color=200;xtitle='f (Hz)',ytitle='|P10|'
peri1=1/freq1
;plot,freq1,P10,color=2,background=-2,title="frequency'
stop
plot,peri1,P10,color=12,background=-2,xtitle='Period'


window,0
;;;;%%%   FFT of X%%%%%%%%%%%

!p.multi=[0,1,2]
Y2=fft(S2);
Power1=abs(Y2/L2);

P2 = Power1[0:(L2-1)/2];

N2=n_elements(P2)
NX2=indgen(N2)
P2[1:N2-1] = 2*P2[1:n2-1];
freq2 =Fs*(NX2)/L2/2 *nyquist;

plot,freq2,P2,color=60,background=-2
peri2=1./freq2
plot,peri2,P2,color=2,background=-2

;;%%%  Now take the FFt of the original uncouple signal and tretrieve the exact amplitudes, 0.7 and 1.0

stop
end