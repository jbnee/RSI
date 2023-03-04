pro Taal_Lomb_Tanm ;and Lomb_scarle periodogram
; Open the file test.lis:
close,/all
erase
   close,/all
;Fdata='anmt_0208'
Fdata='TANM_0201_B'
path1='D:\radiosonde\Taal\'
filex=path1+Fdata+'.txt'
;filex='e:\radiosonde\TAAL\UV_anomaly.txt'
date1=strmid(filex,24,4);'0208'; strmid(filex,24,4);
print,date1
; Define a string variable:
line=''

A=read_ascii(filex)
ANMT=A.(0)
sB=size(ANMT[1,*])
nB=sB[2]

;select 3-10 km
 N1=8

Ni=transpose(indgen(nb-1))

km=ANMT[0,N1:NB-1]
Tanm=ANMT[1,N1:NB-1]
;Vanm=UVT[2,*]
;Tanm=UVT[3,*]

;ANM=[km,Uanm,Vanm,Tanm, Ni]
!p.multi=[0,1,1]



plot,TANM,km,color=2,background=-2,psym=4,xtitle='temperature anomaly',ytitle='km'
stop
; Close the file:

sfft=fft(TANM)
;lomb_Sg= LNP_TEST(x, y, WK1 = freq, WK2 = amp, JMAX = jmax)
CLOSE, 1
s=size(sfft)
n1=s[2]/2
freq=findgen(n1)
power=abs(sfft(0:n1))^2;
power=power[1:n1]
nyquist=1./2
nf=findgen(nb)
freq=nyquist*nf/n1
plot,freq,power,color=2,background=-2,xtitle='freq',ytitle='power',title='FFT'+date1
P=1/freq  ; change to Period
plot,P,power,xrange=[0,10], xtitle='km',ytitle='Power',color=2,background=-2,title=date1+'FFT Period'
stop
;dt=1.0
;;;;;;;;;;;;;;;;;;;;Lomb-Scargle test;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;U=transpose(Uanm)
;V=transpose(Vanm)
;Tm=transpose(Tanm)
;z=transpose(km)
;ANM=[Uanm,Vanm,Tanm]

!p.multi=[0,2,1]
;Lomb_p=fltarr(6,
;for j=0,2 do begin

; Close the file:
x=transpose(km)
y=transpose(Tanm)
;y=y0[i1:i2]
lomb_Sg= LNP_TEST(x, y,OFAC=16, WK1 = freq2, WK2 = ampx, JMAX = jmax)
;lomb_Sg=LNP_TEST(x,y,WK1=wk1,WK2=wk2,JMAX=jmax)

plot,freq2,ampx,color=2,background=-2,title='Lomb in freq'
;plot,wk1,wk2, color=2,background=-2;periodogram in frequency
T=1/freq2 ; change to Period
;T=1/wk1
;plot,wk1,wk2,color=2,background=-2
 plot,T,ampx,xrange=[0,10],color=2,background=-2,xtitle='Period,km',ytitle='power',title='Lomb-Scarle '+date1
print,JMAX, T(Jmax)  ; index of Peak period
;Lomb_P[j,

;endfor
stop
end




