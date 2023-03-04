pro wavelet_lidarBW;­º¥ýcompile wavelet
;black-white display Rayleigh lidar
    close,/all
   ntime = 918
  dT_data=fltarr(2,ntime)
   ;openr,1,'d:\rsi\test\sunspot.txt'
   openr,1,'d:\rsi\wavelet\20010116C.txt'
   readf,1,dT_data
   y=transpose(dT_data(1,*))
   dt=1.0
   range=dt_data(0,*)
  dx=(dt_data(0,917)-dt_data(0,0))/918

  plot,y
  stop
   wave = WAVELET(y,dt,PERIOD=period,COI=coi,/PAD,SIGNIF=signif)

     nscale = N_ELEMENTS(period)
      LOADCT,39
      CONTOUR,ABS(wave)^2,range,period, $
       XSTYLE=1,XTITLE='Time',YTITLE='Period',TITLE='Noise Wavelet', $
       YRANGE=[MAX(period),MIN(period)], $   ;*** Large-->Small period
       /YTYPE, $                             ;*** make y-axis logarithmic
       NLEVELS=25,/FILL
;
stop
 signif = REBIN(TRANSPOSE(signif),ntime,nscale)
 CONTOUR,ABS(wave)^2/signif,range,period, $
       /OVERPLOT,LEVEL=1.0,C_ANNOT='95%'
 PLOTS,range,coi,NOCLIP=0;background=-2, color=2   ;*** anything "below" this line is dubious
 close,1
stop

end