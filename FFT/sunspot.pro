pro sunspot ;and Lomb_scarle periodogram
erase:
close,/all
;OPENR, 1, 'f:\rsi\My_wavelet\sunspot2011.txt'
; Open the file test.lis:
close,/all
filex='E:\rsi\FFT\sunspot2011.txt'
openr,1,filex

; Define a string variable:

A=read_ascii(filex)
B=A.(0)

nB=n_elements(B);  sB[2]
yr=B[0,*]
spot=B[1,*]
;A = ''
; Loop until EOF is found:
i=0
readf,1,x  ;read a line of text
plot,yr,spot,psym=0,xrange=[1700,2000],color=2,background=-2
stop
; Close the file:
x=transpose(yr)
y=transpose(spot)
sfft=fft(spot)
;lomb_Sg= LNP_TEST(x, y, WK1 = freq, WK2 = amp, JMAX = jmax)
CLOSE, 1
;s=size(sfft)
n1=n_elements(sfft)/2; s[2]/2
freq=findgen(n1)
power=abs(sfft(0:n1-1))^2;
power=power(1:n1/2)
nyquist=1./2
nf=findgen(nB)
freq=nyquist*nf/n1
freq=freq[1:n1/2]
plot,freq,power,xrange=[0,0.5] ; periodogram in frequency
stop
T=1/freq  ; change to Period
plot,T,power,xrange=[0,120], xtitle='year',ytitle='Power',color=2,background=-2

;print,JMAX, T(Jmax)  ; index of Peak period


stop
; Close the file:
x=transpose(yr)
y=transpose(spot)
lomb_Sg= LNP_TEST(x, y, WK1 = freq, WK2 = amp, JMAX = jmax)
CLOSE, 1
plot,freq,amp ; periodogram in frequency
T=1/freq  ; change to Period
plot,T,amp,xrange=[0,20];xrange=[0,200]; plot in T

print,JMAX, T(Jmax)  ; index of Peak period
stop
dt=1
wave = WAVELET(y,dt,PERIOD=period,COI=coi,/PAD,SIGNIF=signif)
     nscale = N_ELEMENTS(period)
      LOADCT,39
       CONTOUR,ABS(wave)^2,x,period, $
       XSTYLE=1,XTITLE='Time',YTITLE='Period',TITLE='Noise Wavelet', $
       YRANGE=[MAX(period),MIN(period)], $   ;*** Large-->Small period
       /YTYPE, $                             ;*** make y-axis logarithmic
       NLEVELS=25,/FILL
;
 signif = REBIN(TRANSPOSE(signif),ntime,nscale)
 CONTOUR,ABS(wave)^2/signif,time,period, $
       /OVERPLOT,LEVEL=1.0,C_ANNOT='95%'
 PLOTS,t,coi,NOCLIP=0;background=-2, color=2   ;*** anything "below" this line is dubious
stop



end



;stop
