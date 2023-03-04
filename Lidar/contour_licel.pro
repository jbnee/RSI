Pro contour_licel
;for aerosol or cirrus
device, decomposed=0

!p.multi=[0,1,2]
!p.background=255
 loadct,39
plot,[0,10],[-1,1],COLOR = 0
plot,[0,1],xrange=[0,20],yrange=[-2,2],/nodata,COLOR = 0
oplot,[0,20],[1.5,1.5],COLOR = 50

;
;-----------------------------
;start with a colour table, read in from an external file hues.dat
rgb = bytarr(3,256)
close,/all
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
close,/all
;openr,1,"d:\LidarPro\DATA\Rayleigh\1999\FE\Fe092341.2R"
;fn="D:\Lidar systems\lidarPro\Rayleigh\1993\se\se112342.';se010044.10m"
;path='d:\LidarPro\Rayleigh\1995\se\se112342.';.'
; read,year, prompt='year as 2000: ?  '
 bpath='f:\Lidar_data\'

 year=2009
 yr=string(year,format='(I4.4)')
 flst=strarr(8)
  openr,2,'f:\lidar_data\JN_2009.txt'
  readf,2,flst
  close,2

 stop
 ;dnm=''
; read,dnm,prompt='data filename as de062148'
   read,nf1,prompt='file number 1:2,3,.. '
  dnm=flst[nf1]
  print,dnm

  month=''
 month=strmid(dnm,0,2)
 ;file_basename1='d:\LidarPro\Depolar\2004\ap\ap022014.' ;

  ;bpath='F:\DIS G\LidarPro\depolar\';\Lidar data\1993-2000\'
 fpath=bpath+yr+'\'+month+'\'
 fnm=fpath+dnm+'.'
  ni=1
read,nf, prompt='total file number as 99: '
 s1=strtrim(fix(ni),2)
 s2=strtrim(fix(nf),2)
S='                                          file:'+s1+'_'+s2
;h1=1.0
;h2=5.;20.0
print,'height region 1-20 km   '
nbin=4000
read,h1,h2, prompt='height range as,10,30:  '
  nx=nf-ni+1
  j=0
  T=findgen(nbin)
  sig=fltarr(nbin)
  sig2=fltarr(nbin)
  pr2m=fltarr(nx,nbin)
  pr2d=fltarr(nx,nbin)
  dt=50
  ht=3.0E8*dt*1E-9*T/2.   ;meter
 ; nbin2=2000  ; height of interest
   ht1=ht[0:nbin-1]/1000.; km;
   close,/all
 FOR n=ni,nf do begin

   sn=strtrim(fix(n),2)
  ;ln=strlen(sn)

   fn1=fnm+strtrim(sn,2)+'M'; 'A'
   openr,1,fn1
   readf,1,sig

   ;datab=read_binary(fn1,DATA_TYPE=2)
   ;sig=datab[0:nbin-1]
   sigm=smooth(sig,10)
   bg1=mean(sigm[nbin-500:nbin-1])
   pr2m[j,*]=(sigm-bg1)*ht^2
   x=findgen(nx)
   y=ht1

   j=j+1
   close,1
  ENDFOR

  col = 240 ; don't change it
  cmin=min(pr2m[nf-ni-1,0:1000]);10 is arbitrary set the 5th file
  cmax=1.*max(pr2m[nf-ni-1,0:1000]);100000;60000
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


i0=1
 plot_position1 = [0.1,0.15,0.93,0.49]; plot_position=[0.1,0.15,0.95,0.45]
 plot_position2 = [0.1,0.6,0.93,0.95]; plot_position2=[0.1,0.6,0.95,0.95]
 BAR_POSITION1=[0.97,0.2,0.99,0.45]
 BAR_POSITION2=[0.97,0.7,0.99,0.95]


;plot,pr2m,y,background=-2,color=2

 contour,pr2m,x,y,xtitle='Parallel channel time',ytitle='km',xrange=[1,nx],yrange=[h1,h2],title=s,LEVELS = CLEVS, /FILL,$
    C_COLORS = C_INDEX, color=2,/FOLLOW,position=plot_position1
     xyouts,500,5,'fn',color=1,charsize=2
; stop
 ; plot a color bar, use the same clevs as in the contour

    nlevs=40
    zb = fltarr(2,nlevs)
    for k = 0, nlevs-1 do zb(0:1,k) = cmin + cint*k
     xb = [0,1]
     yb = cmin + findgen(nlevs)*cint
     xname = [' ',' ',' ']
     CONTOUR, zb, xb(0:1), yb(0:nlevs-1),position=BAR_POSITION1,$
      xrange=[0,1],/xstyle,xtickv=findgen(2),$
      xticks=1,xtickname=xname,yrange =[cmin,cmax],/YSTYLE, $
      LEVELS = CLEVS0,C_COLOR = C_INDEX, /FILL, ycharsize=0.7, $
      xcharsize=0.8,/noerase


 stop
 k=0


 FOR nd=ni+1,nf do begin
   sn=strtrim(fix(nd),2)
   fn2=fnm+strtrim(sn,2)+'D'  ;'B'
   openr,2,fn2
   readf,2,sig2

   ;datab=read_binary(fn2,DATA_TYPE=2)
   ;sig2=datab[0:nbin-1]
   sigd=smooth(sig2,10)
    bg2=mean(sigd[nbin-500:nbin-1])
   pr2d[k,*]=(sigd-bg2)*ht^2

   x=findgen(nx)
   y=ht1
   k=k+1
   close,2
  ENDFOR
  col = 240 ; don't change it
  cmind=min(pr2d[nf-ni-1,0:1000]);5 is arb set
  cmaxd=3*max(pr2d[nf-ni-1,0:1000]);100000;60000
  nlevs_max=40
  nlevs_max = 20 ; choose what you think is right
 cint = (cmaxd-cmind)/nlevs_max
 CLEVS = CMIND + FINDGEN(NLEVS_MAX+1)*CINT
 ;CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
 clevs0 = clevs ; for plot the color bar

 NLEVS = N_ELEMENTS(CLEVS)+1 ;actual number of countour levels

    ;print,i0,' cmin,cmax',cmin,cmax,cint,nlevs

    col = 240 ; don't change it
    C_INDEX=(FINDGEN(NLEVS)+1)*col/(NLEVS)
    c_index(NLEVS-1) = 1 ; missing data = white

    contour,pr2d,x,y,xtitle=' ',ytitle='km',title='Perpendicular channel    '+dnm,xrange=[1,nx], yrange=[h1,h2],LEVELS = CLEVS, /FILL,$
      C_COLORS = C_INDEX, color=2,/FOLLOW,position=plot_position2
   xyouts,500,5,'fn',color=1,charsize=2
 ;stop
 ; plot a color bar, use the same clevs as in the contour
    ;nlevs=40
    zb = fltarr(2,nlevs)
    for k = 0, nlevs-1 do zb(0:1,k) = cmind + cint*k
     xb = [0,1]
     yb = cmind + findgen(nlevs)*cint
     xname = [' ',' ',' ']
     CONTOUR, zb, xb(0:1), yb(0:nlevs-1),position=BAR_POSITION2,$
      xrange=[0,1],/xstyle,xtickv=findgen(2),$
      xticks=1,xtickname=xname,yrange =[cmind,cmaxd],/YSTYLE, $
      LEVELS = CLEVS0,C_COLOR = C_INDEX, /FILL, ycharsize=0.7, $
      xcharsize=0.8,/noerase
  stop

  DEVICE, DECOMPOSED=0
  ;fnmc=''
  ;read,fnm,prompt='filename to output'
 outpath='f:\aerosol\aerosol 2002_10\out2009\'
  cntr =outpath+dnm+'.png'

WRITE_PNG, cntr, TVRD(/TRUE)
stop
sumpr2m=total(pr2m,1)
plot,ht1,sumpr2m,color=2,xtitle='km',ytitle='count',title='parallel    '+dnm
;plot,pr2m(ni,100:1000),color=2,xtitle='file',ytitle='count',title='parallel'


;for im=1,nx,10 do begin
;oplot,pr2m(im,100:1000),color=2;,xlabel('file'),ylabel='count'
;endfor
sumpr2d=total(pr2d,1)
plot,ht1,sumpr2d,color=2,xtitle='km',ytitle='count',title='perpendicular'
;plot,pr2d(ni,100:1000),color=2,xtitle='file',ytitle='count',title='perpendicular'

;for id=1,nx,10 do begin
;oplot,pr2d(id,100:1000),color=2;,xlabel('file'),ylabel='count'
;endfor
stop
 outpath='f:\aerosol\aerosol 2002_10\out2009\'
 pname=outpath+dnm+'.png'
WRITE_PNG, pname, TVRD()
stop


WRITE_PNG, pnm, TVRD()
end

 ; read,nx,prompt='which file number to process such as 5';

 ; write_bmp,"d:\lidar systems\lidarpro\Rayleigh\1993\93se010044.bmp",tvrd()
;;;;Rayleigh backscattering coefficient
;;;;;;;; density of air is the polynomial fit of height determined from radiosonde

   ; density= 1.E25*(2.4498-0.22114*ht1+0.00701*ht1^2-7.75225E-5*ht1^3)  ;ht in km; in molec/m3
   ; beta_r=5.45E-32*(550./532.)^4*density  ;Rayleigh backscattering coefficient
   ; xsray=(8*3.1416/3.)*beta_r   ;Rayleigh cross section
   ;kext=xsray                   ;Rayleigh extinction
   ; transm=exp(-2*kext)             ;atmosph transmission
   ; y=dblarr(1024)
   ; y=(sig[0:600]*ht1[0:600]^2)/(transm*beta_r); bin 200 is 4.8 km
   ; plot,y,ht1,background=-2,color=2;xrange=[0,10000],yrange=[5,40],xtitle='Signal/channel',ytitle='km'
   ; stop
    ;wait,2
   ;  plot,y[0:200]/y[300],ht1,background=-2,color=2

   ; stop
    ; bratio=fltarr(2,1250)
    ; bratio[1,100:1249]=transpose(y[100:1249]/y[600])
    ; bratio[0,100:1249]=transpose(ht1[100:1249])
    ; openw,2,'d:\lidar systems\lidarpro\Rayleigh\1993\Bratio93se010044_14.txt'
    ; printf,2,bratio
    ; close,2

 ;close,1
;end

