pro wavelet_sunspot_contr
device, decomposed=0

rgb = bytarr(3,256)
openr,2,'d:\rsi\hues.dat'
readf,2,rgb
close,2
free_lun,2
r=bytarr(256)
g = r
b = r
r(0:255) = rgb(0,0:255)
g(0:255) = rgb(1,0:255)
b(0:255) = rgb(2,0:255)
tvlct,r,g,b
!P.BACKGROUND= 1 ; 0 = black, 1 = white
!P.COLOR=2 ;blue labels

;col = 240 ; don't change it
;cmax=200
;cmin=5
;nlevs_max=20
;nlevs_max = 20 ; choose what you think is right
 ;cint = (cmax-cmin)/nlevs_max
 ;CLEVS = CMIN + FINDGEN(NLEVS_MAX+1)*CINT
 ;CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
 ;clevs0 = clevs ; for plot the color bar


   close,/all
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;input data;;;;;;;;;;;;;;;
  ntime = 288
  sundata=fltarr(2,ntime)

  fpath='d:\rsi\test\'  ;sun_spot.txt'
  datanm='sun_spot.txt'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   openr,1,'d:\rsi\test\sun_spot.txt'
   readf,1,sundata
   y=transpose(sundata(1,*))
      ;y=sundata(1,*)
  ; y = RANDOMN(s,ntime)       ;*** create a random time series
  ; dt = 0.25
   dt=1.0
  time = FINDGEN(ntime)*dt+1700. ;*** create the time index
  ;plot,y,background=-2, color=2
  stop
   wave = WAVELET(y,dt,PERIOD=period,COI=coi,/PAD,SIGNIF=signif)

     nscale = N_ELEMENTS(period)
      ;LOADCT,10

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
 PLOTS,time,coi,NOCLIP=0;     ;*** anything "below" this line is dubious
 close,1
stop
DEVICE, GET_DECOMPOSED=old_decomposed
DEVICE, DECOMPOSED=0
 read,outname,prompt='output filename:??  '
 ;cntrname =bpath+'contour\'+dnm+'.png'
WRITE_PNG, cntrname, TVRD(/TRUE)
end