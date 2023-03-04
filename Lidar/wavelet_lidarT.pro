pro wavelet_lidarT
;­º¥ýcompile wavelet
    close,/all
   ntime = 61;  915
  Tdata=fltarr(2,ntime)

;openr,1,'c:\Users\jinq\Google Drive\IDL programs\Tav_ja16.txt';'c:\rsi\temp\Tav_ja16.txt'
   ;openr,1,'d:\rsi\test\sunspot.txt'
   openr,1,'c:\JB\T_se0397.txt'
   readf,1,Tdata
   y=transpose(Tdata(1,*))
      ;y=sundata(1,*)
  ; y = RANDOMN(s,ntime)       ;*** create a random time series
  ; dt = 0.25
   dt=1.0;30
  time = FINDGEN(ntime)/dt ;*** create the time index
  plot,y
  stop
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

end