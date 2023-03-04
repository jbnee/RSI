Pro FFT_example2
erase;
Fs=2000;3000;
L = 1500.0;1500    % #of data
t=findgen(L)/Fs ;total time #1500 in 0.001 sec
nt=n_elements(t);
;;;Length.1500 data, measured at 001 0 s interval, elapse 1.5 sec
S = 0.7*sin(2*!pi*50*t) + sin(2*!pi*120*t);
;SEED=0.5
X = S + 2*RANDOMU(SEED,size(t)); size 1500
plot,1000*t,S,color=2,background=-2;,xrange=[0,1]
stop

PS = 1./Fs;             % Sampling period


;X=rebin(S,Fs); sampling 1500 pts
nX=n_elements(X); Sample length
It=findgen(nX)/nX
plot,It,X,color=2,background=-2;xrange=[0,100]
oplot,t,s,color=90,psym=4
;
stop
nIt=n_elements(It)
print,'nt & nx,It:',nt,nx,nIt

;stop
;;;;%%%   FFT of X%%%%%%%%%%%
Y=fft(X);  £» #x:==L(1500)  ;Y:1500
LY=n_elements(Y);500
Po=abs(Y/L); Power:remove DC at Y[0] P2 length 499
P1=Po(1:L/2-1);
endx=L/2-1.;
P1(1:endx-1)=2*P1(1:endx-1); power=double intensity
;stop

 nyquist=0.5; max freq
;NF=indgen(NP)+1  ; # =1,2,3,..,250
freq = Fs*nyquist*(findgen(L/2)/(L/2)) ;  #500
freq=freq(1:L/2-1);
!p.multi=[0,1,2]
;amp=max(power)
plot,freq,P1,color=60,background=-2,xtitle='frequency ',xrange=[0,100]
;title('Single-Sided Amplitude Spectrum of X(t)')
Peri=1/freq;  ;ylabel('|power(f)|')
;XFreq=freq[1:NP/2-1]
peri=1/freq;
plot,peri,P1,color=2,background=-2,xrange=[0,1],xtitle='Period'
stop
;;%%%  Now take the FFt of the original uncouple signal and tretrieve the exact amplitudes, 0.7 and 1.0
;title='|power(freq)|'
stop
end