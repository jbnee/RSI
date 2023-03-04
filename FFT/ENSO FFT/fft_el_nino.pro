pro fft_El_nino ;and Lomb_scarle periodogram
; Open the file test.lis:
close,/all
;f1='f:\climate\AverageElninoIndex.txt'
;f1='E:\climate\EL_Nino\MonthlyEL.txt';  Averageelninoindex.txt'
f1='E:\Airglow\5.5year\Mei_index.txt'
; Define a string variable:
;X=read_ascii(f1)
;A1=X.(0)
;A=A1[*,1:68]
A=fltarr(13,68)
openr,1,f1
line=''
readf,1,line
print,line
readf,1,A
close,1
yr=A[0,*]
MEIx=A[1:12,*]
Ix=size(MEIx)
Icol=Ix[2]   ; 68
Iraw=Ix[1]   ;12
N0=Icol*Iraw
N=indgen(N0)
MEI=fltarr(N0)
y=FLTARR(n0)
Y=FLTARR(N0)

;;;;;這裡必須將12進 位改為10進位 才能畫圖;;;;;;;;;;
 ;C1=findgen(9)/10.0+0.1
; C2=[.10,.11,.12]
 ;C=[C1,C2]
 f=0.8;100/120.;


for Ic=0,Icol-1 do begin  ;0 to 68

    Ix=12*Ic
    MEI[Ix:Ix+11]=Meix[*,Ic]
  ;;;define year below


endfor
k=0
FOR Ia=0,N0-1,12 DO BEGIN

  Y[Ia:Ia+11]=1950.+ K+f*(1+findgen(12))/10.0; +K+C
  k=k+1
ENDFOR
stop

!P.MULTI = [0, 1, 1]
;;
;xtick=[1950,1970,1990,2010,2020]
plot,y,MEI,psym=0,color=90,background=-2,TITLE='Mei index'
;xtickname=xtick,
stop

MEI_A=fltarr(2,N0)
Mei_A[0,*]=y
Mei_A[1,*]=Mei

f1='E:\Airglow\5.5year\ENSO_Mei.txt'
;write_bmp,fil1,tvrd()
openw,1, f1
printf,1,Mei_A
close,1

stop

x=transpose(yr)
;y=transpose(index)

sfft=fft(MEI)

   ;lomb_Sg= LNP_TEST(x, y, WK1 = freq, WK2 = amp, JMAX = jmax)

s=size(sfft)
n1=s[1]/2
freq=findgen(n1)
power=abs(sfft(0:n1))^2;
nyquist=1./2
freq=nyquist*N/n1
plot,freq,power,xrange=[0,0.1],color=2,background=-2
stop
T=1/freq  ; change to Period
Pav=smooth(power,2)
!P.MULTI = [0, 1, 2]
plot_position1 = [0.1,0.15,0.98,0.49]
plot_position2 = [0.1,0.6,0.98,0.94];

plot,T/12,POWER,xrange=[0,20],xtitle='year',ytitle='Power',color=2,background=-2,position=plot_position1
oplot,T/12,smooth(power,5),color=90
Plot,T/12,POWER,xrange=[0,100],ytitle='power',position=plot_position2,color=2,background=-2

stop
;fil2='f:\climate\el_nino\Power_MEl_FFT.bmp'
;write_bmp,fil2,tvrd()
stop
end


