pro Taal_Lomb ;and Lomb_scarle periodogram
; Open the file test.lis:
close,/all

   close,/all
path1='E:\radiosonde\Taal\'
filex=path1+'TUV_Anomaly_0208.txt'
;filex='e:\radiosonde\TAAL\UV_anomaly.txt'
date1='0208'; strmid(filex,24,4);
print,date1
; Define a string variable:
line=''

A=read_ascii(filex)
B=A.(0)
sB=size(B[1,*])
nB=sB[2]

openr,1,filex
readf,1,line
UVT=fltarr(4,nb-1)
while ~eof(1) do begin
readf,1,UVT
endwhile
stop
;ht=B[1,*]/1000.
Ni=transpose(indgen(nb-1))

km=UVT[0,*]
Uanm=UVT[1,*]
Vanm=UVT[2,*]
Tanm=UVT[3,*]

ANM=[km,Uanm,Vanm,Tanm, Ni]
!p.multi=[0,1,1]
plot,Uanm,Vanm,color=2,background=-2,psym=4,xrange=[-0.2,0.2]
i1=0;  6
i2=20;   21
for i=i1,i2 do begin
plots,Uanm[i],Vanm[i],color=2,psym=2;
print,i,km[i]
;wait,2
endfor
oplot,Uanm[i1:i2],Vanm[i1:i2],color=120,psym=6,symsize=1.5

stop
f=3.14*0.3
 t=findgen(17)*6.28/16
p=0.12*sin(t)
q=0.018*cos(t)
p1=p*cos(f)+q*sin(f)
q1=-p*sin(f)+q*cos(f)
oplot,p1,q1,color=2
stop

window,1



plot,TANM,km,color=2,background=-2,xtitle='temperature anomaly',ytitle='km'
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
ANM=[Uanm,Vanm,Tanm]

!p.multi=[0,2,1]
for j=0,2 do begin

; Close the file:
x=km[i1:i2]
y0=transpose(ANM[j,*])
y=y0[i1:i2]
lomb_Sg= LNP_TEST(x, y,OFAC=6, WK1 = freq2, WK2 = ampx, JMAX = jmax)
;lomb_Sg=LNP_TEST(x,y,WK1=wk1,WK2=wk2,JMAX=jmax)

plot,freq2,ampx,color=2,background=-2,title='Lomb in freq'
;plot,wk1,wk2, color=2,background=-2;periodogram in frequency
T=1/freq2 ; change to Period
;T=1/wk1
;plot,wk1,wk2,color=2,background=-2
 plot,T,ampx,xrange=[0,10],color=2,background=-2,xtitle='Period,km',ytitle='power',title='Lomb-Scarle '+date1
print,JMAX, T(Jmax)  ; index of Peak period
stop
endfor

stop
end




