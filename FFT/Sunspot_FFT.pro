pro Sunspot_FFT ;and Lomb_scarle periodogram
; Open the file test.lis
erase
close,/all
filex='E:\rsi\fft\sunspot2011.txt'
openr,1,filex

; Define a string variable:

A=read_ascii(filex)
B=A.(0)
sB=size(B)
nSpot=sB[2]
 yr=B[0,*]
spot=B[1,*]; #288
;A = ''
; Loop until EOF is found:
;i=0
;readf,1,x  ;read a line of text
plot,yr,spot,xtitle='year',color=2,background=-2
stop
; Close the file:
;x=transpose(yr)
;y=transpose(spot)
Y=fft(spot)
Y1=real_part(Y)
Y2=imaginary(Y)
plot,Y1,Y2,color=2,background=-2,psym=4,xrange=[-2,2],yrange=[-2,2],xtitle='Real',ytitle='imaginary'
nY=n_elements(Y)/2;312;;288
print,'# of Y:',ny;  312; 288
stop



power1=2*abs(Y)^2; choose 1/2 of Y or 144 elements
power=power1[1:(ny)-1];;remove Y[0] the DC part
plot,power
stop
nyquist=1./2
; set frequency, remove 0 freq and normalize .
freq=(findgen(nY)/nY)*nyquist  ; 144 elements
F1=freq(1:NY-1)  ;;; 143 eleyments
;F2=(indgen(nY.)+1)/(Ny; No Nyquist factor *0.5
;;
plot,freq,power,color=20,background=-2 ; periodogram in frequency
stop
T=1/F1 ;Period, change to Period 143 elements, range from 288 -:2.0
plot,T,power,xrange=[0,120], xtitle='year',ytitle='Power',color=2,background=-2,$
title='Compare adding or no Nyquist factor, bk:with Nyquist'

;print,JMAX, T(Jmax)  ; index of Peak period
stop
end



;stop
