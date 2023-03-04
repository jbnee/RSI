pro wavelet_Rayleigh_Lidar
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
  ndt = 918  ; number of data
  dT_data=fltarr(2,ndt); dT data is the difference between
  ;lidar T and Radiosonde T

  fpath='d:\rsi\test\'  ;sun_spot.txt'
  datanm='Ja16dT_H.txt'
  finm=fpath+datanm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   openr,1,finm;   'd:\rsi\test\sun_spot.txt'
   readf,1,dT_data
   y=transpose(dT_data(1,*))

   ;dx=1.0
  ;time = FINDGEN(ndt)*dx ;*** create the time index
  ;plot,y,background=-2, color=2
  range=dt_data(0,*)
  dx=(dt_data(0,917)-dt_data(0,0))/918
  stop
   wave = WAVELET(y,dx,PERIOD=period,COI=coi,/PAD,SIGNIF=signif)

     nscale = N_ELEMENTS(period)
      ;LOADCT,10'

      CONTOUR,ABS(wave)^2,range,period, $
       XSTYLE=1,XTITLE='Range',YTITLE='Period',TITLE='T Wavelet', $
       YRANGE=[MAX(period),MIN(period)], $   ;*** Large-->Small period
       /YTYPE, $                             ;*** make y-axis logarithmic
       NLEVELS=25,/FILL
;
stop
 signif = REBIN(TRANSPOSE(signif),ndt,nscale)
 CONTOUR,ABS(wave)^2/signif,range,period, $
       /OVERPLOT,LEVEL=1.0,C_ANNOT='95%'
 PLOTS,range,coi,NOCLIP=0;     ;*** anything "below" this line is dubious
 close,1
stop
DEVICE, GET_DECOMPOSED=old_decomposed
DEVICE, DECOMPOSED=0
 read,outname,prompt='output path and filename:"d:\rsi\wavelet\****.png" ??  '
 ;ntrname =fpath+'outname'+'.png'
WRITE_PNG, outname, TVRD(/TRUE)
end