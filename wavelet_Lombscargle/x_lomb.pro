pro X_Lomb ;and Lomb_scarle periodogram
; Open the file test.lis:
close,/all
!p.multi=[0,1,1]

path1='f:\rsi\my_wavelet\'
   close,/all
 filex=path1+'Merra_SO4.txt'
;filex='f:\rsi\My_wavelet\longwv_1990_2008.txt'
;filex='f:\rsi\My_wavelet\R_sound1990_2008.txt'
openr,1,filex

; Define a string variable:

A=read_ascii(filex)
B=A.(0)
sB=size(B[1,*])
nB=sB[2]
Tm=findgen(nB)
yr=B[0,*]
X=B[1,* ]
close,1

;A = ''
; Loop until EOF is found:
plot,Tm,X,color=2,background=-2,xtitle='month',ytitle='X',title=filex
stop
; Close the file:
X=x[25:312]
sfft=fft(X)
;lomb_Sg= LNP_TEST(x, y, WK1 = freq, WK2 = amp, JMAX = jmax)
;Xfft=imaginary(sfft)
s=size(sfft)
n1=s[1]/2
freq=findgen(n1)
power=abs(sfft(0:n1))^2;
plot,power
stop
power=power[2:n1]
a=max(power)
nyquist=1./2
nf=findgen(nB-1)+1
freq=nyquist*nf/n1
plot,freq,power; periodogram in frequency
stop
P=1./freq  ; change to Period
plot,P-1,power,xrange=[0,30],yrange=[0,a], xtitle='month',ytitle='Power',color=2,background=-2
stop
outf1=path1+'Lomb_output\SO4.bmp'
openw,1,outf1
write_bmp,outf1,tvrd()
close,1
erase
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Lomb;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;x=transpose(T)

;!p.multi=[0,1,2]
;plot_position1 = [0.1,0.15,0.90,0.49];
;plot_position2 = [0.1,0.6,0.90,0.95]


;y=transpose(X)
tm=tm[25:312]
lomb_Sg= LNP_TEST(Tm, x, WK1 = freq, WK2 = amp, JMAX = jmax)
CLOSE, 1
plot,freq,amp ; periodogram in frequency
Pr=1/freq  ; change to Period
stop
a=max(amp)
plot,pr,amp,xrange=[0,100],yrange=[0,a/2],color=2,background=-2,xtitle='month',ytitle='X ',$
title='Lomb Merra SO4'

print,JMAX, Pr(Jmax)  ; index of Peak period
stop
outf2=path1+'Lomb_output\Lomb_ScaSO4.bmp'
openw,2,outf2
write_bmp,outf2,tvrd()
close,2
erase
stop


end




