pro wavelet_test
loadct,39
  ntime = 256
 y = RANDOMN(s,ntime)       ;*** create a random time series
 dt = 0.25
 time = FINDGEN(ntime)*dt   ;*** create the time index
stop
 wave = WAVELET(y,dt,PERIOD=period,COI=coi,/PAD,SIGNIF=signif)
     nscale = N_ELEMENTS(period)
      LOADCT,10
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