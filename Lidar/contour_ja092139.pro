Pro contour_ja092139
device, decomposed=0

;!p.multi=[0,1,2]
!p.background=255
 loadct,39
;plot,[0,10],[-1,1],COLOR = 0
;plot,[0,1],xrange=[0,20],yrange=[-2,2],/nodata,COLOR = 0
;oplot,[0,20],[1.5,1.5],COLOR = 50

stop
;-----------------------------
;start with a colour table, read in from an external file hues.dat
rgb = bytarr(3,256)
openr,2,'f:\rsi\hues.dat'
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


;openr,1,"d:\LidarPro\DATA\Rayleigh\1999\FE\Fe092341.2R"
;fn="D:\Lidar systems\lidarPro\Rayleigh\1993\se\se112342.';se010044.10m"
;path='d:\LidarPro\Rayleigh\1995\se\se112342.';.'
  close,/all
 bpath='f:\Lidar_files\depolar\output2\' ;data file location
 ;fpath=bpath+yr+'\'+month+'\'
 ;path='d:\LidarPro\Depolar\2004\mr\mr041947.'  ;072150.' ;202312.'; 312023.'; mr192028.' ;mr312023.'
  fnm=''
 ;read,dnm,prompt='data filename as mr12_depolar.txt'
 ;file_basename1='d:\LidarPro\Depolar\2004\ap\ap022014.' ;
 ;fnm=bpath+dnm+'.'

  read,fnm, prompt='file name :  '
  file1=bpath+fnm
  read,n1,n2, prompt='array size as 20x1000: '
  ;read,h1,h2, prompt='height range as,10,30:  '

   Z=fltarr(n1,n2)
   openr,1,file1
   readf,1,Z

  close,1
  Z=Z[0:39,0:399]
  ;;;;;;treatZ by smoothing using Rebin;;;;;;;;;;;;;;;;;;;;;;;;;;
  Z[*,300:399]=0
  RZ1=rebin(Z,5,100)
  RZ2=rebin(RZ1,20,400)
  AZ=total(RZ2,1)
  n11=20
  x=INDGEN(n11)
  n3=400
  y=0.0075*indgen(n3)
  col = 240 ; don't change it
  cmin=0;min(AZ);10 is arbitrary set the 5th file
  cmax=max(AZ[100:300])/3;100000;60000
  nlevs_max=40
  nlevs_max = 20 ; choose what you think is right
  cint = (cmax-cmin)/nlevs_max
  CLEVS = CMIN + FINDGEN(NLEVS_MAX+1)*CINT
 ;CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
  clevs0 = clevs ; for plot the color bar

  NLEVS = N_ELEMENTS(CLEVS)+1 ;actual number of countour levels

    ;print,i0,' cmin,cmax',cmin,cmax,cint,nlevs

    col = 240 ; don't change it
    C_INDEX=(FINDGEN(NLEVS)+1)*col/(NLEVS)
    c_index(NLEVS-1) = 1 ; missing data = white
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; plot_position1 = [0.1,0.15,0.93,0.49]; plot_position=[0.1,0.15,0.95,0.45]
; plot_position2 = [0.1,0.6,0.93,0.95]; plot_position2=[0.1,0.6,0.95,0.95]
; BAR_POSITION1=[0.97,0.2,0.99,0.45]
  BAR_POSITION2=[0.97,0.5,0.99,0.95]
   h2=n3/0.0075 ; for licel height

   contour,RZ2,x,y,xtitle='m channel time',ytitle='km',yrange=[0,3],LEVELS = CLEVS, /FILL,$
    C_COLORS = C_INDEX, color=2,/FOLLOW

  xyouts,500,5,'fn',color=1,charsize=2

 ; plot a color bar, use the same clevs as in the contour

    nlevs=40
    zb = fltarr(2,nlevs)

   for k = 0, nlevs-1 do zb(0:1,k) = cmin + cint*k
     xb = [0,1]
     yb = cmin + findgen(nlevs)*cint
     xname = [' ',' ',' ']
     CONTOUR, zb, xb(0:1), yb(0:nlevs-1),position=BAR_POSITION2,$
      xrange=[0,1],/xstyle,xtickv=findgen(2),$
      xticks=1,xtickname=xname,yrange =[cmin,cmax],/YSTYLE, $
      LEVELS = CLEVS0,C_COLOR = C_INDEX, /FILL, ycharsize=0.7, $
      xcharsize=0.8,/noerase

 stop
 cntrname =bpath+fnm+'5.png'

WRITE_PNG, cntrname, TVRD(/TRUE)
end

