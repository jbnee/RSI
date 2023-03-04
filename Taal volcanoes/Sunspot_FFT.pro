pro Sunspot_FFT ;and Lomb_scarle periodogram
; Open the file test.lis
erase
close,/all
filex='E:\rsi\test\sun_spot.txt'
openr,1,filex

; Define a string variable:

A=read_ascii(filex)
B=A.(0)
sB=size(B)
nSpot=sB[2]
 yr=B[0,*]*1000
spot=B[1,*]; #288
;A = ''
; Loop until EOF is found:
i=0
readf,1,x  ;read a line of text
plot,yr,spot,xrange=[1700,2000],color=2,background=-2
stop
; Close the file:
;x=transpose(yr)
;y=transpose(spot)
Y=fft(spot)
plot,Y,color=2,background=-2
nY=n_elements(Y)
print,'# of Y:',ny; 288
stop

;remove Y[0] the DC part

power=2*abs(Y(1:(nY)/2))^2; choose 1/2 of Y



nyquist=1./2
; set frequency, remove 0 freq and normalize .
freq=((findgen(nY/2.0)+1)/(ny/2))*nyquist



plot,freq,power,color=20,background=-2 ; periodogram in frequency
stop
T=1/freq  ; change to Period
plot,T,power,xrange=[0,120], xtitle='year',ytitle='Power',color=2,background=-2

;print,JMAX, T(Jmax)  ; index of Peak period
stop
end



;stop
