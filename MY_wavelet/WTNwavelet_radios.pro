pro wavelet_radioS ;radiosonde data analysis
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

 ;H is the input data <1000 elements

  fpath='d:\rsi\wavelet\'  ;sun_spot.txt'
  datanm='Ja16radiodata.txt'
  finm=fpath+datanm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   openr,1,finm;   'd:\rsi\test\sun_spot.txt'
   col=4
   H=FLTARR(col,1000) ;A big array to hold the data
   S=FLTARR(col,1)      ;A small array to read a line

   ON_IOERROR,ers     ;Jump to statement ers when I/O error is detected
   n=0 ; Create a count
;;;;;
 WHILE n LT 1000 DO BEGIN
    READF,1,S    ;Read a line of data
   ; PRINT,S      ;Print the line
    H[*,n]=S     ;Store it in H

     n=n+1      ;Increment the counter

ENDWHILE          ;End of while loop

;;;;;;;;;;;;;;;;;;;;;stop
ers: CLOSE,1         ;Jump to this statement when an end of file is detected
;Ht=H[*,0:n-1]
;T1=H[2,*]
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;stop

 ndata=n-1
  read,nC,prompt='column to treat, 1:T,2 monthAve 3: diff (1-2)?? '

  Rdata=H[*,0:ndata-1]
   y=transpose(Rdata[nC,*])
  range=Rdata(0,*)
  dx=(Rdata(0,ndata-1)-Rdata(0,0))/ndata
  ;stop
   wave = WAVELET(y,dx,PERIOD=period,COI=coi,/PAD,SIGNIF=signif)

     nscale = N_ELEMENTS(period)
      ;LOADCT,10'

      CONTOUR,ABS(wave)^2,range,period, $
       XSTYLE=1,XTITLE='Range (km)',YTITLE='Period (km)',TITLE='T Wavelet', $
       YRANGE=[MAX(period),MIN(period)*100], $   ;*** Large-->Small period
       /YTYPE, $                             ;*** make y-axis logarithmic
       NLEVELS=25,/FILL
;
 nlevs=25
 cmax=max(wave)
 cmin=min(wave)
 cint = (cmax-cmin)/ NLEVS
 zb = fltarr(nlevs,2)
  BAR_POSITION=[0.15,0.2,0.45,0.25]
    for k = 0, nlevs-1 do zb(k,0:1) = cmin + cint*k
     xb = cmin + findgen(nlevs)*cint
     yb=[0,1]
     xname = [' ',' ',' ']
  CONTOUR, zb, xb(0:nlevs-1), yb(0:1),position=bar_position,$
      xrange=[0,1],/xstyle,xtickv=findgen(2),$
      xticks=1,xtickname=xname,yrange =[cmin,cmax],/YSTYLE, $
      LEVELS = CLEVS,C_COLOR = C_INDEX, /FILL, ycharsize=1, $
      xcharsize=1,/noerase
stop
 signif = REBIN(TRANSPOSE(signif),ndata,nscale)
 CONTOUR,ABS(wave)^2/signif,range,period, $
       /OVERPLOT,LEVEL=1.0,C_ANNOT='95%'
 PLOTS,range,coi,NOCLIP=0;     ;*** anything "below" this line is dubious
 close,1
stop
DEVICE, GET_DECOMPOSED=old_decomposed
DEVICE, DECOMPOSED=0
outname=''
 read,outname,prompt='****.png" ??  '
 ;ntrname =fpath+outname
WRITE_PNG, "d:\rsi\wavelet\"+outname, TVRD(/TRUE)
end