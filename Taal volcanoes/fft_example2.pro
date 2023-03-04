Pro FFT_example2
erase
Fs =1000.0; 1000.; % Sampling frequency
PS = 1./Fs;             % Sampling period
L = 1500.0;1500    % #of data
t=findgen(L)*PS ;total time #1500 in 0.001 sec

;;;Length.1500 data, measured at 001 0 s interval, elapse 1.5 sec
S = 0.7*sin(2*!pi*50*t) + sin(2*!pi*100*t);
SEED=0.5
X = S + 2*RANDOMU(SEED,size(t));
plot,t,x,color=2,background=-2
nx=n_elements(X)
nt=n_elements(t)
print,'nt & nx:',nt,nx
stop
;figure (1)
;plot,1000*t[0:49],X[0:49],xrange=[0,200], title='Signal Corrupted with Zero-Mean Random Noise',$
;plot,t,x,color=2,background=-2,xTITLE='t ',yTITLE='X(t)'
;stop
;;;;%%%   FFT of X%%%%%%%%%%%
Y=fft(X);  £» #x:==L(1500)  ;Y:1500
LY=n_elements(Y);1500
P2=abs(Y[1:LY-1]/L);remove DC at Y[0] P2:#1499
stop
P1 = P2[0:(Ly-1)/2]; #P1:750
stop
NP=n_elements(P1)  ;#750
P1[1:NP-1] = 2*P1[0:np-2];   only shift forward to 0,#750 o
stop
nyquist=0.5; max freq
NF=indgen(L/2)+1  ; # =1,2,3,..,750
freq = (NF/(L/2)) *nyquist;  #750
!p.multi=[0,1,2]
amp=max(P1)
plot,freq,P1/amp,color=60,background=-2
;title('Single-Sided Amplitude Spectrum of X(t)')
;xlabel('f (Hz)')
;ylabel('|P1(f)|')
stop
;;%%%  Now take the FFt of the original uncouple signal and tretrieve the exact amplitudes, 0.7 and 1.0
Y0 = fft(S);
P20 = abs(Y0/L);
;P1 = P2(1:L/2+1);
P10=P20[0:(L-1)/2+1]
P10[2:np-2] = 2*P10[2:np-2];
;amp=max(P10)
plot,freq,P10/amp,psym=4,color=2,xrange=[0,200],title='Single-Sided Amplitude Spectrum of S(t)',$
xtitle='f (Hz)',ytitle='|P1(freq)|'
stop
end