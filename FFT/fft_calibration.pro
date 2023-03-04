Pro FFT_calibration
erase;

L = 1500.0;1500    % #of data
t=findgen(L) ;total time #1500 in 0.001 sec
nt=n_elements(t);
;;;Length.1500 data
S = 2*sin(2*!pi*50*t) ;+ sin(2*!pi*120*t);
SEED=0.5
X = S + 0.2*RANDOMU(SEED,size(t)); size 1500

nX=n_elements(X); Sample length
It=findgen(nX);/nX
plot,It,X,color=-60,background=-2;xrange=[0,100]
STOP
oplot,t,10*s,color=90,psym=4
;
stop
nIt=n_elements(It)
print,'nt & nx,It:',nt,nx,nIt

;stop
;;;;%%%   FFT of X%%%%%%%%%%%
Y=fft(X);  £» #x:==L(1500)  ;Y:1500
LY=n_elements(Y);500
Pow=abs(Y/LY); Power:remove DC at Y[0] P2 length 499
Pow1=Pow(1:LY/2-1);
endx=LY/2-1.;
POW1(1:endx-1)=2*POW1(1:endx-1); power=double intensity
;stop

 nyquist=0.5; max freq
;NF=indgen(NP)+1  ; # =1,2,3,..,250
freq =nyquist*(findgen(LY/2)/(LY/2)) ;  #500
freq=freq(1:LY/2-1);
!p.multi=[0,1,2]
;amp=max(power)
plot,freq,POW1,color=60,background=-2,xtitle='frequency ',xrange=[0,0.1]
;title('Single-Sided Amplitude Spectrum of X(t)')
Peri=1/freq;  ;ylabel('|power(f)|')
;XFreq=freq[1:NP/2-1]
peri=1/freq;
plot,peri,POW1,color=2,background=-2,xtitle='Period',XRANGE=[0,200]
stop
;;%%%  Now take the FFt of the original uncouple signal and tretrieve the exact amplitudes, 0.7 and 1.0
;title='|power(freq)|'
stop
end