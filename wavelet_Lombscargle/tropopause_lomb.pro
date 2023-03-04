pro tropopause_Lomb ;and Lomb_scarle periodogram
ERASE
!p.multi=[0,1,1]
; Open the file test.lis:
close,/all

   close,/all
   path1='E:\rsi\wavelet_lombscargle\'
filex=path1+'AIRS_DATA.txt'
openr,1,filex

; Define a string variable:

A=read_ascii(filex)
B=A.(0)
;1990-1998:3248
;1999-2008:3249:6849

sB=size(B[1,*])
nB=sB[2]
 yr=B[0,*]
ht=B[1,1:nB-1]/1000.
Temp=B[3,1:nB-1]
close,1
;;;;;;;;;;;;;;;remove 9999
X9999=where(Temp lt 0)
temp[X9999]=temp[x9999+2]
Y9999=where(ht lt 0)
ht[y9999]=ht[y9999+2]
stop

;A = ''
; Loop until EOF is found:
plot,Temp,ht ,yrange=[15,18],xrange=[190,200],color=2,background=-2,psym=3,ytitle='km',xtitle='temperature',$
title='AIRS 2002_2016 TW region'
stop
close,1; Close the file:

outf1=path1+'Lomb_output\AIRS_TPP_02_16.bmp'
openw,1,outf1
write_bmp,outf1,tvrd()


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;Lomb_Scagle;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
close,1; Cose the file:
!p.multi=[0,1,2]
plot_position1 = [0.1,0.15,0.90,0.49];
 plot_position2 = [0.1,0.6,0.90,0.95]


nx=size(Ht)
ny=size(Temp)
x=findgen(nx[2])
y=findgen(ny[2])
yT=transpose(temp)
yH=transpose(Ht)

;;;;;;;;;;;;;;;;;;;;temperature;;;;;;;;;;;;;;;;;;;;;;;

lomb_Sg= LNP_TEST(x,yT, WK1 = freq, WK2 = amp, JMAX = jmax)


;plot,freq,amp, color=2,background=-2; periodogram in frequency
P1=1/freq[1:5071]  ; change to Period

plot,p1,amp,xrange=[0,5000],color=2,background=-2,ytitle='Amplitude',title='Lomb-Scarle T,02-16',$
position=plot_position2

print,JMAX, P1(Jmax)  ; index of Peak period
JQBO=max(amp[800:1200])
Pmax=where(amp eq JQBO)
print,'QBO:',Pmax,JQBO
stop
lomb_SgH= LNP_TEST(x, yH, WK1 = freq, WK2 = amp, JMAX = jmax)
P1=1/freq  ; change to Period
stop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;height;;;;;;;;;;;;;;;;;;;
plot,p1,amp,xrange=[0,5000],color=2,background=-2,ytitle='Amplitude',title='Lomb-Scarle H,AIRS',$
position=plot_position1

print,JMAX, P1(Jmax)  ; index of Peak period
JQBO=max(amp[800:1200])
Pmax=where(amp eq JQBO)
print,'QBO:',Pmax,JQBO
stop
outf2=path1+'Lomb_output\Lomb_ScaAIRS.bmp'
openw,2,outf2
write_bmp,outf2,tvrd()
close,2
erase
stop
end




