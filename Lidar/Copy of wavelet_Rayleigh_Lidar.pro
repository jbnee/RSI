pro wavelet_Rayleigh_Lidar
device, decomposed=0

rgb = bytarr(3,256)
openr,2,'c:\idl62\hues.dat';'d:\rsi\hues.dat'
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

col = 240 ; don't change it
cmax=48000
cmin=5000
nlevs_max=20
nlevs= 20 ; choose what you think is right
 cint = (cmax-cmin)/nlevs_max
 CLEVS = CMIN + FINDGEN(NLEVS_MAX+1)*CINT
 CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
 clevs0 = clevs ; for plot the color bar
 plot_position1 = [0.1,0.15,0.93,0.95]; plot_position=[0.1,0.15,0.95,0.45]
;plot_position2 = [0.1,0.6,0.93,0.95]; plot_position2=[0.1,0.6,0.95,0.95]
 BAR_POSITION1=[0.97,0.5,0.99,0.95]

   close,/all
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;input data;;;;;;;;;;;;;;;
  ndt = 918  ; number of data
  dT_data=fltarr(2,ndt); dT data is the difference between
  ;lidar T and Radiosonde T

  ;fpath='d:\rsi\test\'  ;sun_spot.txt'
   fpath='c:\Users\jinq\Google Drive\IDL programs\';
  ;datanm='Ja16dT_H.txt'
  datanm='Tav_ja16.txt'
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;stop
      CONTOUR,ABS(wave)^2,range,period,position=plot_position1, $
       XSTYLE=1,XTITLE='Range (km)',YTITLE='Period (km)',TITLE='T Wavelet', $
       YRANGE=[MAX(period),MIN(period)],$; /YTYPE,   $
       LEVELS = CLEVS, /FILL, C_COLORS = C_INDEX;, color=2,/FOLLOW



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   zb = fltarr(2,nlevs)
   for k = 0, nlevs-1 do zb(0:1,k) = cmin + cint*k
     xb = [0,1]
     yb = cmin + findgen(nlevs)*cint
     xname = [' ',' ',' ']
     CONTOUR, zb, xb(0:1), yb(0:nlevs-1),position=BAR_POSITION1,$
      xrange=[0,1],/xstyle,xtickv=findgen(2),$
      xticks=1,xtickname=xname,yrange =[cmin,cmax], /YSTYLE, $
      LEVELS = CLEVS0,C_COLOR = C_INDEX, /FILL, ycharsize=0.70, $
      xcharsize=0.8,/noerase
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 signif = REBIN(TRANSPOSE(signif),ndt,nscale)
 CONTOUR,ABS(wave)^2/signif,range,period,/overplot,$
       C_ANNOT='95%'; ,LEVEL=1.0,
 PLOTS,range,coi,NOCLIP=0, color=2;     ;*** anything "below" this line is dubious

 close,1

stop
DEVICE, GET_DECOMPOSED=old_decomposed
DEVICE, DECOMPOSED=0
 read,outname,prompt='output path and filename:"d:\rsi\wavelet\****.png" ??  '
 ;ntrname =fpath+'outname'+'.png'
WRITE_PNG, outname, TVRD(/TRUE)
end