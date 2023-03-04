pro O3_Lomb ;and Lomb_scarle periodogram
!p.multi=[0,1,1]
; Open the file test.lis:

   close,/all
   path1='E:\rsi\My_wavelet\'
;filex=path1+'Rsounding90_2008_12Z.txt'
filex=path1+'O3_100mb_90_10.txt'
;filex=path1+'longwv_1990_2008.txt'
openr,1,filex

; Define a string variable:

A=read_ascii(filex)
B=A.(0)
;1990-1998:0:108
;1999-2008:109:251
T1=108;   3248
T2=252;   6848
sB=size(B[1,*])
nB=sB[2]
 yr=B[0,*]
O3=B[1,*]
;Temp=B[2,]
close,1
;A = ''
; Loop until EOF is found:
plot,O3,color=2,background=-2
stop
; Close the file:

sfft=fft(O3)
;
CLOSE, 1
s=size(sfft)
n1=s[2]/2
freq1=findgen(n1)
power=abs(sfft(0:n1))^2;
power=power[1:n1]
nyquist=1./2
nf=findgen(nB)
freq1=nyquist*nf/n1
plot,freq1,power; periodogram in frequency
stop

P=1/freq1  ; change to Period
YP=P/365.
plot,P,power,xrange=[0,50], xtitle='month',ytitle='Power',color=2,background=-2,title='fft',$
position=plot_position1
maxp=where(power eq max(power))
print,maxp,power(maxp),p(maxp)
stop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;Lomb_Scagle;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Cose the file:
!p.multi=[0,1,2]
plot_position1 = [0.1,0.15,0.90,0.49];
plot_position2 = [0.1,0.6,0.90,0.95]


;n1=indgen(108);size(O3)
x1=indgen(108); transpose(O3)
y1=O3[0:T1-1]
lomb_Sg= LNP_TEST(x1, y1, WK1 = freq, WK2 = amp, JMAX = jmax)

;plot,freq,amp, color=2,background=-2; periodogram in frequency
P1=1/freq  ; change to Period

plot,p1,amp,xrange=[0,50],color=2,background=-2,ytitle='Amplitude',title='Lomb-period 1 ',$
position=plot_position1

print,JMAX, P1(Jmax)  ; index of Peak period
JQBO=max(amp)
Pmax=where(amp eq JQBO)
print,'QBO:',Pmax,JQBO
stop

;n2=indgen(144)+108;size(O3)
x2=indgen(144); transpose(O3)
y2=O3[T1:T2-1]
lomb_Sg= LNP_TEST(x2, y2, WK1 = freq, WK2 = amp, JMAX = jmax)


P1=1/freq  ; change to Period

plot,p1,amp,xrange=[0,50],color=2,background=-2,ytitle='Amplitude',title='Lomb-period 2',$
position=plot_position2

print,JMAX, P1(Jmax)  ; index of Peak period
JQBO=max(amp)
Pmax=where(amp eq JQBO)
print,'QBO:',Pmax,JQBO
stop



outf2=path1+'Lomb_output\Lomb_Sca_O3.bmp'
openw,2,outf2
write_bmp,outf2,tvrd()
close,2
stop
erase
end




