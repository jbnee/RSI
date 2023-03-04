Pro contour_BETA_2009
;plot contour from calculated beta_a file
ERASE
device, decomposed=0

;!p.multi=[0,1,2]
!p.background=255
 loadct,39
;plot,[0,10],[-1,1],COLOR = 0
;plot,[0,1],xrange=[0,20],yrange=[-2,2],/nodata,COLOR = 0
;oplot,[0,20],[1.5,1.5],COLOR = 50


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

 read,n1,n2, prompt='array size as 20, 1000: '

 Z1=fltarr(n1,n2)
Z2=fltarr(n1,n2)
Z=fltarr(n1,n2)

  close,/all
 bpath='f:\Lidar_data\Fernald_out\' ;data file location

  fnm=''
  read,fnm, prompt='file name as FE09:  '
  mfile=bpath+fnm+'betaM.txt'

  openr,1,mfile
  readf,1,Z1

  dfile=bpath+fnm+'betaM.txt'
   openr,2,dfile
   readf,2,Z2

  close,/all
  Z=Z2/(Z1+Z2)
  S=size(depol)
  print,'size of file:  ',S


 ; read,n1,n2, prompt='array size as 20x1000: '
  ;read,h1,h2, prompt='height range as,10,30:  '

  ; Z=fltarr(n1,n2)
  ; openr,1,file1
  ; readf,1,Z

  close,1
  read,hbin, prompt='hi_bin to plot such as 400
  Z=Z[0:n1-1,0:hbin-1]
  ;;;;;;treatZ by smoothing using Rebin;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Z[*,300:399]=0
  RZ1=rebin(Z,6,100)
  RZ2=rebin(RZ1,24,400)
  AZ=total(RZ2,1)
  n11=24
  x=INDGEN(n11)
  n3=400
  y=0.0075*indgen(n3)
  col = 240 ; don't change it
  cmin=0;min(AZ);10 is arbitrary set the 5th file
  cmax=max(AZ[200:300])/5;100000;60000
  ;nlevs_max=40
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
  ; h2=n3/0.0075 ; for licel height

   contour,RZ2,x,y,xtitle='m channel time',ytitle='km',yrange=[0,3],LEVELS = CLEVS, /FILL,$
    C_COLORS = C_INDEX, color=2,/FOLLOW

    ;xyouts,10,2,'Ja15',color=1,charsize=2

 ; plot a color bar, use the same clevs as in the contour

    nlevs=20 ;40
    zb = fltarr(2,nlevs)

   for k = 0, nlevs-1 do zb(0:1,k) = cmin + cint*k
     xb = [0,1]
     yb = cmin + findgen(nlevs)*cint
     xname = [' ',' ',' ']
     CONTOUR, zb, xb(0:1), yb(0:nlevs-1),position=BAR_POSITION2,$
      xrange=[0,1],/xstyle,xtickv=findgen(2),$
      xticks=1,xtickname=xname,yrange =[cmin,cmax/2],/YSTYLE, $
      LEVELS = CLEVS0,C_COLOR = C_INDEX, /FILL, ycharsize=0.7, $
      xcharsize=0.8,/noerase

 stop
 cntrname =bpath+fnm+'5.png'

WRITE_PNG, cntrname, TVRD(/TRUE)
end

