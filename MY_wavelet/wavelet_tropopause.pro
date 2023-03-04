pro wavelet_tropopause
    close,/all
   ntime = 3607
  TPP=fltarr(3,ntime)
   openr,1,'d:\origin\data\tropopause_90_99_night.txt'
   readf,1,TPP
   y1=transpose(TPP(1,*))
   y2=transpose(TPP(2,*))
   ;y=sundata(1,*)
  ; y = RANDOMN(s,ntime)       ;*** create a random time series
  ; dt = 0.25
   dt=1.0
  time = FINDGEN(ntime)*dt  ;*** create the time index
  plot,y1
  stop
   wave1 = WAVELET(y1,dt,PERIOD=period,COI=coi,/PAD,SIGNIF=signif)
   wave2 = WAVELET(y2,dt,PERIOD=period,COI=coi,/PAD,SIGNIF=signif)
     nscale = N_ELEMENTS(period)
      LOADCT,39
       CONTOUR,ABS(wave1)^2,time,period, $
       XSTYLE=1,XTITLE='Time',YTITLE='Period',TITLE='Noise Wavelet', $
       YRANGE=[MAX(period),MIN(period)], $   ;*** Large-->Small period
       /YTYPE, $                             ;*** make y-axis logarithmic
       NLEVELS=25,/FILL
;
 signif = REBIN(TRANSPOSE(signif),ntime,nscale)
 CONTOUR,ABS(wave1)^2/signif,time,period, $
       /OVERPLOT,LEVEL=1.0,C_ANNOT='95%'
 PLOTS,time,coi,NOCLIP=0;background=-2, color=2   ;*** anything "below" this line is dubious
 close,1
stop
 CONTOUR,ABS(wave2)^2,time,period, $
       XSTYLE=1,XTITLE='Time',YTITLE='Period',TITLE='Noise Wavelet', $
       YRANGE=[MAX(period),MIN(period)], $   ;*** Large-->Small period
       /YTYPE, $                             ;*** make y-axis logarithmic
       NLEVELS=25,/FILL
;
 signif = REBIN(TRANSPOSE(signif),ntime,nscale)
 CONTOUR,ABS(wave2)^2/signif,time,period, $
       /OVERPLOT,LEVEL=1.0,C_ANNOT='95%'
 PLOTS,time,coi,NOCLIP=0;background=-2, color=2   ;
end