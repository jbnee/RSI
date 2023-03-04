pro wavelet_sunspot;­º¥ýcompile wavelet
    close,/all
  ; ntime = 288
  ;sundata=fltarr(2,ntime)
  ; openr,1,'f:\rsi\test\sunspot.txt'
   ;openr,1,'d:\rsi\wavelet\20010116C.txt'
  ; readf,1,sundata
  ; y=transpose(sundata(1,*))
      ;y=sundata(1,*)
  ; y = RANDOMN(s,ntime)       ;*** create a random time series
  ; dt = 0.25
  ; dt=1.0
  ;time = FINDGEN(ntime)*dt+1700. ;*** create the time index
  ;plot,y
  ;stop
  close,/all
filex='f:\rsi\test\sun_spot.txt'
openr,1,filex

; Define a string variable:

A=read_ascii(filex)
B=A.(0)
sB=size(B)
nB=sB[2]
 yr=B[0,*]
y=B[1,*]
;A = ''
; Loop until EOF is found:
i=0
readf,1,x  ;read a line of text
plot,yr,y,psym=0,xrange=[1700,2000],color=2,background=-2
stop
; Close the file:
x=transpose(yr)
y=transpose(y)
sfft=fft(y)
;lomb_Sg= LNP_TEST(x, y, WK1 = freq, WK2 = amp, JMAX = jmax)
CLOSE, 1
s=size(sfft)
n1=s[1]/2
freq=findgen(n1)
power=abs(sfft(0:n1))^2;
nyquist=1./2
nf=findgen(nB)
freq=nyquist*nf/n1
plot,freq,power,yrange=[0,500] ; periodogram in frequency
stop
T=1/freq  ; change to Period
plot,T,power,xrange=[0,120], xtitle='year',ytitle='Power',color=2,background=-2

dt=1.0
ntime=nB
time= FINDGEN(ntime)*dt+1700. ;
   wave = WAVELET(y,dt,PERIOD=period,COI=coi,/PAD,SIGNIF=signif)

     nscale = N_ELEMENTS(period)
      LOADCT,39
      CONTOUR,ABS(wave)^2,time,period, $
       XSTYLE=1,XTITLE='Time',YTITLE='Period',TITLE='Noise Wavelet', $
       YRANGE=[MAX(period),MIN(period)], $   ;*** Large-->Small period
       /YTYPE, $                             ;*** make y-axis logarithmic
       NLEVELS=25,/FILL
;
stop
 signif = REBIN(TRANSPOSE(signif),ntime,nscale)
 CONTOUR,ABS(wave)^2/signif,time,period, $
       /OVERPLOT,LEVEL=1.0,C_ANNOT='95%'
 PLOTS,time,coi,NOCLIP=0;background=-2, color=2   ;*** anything "below" this line is dubious
 close,1
stop
;DEVICE, GET_DECOMPOSED=old_decomposed
;DEVICE, DECOMPOSED=0
; read,outname,prompt='  filename as:wvlt****.png" ??  '
 ;ntrname =fpath+'outname'+'.png'
;WRITE_PNG, outname, TVRD(/TRUE)
end