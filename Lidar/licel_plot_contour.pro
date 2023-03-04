Pro Licel_plot_contour
; READ ascii txt files which are converted from binary files
; only plot the photon countinf files of m and d channels
erase,1
 CLOSE,/ALL
;!p.multi=[0,1,2]
;!p.background=255
 mon=''
 mon='ap'
  bpath='f:\Lidar_data\2007\ap\ap_TEX';\CH6_3sB'
  fx=bpath+'\t*'
  fls=file_search(fx)
    nf=size(fls)
    PRINT,'NUM OF FILES: ',NF
    NX=NF[1]
   ;STOP
   dayf=''
  read,dayf,prompt='input day of interest:'
  ;fi_date=strmid(fls[0],33,2)
  dayx=where(strmid(fls,33,2) eq dayf)
  print,dayx
  S1=n_elements(dayx)
  print,';;;;;;;'
  print,'number of files:',S1
;  stop
       ;data count J=0 is the name of the 1st file
  fi=fls[dayx[0]]
sdnm=strmid(fi,30,10)
da=strmid(sdnm,3,2)
hr=strmid(sdnm,5,2)
minute=strmid(sdnm,8,2)
dnm=mon+da+hr+minute  ; this is the file name

print,dnm
;stop
 N=2500
T=findgen(N)

  ht=3.0E8*50.E-9*T/2./1000.+0.001   ;convert ht to km and remove 0 with bin resolution 50 ns
  FX=BPATH+'\T*';    e*'
  ;fx=bpath+'\t09726*';  yr+'\'+month+'\'+dnm+'.

  read,m,prompt='Number of files to read:'

  read,h1,h2,prompt='Height region as 1, 5  km: '
    ;h1=1.0
   ; h2=4.0
    n1=round(h1*1000./7.5)  ;channel number
    n2=round(h2*1000./7.5)  ;ch
   ;s1=strtrim(fix(ni),2)
   ;s2=strtrim(fix(nf),2)
   ;Sw ='                                       file:'+s1+'_'+s2;used to print title
    sigxm=fltarr(nx,N);n2-n1+1)
    ;=fltarr(nx,N)
    pr2m=fltarr(nx,N)
    pr2d=fltarr(nx,N)

     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    hd=''
   ; m=S1

    ;read,m2,prompt='additional files to add: '
    ;m=m+m2
    DATAB=FLTARR(4,N)
    ApM=fltarr(m,N)
    ApD=fltarr(m,N)
    ppm=fltarr(m,N)
    ppd=fltarr(m,N)
    close,/all
    stop
   FOR I=0,m-1 DO BEGIN
    OPENR,1,fls[I]
    readf,1,hd
    READF,1, DATAB
    aPm[i,*]=datab[0,*]
    PPm[i,*]=datab[1,*]
    apd[i,*]=datab[2,*]
    PPd[i,*]=datab[3,*]
    ; sig=fltarr(nx,40000)
    close,1

   ENDFOR
loadct,5
!p.multi=[0,1,2]
p1 = [0.1,0.15,0.90,0.49]; plot_position=[0.1,0.15,0.95,0.45]
 p2 = [0.1,0.6,0.90,0.95]

  ; film=dnm+'.'+strtrim(I,2)+'m'
plot,PPM[0,*],ht,color=2, background=-2,xrange=[0,1000],yrange=[h1,h2],position=p1

FOR J=0,M-1 DO BEGIN
oplot,PPM[J,*]+J*5,ht, color=5+j
ENDFOR

STOP

plot,PPD[0,*],ht,color=2,background=-2,position=p2,yrange=[h1,h2],xrange=[0,1000]

FOR K=0,M-1 DO BEGIN
oplot,Ppd[K,*]+K*5,ht,color=5+K
ENDFOR

   stop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;plot contour
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

rgb = bytarr(3,256)
openr,2,'f:\rsi\hues.dat'
readf,2,rgb
close,2
free_lun,2
;;;;;;;;;;;;;;;;;plot contour;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

device, decomposed=0
 !p.background=255
 loadct,39
  window,1
r=bytarr(256)
g = r
b = r
r(0:255) = rgb(0,0:255)
g(0:255) = rgb(1,0:255)
b(0:255) = rgb(2,0:255)
tvlct,r,g,b
!P.BACKGROUND= 1 ; 0 = black, 1 = white
!P.COLOR=2 ;blue labels

  x=indgen(m)
  n3=n2-n1
  y=0.0075*indgen(n3+1)
  CPPM=PPM[*,0:n3]
  CPPD=PPD[*, 0:n3]


  col = 240 ; don't change it
  cmin=0;min(AZ);10 is arbitrary set the 5th file
  cmax=max(CPPM[1,20:200])/3;100000;60000
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

; plot_position1 = [0.1,0.15,0.93,0.49]; plot_position=[0.1,0.15,0.95,0.45]
; plot_position2 = [0.1,0.6,0.93,0.95]; plot_position2=[0.1,0.6,0.95,0.95]
  BAR_POSITION1=[0.97,0.2,0.98,0.45]
  BAR_POSITION2=[0.97,0.5,0.98,0.95]


   contour,CPPM,x,y,xtitle='m channel time',ytitle='km',yrange=[h1,h2],LEVELS = CLEVS, /FILL,$
    C_COLORS = C_INDEX, color=2,/FOLLOW, position=p1

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

col = 240 ; don't change it
  cmind=0;min(AZ);10 is arbitrary set the 5th file
  cmaxd=max(CPPD[1,20:100]);  x=40
  nlevs_max = 40 ; choose what you think is right
  cint = (cmax-cmin)/nlevs_max
  CLEVS = CMIN + FINDGEN(NLEVS_MAX+1)*CINT
 ;CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
  clevs0 = clevs ; for plot the color bar

  NLEVS = N_ELEMENTS(CLEVS)+1 ;actual number of countour levels

    ;print,i0,' cmin,cmax',cmin,cmax,cint,nlevs

    col = 240 ; don't change it
    C_INDEX=(FINDGEN(NLEVS)+1)*col/(NLEVS)
    c_index(NLEVS-1) = 1 ; missing data = white

; plot_position1 = [0.1,0.15,0.93,0.49]; plot_position=[0.1,0.15,0.95,0.45]
; plot_position2 = [0.1,0.6,0.93,0.95]; plot_position2=[0.1,0.6,0.95,0.95]
    ;BAR_POSITION1=[0.97,0.2,0.98,0.45]
   ; BAR_POSITION2=[0.97,0.5,0.98,0.95]
  ; h2=n3/0.0075 ; for licel height

   contour,CPPD,x,y,xtitle='D channel time',ytitle='km',yrange=[h1,h2],LEVELS = CLEVS, /FILL,$
    C_COLORS = C_INDEX, color=2,/FOLLOW, position=p2

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

 ;cntrname =bpath+fnm+'.png'

;WRITE_PNG, cntrname, TVRD(/TRUE)


stop
end
