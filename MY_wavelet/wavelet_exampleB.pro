pro wavelet_exampleB

device,decomposed=0
erase
rgb = bytarr(3,256)
openr,2,'E:\rsi\hues.dat'
readf,2,rgb
close,2
r=bytarr(256)
g = r
b = r
r(0:255) = rgb(0,0:255)
g(0:255) = rgb(1,0:255)
b(0:255) = rgb(2,0:255)
tvlct,r,g,b

!P.BACKGROUND=-1 ; 0 = black, 1 = white
!P.COLOR=2 ;blue labels
;;;************************************************************

  ntime = 256
  ;seed=0.123
 y = RANDOMN(s,ntime)       ;*** create a random time series
 dt = 0.25
 time = FINDGEN(ntime)*dt   ;*** create the time index
 plot,y,color=2,background=-2
stop
 wave = WAVELET(y,dt,PERIOD=period,COI=coi,/PAD,SIGNIF=signif)
     nscale = N_ELEMENTS(period)
   ;   LOADCT,10
   CONTOUR,ABS(wave)^2,time,period, $
       XSTYLE=1,XTITLE='Time',YTITLE='Period',TITLE='Noise Wavelet', $
       YRANGE=[MAX(period),MIN(period)], $   ;*** Large-->Small period
       /YTYPE, $                             ;*** make y-axis logarithmic
       NLEVELS=25,/FILL
;    IDL>
 signif = REBIN(TRANSPOSE(signif),ntime,nscale)

power=abs(wave)^2


 cmax=max(power)/2
 cmin=cmax/20.
nlevs_max = 20
cint = (cmax-cmin)/nlevs_max
CLEVS = CMIN + FINDGEN(NLEVS_MAX+1)*CINT
CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
clevs0 = clevs ; for plot the color bar

NLEVS = N_ELEMENTS(CLEVS)+1 ;actual number of countour levels
col = 240
C_INDEX=(FINDGEN(NLEVS)+1)*col/(NLEVS)
c_index(NLEVS-1) = 1

loadct,39

;!P.BACKGROUND= 1 ; 0 = black, 1 = white
;!P.COLOR=2 ;blue labels
contour,power/signif,time,period,XSTYLE =1,YTITLE='ht',POSITION= PLOT_POSITION,$
LEVELS = CLEVS, /FILL, C_COLORS = C_INDEX, color=2,/FOLLOW;
       ;/OVERPLOT,LEVEL=1.0,


;LEVELS = CLEVS, /FILL,$
;    C_COLORS = C_INDEX, color=2,/FOLLOW,C_ANNOT='95%'
       ;/OVERPLOT,LEVEL=1.0,
stop
 PLOTS,time,coi,NOCLIP=0;background=-2, color=2   ;*** anything "below" this line is dubious
stop
end