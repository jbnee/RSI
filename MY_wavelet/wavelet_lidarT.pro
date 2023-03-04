pro wavelet_lidarT
;­º¥ýcompile wavelet

;start with a colour table, read in from an external file hues.dat
erase
device, decomposed=0
rgb = bytarr(3,256)
openr,2,'E:\rsi\hues.dat'
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

!P.BACKGROUND=1 ; 0 = black, 1 = white
!P.COLOR=2 ;blue labels
cmaxm=20
cminm=cmaxm/5
NLEVS=20
col=240
cint=(cmaxm-cminm)/nlevs
CLEVS = CMINm + FINDGEN(NLEVS+1)*CINT
 C_INDEX=(FINDGEN(NLEVS)+1)*col/(NLEVS)
 c_index(NLEVS-1) = 1 ; missing data = white



    close,/all
   ntime = 915
  Tdata=fltarr(2,ntime)
openr,1,'E:\rsi\MY_wavelet\20001024C.txt'; 20001123C.txt'
   ;openr,1,'d:\rsi\test\sunspot.txt'
   readf,1,Tdata
   ht=Tdata[0,*]
   y=transpose(Tdata(1,*))
      ;y=sundata(1,*)
  ; y = RANDOMN(s,ntime)       ;*** create a random time series
  ; dt = 0.25
   dt=40
  time = FINDGEN(ntime)/dt ;*** create the time index
  plot,y,ht
  stop
   wave = WAVELET(y,dt,PERIOD=period,COI=coi,/PAD,SIGNIF=signif)
  ; wave = WAVELET(y,dt,PERIOD=period,COI=coi,/PAD)
;end
     nscale = N_ELEMENTS(period)
    ; stop
     LOADCT,39
     CONTOUR,ABS(wave)^2,time,period,background=-90,YRANGE= [20000,2000],/YTYPE ,$
       XSTYLE=1,XTITLE='Time',YTITLE='Period m',TITLE='Noise Wavelet', $
      NLEVELS=25,/FILL   ;*** Large-->Small period
      ;; YRANGE= [MAX(period),MIN(period)],/YTYPE ,   ,   NLEVELS=25,/FILL            ;*** make y-axis logarithmic



     ; CONTOUR,ABS(wave)^2,time,period, $
      ; XSTYLE=1,XTITLE='Time',YTITLE='Period',TITLE='Noise Wavelet', $
      ; YRANGE=[MAX(period),MIN(period)], /YTYPE  $   ;*** Large-->Small period
      ; ,LEVELS = CLEVS, /FILL, C_COLORS = C_INDEX, $
       ;Nlves=25,/fill
stop

 signif = REBIN(TRANSPOSE(signif),ntime,nscale)
 CONTOUR,ABS(wave)^2/signif,time,period,background=1 $
   ,LEVEL=1.0,C_ANNOT='95%' ,/overplot
 PLOTs,time,coi,NOCLIP=0;background=-2, color=2,/overplot   ;*** anything "below" this line is dubious
 close,1
stop

end