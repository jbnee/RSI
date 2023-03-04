pro tropopause_Lomb_Temperature_Ht
;and Lomb_scarle periodogram for two periods of 1990-2008
ERASE
!p.multi=[0,1,1]
; Open the file test.lis:
close,/all

   close,/all
   path1='f:\rsi\My_wavelet\'
filex=path1+'Rsounding90_2008_12Z.txt'
openr,1,filex

; Define a string variable:

A=read_ascii(filex)
B=A.(0)
;1990-1998:3248
;1999-2008:3249:6849
T1=3248
T2=6848
sB=size(B[1,*])
nB=sB[2]
 yr=B[0,*]
Q1=B[2,0:T1]  ;temperature period 1
Q2=B[2,T1:T2]  ;Temperature of peirod 2
R1=B[1,0:T1]/1000; ht in period 1
R2=B[1,T1:T2]/1000; period 2
close,1
;A = ''
; Loop until EOF is found:
plot,Q1,R1,yrange=[15,20],xrange=[-90,-70],color=2,background=-2,psym=3,symsize=4,$
ytitle='km',xtitle='temperature',$
title='CPT_radiosonde 1990-2008 25N,121E'
stop
oplot,Q2,R2,color=60,psym=3,symsize=4
stop
close,1; Close the file:

outf1=path1+'Lomb_output\Sp-Temp_HT.bmp'
openw,1,outf1
write_bmp,outf1,tvrd()


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;Lomb_Scagle;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
close,1; Cose the file:
!p.multi=[0,1,2]
plot_position1 = [0.1,0.15,0.90,0.49];
 plot_position2 = [0.1,0.6,0.90,0.95]


nx=size(R1)
ny=size(R2)
x1=findgen(nx[2])
x2=findgen(ny[2])
;y=findgen(ny[2])
y1=transpose(R1)
y2=transpose(R2)

;;;;;;;;;;;;;;;;;;;;temperature;;;;;;;;;;;;;;;;;;;;;;;

lomb_Sg= LNP_TEST(x1, y1, WK1 = freq, WK2 = amp, JMAX = jmax)


;plot,freq,amp, color=2,background=-2; periodogram in frequency
P1=1/freq  ; change to Period

plot,p1,amp,xrange=[0,5000],color=2,background=-2,ytitle='Amplitude',title='Lomb-Scarle Ht,90-98',$
position=plot_position2

print,JMAX, P1(Jmax)  ; index of Peak period
JQBO=max(amp[800:1200])
Pmax=where(amp eq JQBO)
print,'QBO:',Pmax,JQBO
stop
lomb_SgH= LNP_TEST(x2, y2, WK1 = freq, WK2 = amp, JMAX = jmax)
P1=1/freq  ; change to Period
stop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;height;;;;;;;;;;;;;;;;;;;
plot,p1,amp,xrange=[0,5000],color=2,background=-2,ytitle='Amplitude',title='Lomb-Scarle Ht,98-08',$
position=plot_position1

print,JMAX, P1(Jmax)  ; index of Peak period
JQBO=max(amp[800:1200])
Pmax=where(amp eq JQBO)
print,'QBO:',Pmax,JQBO
stop
outf2=path1+'Lomb_output\Lomb_Scal9098H1_H2.bmp'
openw,2,outf2
write_bmp,outf2,tvrd()
close,2
erase
stop
end




