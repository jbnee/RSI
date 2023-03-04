Pro wvlet_test
ntime = 256; pick a nice number of points
t=findgen(ntime)+1
Y=sin(2*3.14*t/12.) +sin(2*3.14*t/24.)
dt=1.0
 time = FINDGEN(ntime)*dt   ;***

plot,t,Y,color=2,background=-2
stop
yfft=fft(y,-1);,/OVERWRITE)
;yfft[0]=0;   cut the 0th element
power_yfft=abs(yfft)
plot,t,power_yfft,xrange=[0,ntime/2.],color=2,background=-2,title='FFT of y'
stop
period=1/t
plot,period,power_yfft,xrange=[0,0.2],color=2,background=-2


stop



wave = WAVELET(y,dt,PERIOD=period,COI=coi,/PAD,SIGNIF=signif)
     nscale = N_ELEMENTS(period)
      LOADCT,39
       CONTOUR,ABS(wave)^2,time,period, $
       XSTYLE=1,XTITLE='Time',YTITLE='Period',TITLE='Noise Wavelet', $
       YRANGE=[MAX(period),MIN(period)], $   ;*** Large-->Small period
       /YTYPE, $                             ;*** make y-axis logarithmic
       NLEVELS=25,/FILL
;    IDL>
 signif = REBIN(TRANSPOSE(signif),ntime,nscale)
 CONTOUR,ABS(wave)^2/signif,time,period, $
       /OVERPLOT,LEVEL=1.0,C_ANNOT='95%'
 PLOTS,time,coi,NOCLIP=0;background=-2, color=2   ;*** anything "below" this line is dubious
stop

end


