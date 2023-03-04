Pro FFT_true_example
Fs=2500.;    %500;% 600.;% 2000,1000;  % Sampling frequency
T = 1/Fs;             % Sampling period
L = 1000;             % Length of signal
t=Indgen(L)*T;        % Time vector

S = sin(2*!pi*24*t) + 3*sin(2*!pi*70*t)+ 5*sin(2*!pi*160*t) + 10*sin(2*!pi*510*t);
seed=0.3
X = S + 0.5*randomu(seed);

;plot(1000*t(1:50),X(1:50))
plot,t,S,color=2,background=-2,psym=5,$
title='Signal Corrupted with Zero-Mean Random Noise',$
xtitle='t (milliseconds)', ytitle='X(t)'
oplot,t,X,color=90
oplot,t,S,color=120;
stop
;;;;%%%   FFT of X%%%%%%%%%%%
Yx=fft(X);
Px=abs(Yx/L);
P1 = Px[1:L/2];
nyquist=1/2; % max freq

P1 = 2*P1[1:L/2-1];
L1=size(P1);
freq = Fs*(findgen(L/2)/(L/2))*nyquist;
;%freq=Fs*((1:L/2)/L)*nyquist;
;%freq=Fs*(1:L/2)*nyquist;
window,1
!p.multi=[0,1,2]

plot,P1,color=2,background=-2,title='P1 Spectrum of X(t)',$
xtitle='f (Hz)', ytitle='|P1(f)|'

;;%%%  Now take the FFt of the original uncouple signal and tretrieve the exact amplitudes, 0.7 and 1.0

Ys= fft(S);
Ps = abs(Ys/L)^2;
Ps = Ps[0:L/2];
Ps(2:L/2-1) = 2*Ps(2:L/2-1);
;subplot (2,1,2)

plot,Ps,color=2,background=-2, xrange=[0,1000],title='P2 Spectrum of S(t)',$
xtitle='f (Hz)',ytitle='|P1(freq)|'
;axis([0 1000 0 15]);
;;'Single-Sided Amplitude Spectrum of X(t)',$
stop
end