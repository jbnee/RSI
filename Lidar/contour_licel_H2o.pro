Pro contour_licel_H2O
; same as contour_aerosol, only change the height calculation
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
openr,2,'c:\idl62\hues.dat'
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
 read,year, prompt='year as 2003: ?  '
 yr=string(year,format='(I4.4)')
 month=''
 read,month,prompt='month:ja,fe,mr,ap,ma,jn....? '
  opath='c:\JB\Raman09\H2O\'   ;output path Rayleigh\1995\se\se112342
 bpath='c:\JB\Raman09\';
 ;bpath='f:\DISC G\lidarpro\Depolar\'
 fpath=bpath+'\'+month+'\'
 ;path='d:\LidarPro\Depolar\2004\mr\mr041947.'  ;072150.' ;202312.'; 312023.'; mr192028.' ;mr312023.'
dnm=''
 read,dnm,prompt='data filename as mr022018'
 ;file_basename1='d:\LidarPro\Depolar\2004\ap\ap022014.' ;
 fnm=fpath+dnm+'.'
read,ni,nf, prompt='Initial and file number as 1,99: '
read,h1,h2,prompt='Height range in km as 1,5: '

  nx=nf-ni+1
  j=0
  T=findgen(8192)
  sigxm=fltarr(nx,2000);n2-n1+1)
  sigxd=fltarr(nx,2000)
  sigxm1=fltarr(nx,2000);n2-n1+1)
  sigxd1=fltarr(nx,2000)
  pr2m=fltarr(nx,2000);n2-n1+1)
  pr2d=fltarr(nx,2000)

  ;pr2m=fltarr(nx,2000)
 ; pr2d=fltarr(nx,2000)

  ht=3.0E8*(160.E-9)*T/2./1000.   ;convert ht to km
   ht1=ht[0:1999]

 n1=round(h1*1000/24)  ;channel number;24 is the height resolution binwidth
 n2=round(h2*1000/24)  ;ch
 FOR n=ni,nf do begin

   sn=strtrim(fix(n),2)
  ;ln=strlen(sn)

   fn1=fnm+strtrim(sn,2)+'m'

   datab=read_binary(fn1,DATA_TYPE=2)
   sig1=datab[0:1999]

   mina=mean(sig1[n2:2*n2])   ;background  [n1:n2])
   sigxm1[j,*]=sig1-mina;[n1:n2]-mina
   sigxm=smooth(sigxm1,10)
   pr2m[j,*]=sigxm[j,*]*(ht1^2) ;
      ;pr2m[j,*]=sigm*ht^2


   j=j+1

  ENDFOR

  col = 240. ; don't change it
  cmin=0;
  cmax=150;max(pr2m[150,0:200]);1500;500;./2  use floating point like 25.5
  ;nlevs=40
  ;nlevs_max=40
  nlevs_max = 20 ; choose what you think is right
 cint = (cmax-cmin)/nlevs_max
 CLEVS = CMIN + FINDGEN(NLEVS_MAX+1)*CINT
 ;CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
 clevs0 = clevs ; for plot the color bar

 NLEVS = N_ELEMENTS(CLEVS)+1 ;actual number of countour levels


 C_INDEX=(FINDGEN(NLEVS)+1)*col/(NLEVS)
 c_index(NLEVS-1) = 1 ; missing data = white

 plot_position1 = [0.1,0.15,0.93,0.49]; plot_position=[0.1,0.15,0.95,0.45]
 plot_position2 = [0.1,0.6,0.93,0.95]; plot_position2=[0.1,0.6,0.95,0.95]
 BAR_POSITION1=[0.97,0.2,0.99,0.45]
 BAR_POSITION2=[0.97,0.7,0.99,0.95]

 f1=string(ni,format='(I3.3)')
 f2=string(nf,format='(I3.3)')
 f3=f1+'--'+f2
  x=findgen(nx)
  y=ht1

 contour,pr2m,x,y,xtitle='m channel time',ytitle='km',yrange=[h1,h2],LEVELS = CLEVS, /FILL,$
    C_COLORS = C_INDEX, color=2,/FOLLOW,position=plot_position1;title=f3
 xyouts,1.5*max(x),0.2*max(y),f3,/device
 ;stop
 ; plot a color bar, use the same clevs as in the contour

   ; nlevs=40
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
   fn2=fnm+strtrim(sn,2)+'d'
   datab=read_binary(fn2,DATA_TYPE=2)
   sig2=datab[0:1999]
   minb=mean(sig2[n2:2*n2])   ;background  [n1:n2])
   sigxd1[k,*]=sig2-minb;[n1:n2]-mina
   sigxd=smooth(sigxd1,10)
   pr2d[k,*]=sigxd[k,*]*(ht1^2) ;

   ;  sigd=smooth(sig2,10)
   ; pr2d[k,*]=sigd*ht^2

   k=k+1

  ENDFOR

  col = 240 ; don't change it
  cmaxd=300;max(pr2d[5:100,0:300]);300;   0./5
  cmind=0
  cintd = (cmaxd-cmind)/nlevs_max
  CLEVS = CMIND + FINDGEN(NLEVS_MAX+1)*CINTd
 ;CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
  clevs0 = clevs ; for plot the color bar
  NLEVS = N_ELEMENTS(CLEVS)+1 ;actual number of countour levels

   C_INDEX=(FINDGEN(NLEVS)+1)*col/(NLEVS)
   c_index(NLEVS-1) = 1 ; missing data = white

   ;!x.range=[ni,ni+nf]

   x=findgen(nx)
   y=ht1

   contour,pr2d,x,y,xtitle='d channel time',ytitle='km',title=dnm, yrange=[h1,h2],LEVELS = CLEVS, /FILL,$
    C_COLORS = C_INDEX, color=2,/FOLLOW,position=plot_position2
   ;xyouts,500,5,'fn',color=1,charsize=2
 ;stop
 ; plot a color bar, use the same clevs as in the contour
    ;nlevs=40
    zb = fltarr(2,nlevs)
    for k = 0, nlevs-1 do zb(0:1,k) = cmind + cintd*k
     xb = [0,1]
     yb = cmind + findgen(nlevs)*cintd
     xname = [' ',' ',' ']
     CONTOUR, zb, xb(0:1), yb(0:nlevs-1),position=BAR_POSITION2,$
      xrange=[0,1],/xstyle,xtickv=findgen(2),$
      xticks=1,xtickname=xname,yrange =[cmind,cmaxd],/YSTYLE, $
      LEVELS = CLEVS0,C_COLOR = C_INDEX, /FILL, ycharsize=0.7, $
      xcharsize=0.8,/noerase
  stop

  DEVICE, DECOMPOSED=0
  ;fnmc=''
  read,fnm,prompt='filename to output'
  cntrname =opath+fnm+'.tiff'

WRITE_tiff, cntrname, TVRD(/TRUE)
stop
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

