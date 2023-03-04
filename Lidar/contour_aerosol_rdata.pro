Pro contour_aerosol_Rdata

device, decomposed=0

!p.multi=[0,2,2,0,0];   [0,2,2]  ;!P.multi=[0,1,2]
!p.background=255
 loadct,39
plot,[0,10],[-1,1],COLOR = 0
plot,[0,1],xrange=[0,20],yrange=[-2,2],/nodata,COLOR = 0
plot,[0,10],[-1,1],COLOR = 0
plot,[0,10],[-1,1],COLOR = 0
;oplot,[0,20],[1.5,1.5],COLOR = 50

;stop;
;-----------------------------
;start with a colour table, read in from an external file hues.dat
rgb = bytarr(3,256)
openr,2,'F:\rsi\hues.dat'
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
;read,month,prompt='month:ja,fe,mr,ap,ma,jn....? '
 ; bpath='c:\JB\'   ;Rayleigh\1995\se\se112342
;bpath='e:\disc G\Lidarpro\depolar\';Lidar systems\Depolar\
 bpath='f:\lidar_data\'

 ;path='d:\LidarPro\Depolar\2004\mr\mr041947.'  ;072150.' ;202312.'; 312023.'; mr192028.' ;mr312023.'
dnm=''
 read,dnm,prompt='data filename as mr022018'
 month=strmid(dnm,0,2)
 fpath=bpath+yr+'\'+month+'\' ;
 fnm=fpath+dnm+'.'
read,ni,nf, prompt='Initial and file number as 1,99: '
read,h1,h2,prompt='Height range in km as 1,5: '
  nx=nf-ni+1
  j=0
  T=findgen(8192)
  pr2m=fltarr(nx,2000)
  pr2d=fltarr(nx,2000)
  ht=3.0E8*160.E-9*T/2./1000.   ;convert ht to km
   ht1=ht[0:1999]
 FOR n=ni,nf do begin

   sn=strtrim(fix(n),2)
  ;ln=strlen(sn)

   fn1=fnm+strtrim(sn,2)+'m'

   datab=read_binary(fn1,DATA_TYPE=2)
   sig=datab[0:1999]
   pr2m[j,*]=sig*ht^2
   x=findgen(nx)
   y=ht1

   j=j+1

  ENDFOR

  col = 240 ; don't change it

  cmax=3*max(pr2m[nf-ni-nx/2,400:500])
  cmin=cmax/100  ;0
  ;nlevs=40
  ;nlevs_max=40
  nlevs_max = 20 ; choose what you think is right
 cint = (cmax-cmin)/nlevs_max
 CLEVS = CMIN + FINDGEN(NLEVS_MAX+1)*CINT
 ;CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
 clevs0 = clevs ; for plot the color bar

 NLEVS = N_ELEMENTS(CLEVS)+1 ;actual number of countour levels

 col = 240 ; don't change it
 C_INDEX=(FINDGEN(NLEVS)+1)*col/(NLEVS)
 c_index(NLEVS-1) = 1 ; missing data = white

 plot_position1 = [0.1,0.15,0.73,0.49]; plot_position=[0.1,0.15,0.93,0.49]
 plot_position2 = [0.1,0.6,0.73,0.95]; plot_position2=[0.1,0.6,0.93,0.95]
 plot_position3 = [0.85,0.15,0.95,0.49]
 plot_position4 = [0.85,0.6,0.95,0.95]


 BAR_POSITION1=[0.77,0.2,0.79,0.45]
 BAR_POSITION2=[0.77,0.7,0.79,0.95]



 contour,pr2m,x,y,xtitle='m channel time',ytitle='km',yrange=[h1,h2],LEVELS = CLEVS, /FILL,$
    C_COLORS = C_INDEX, color=2,/FOLLOW,position=plot_position1,title='                             file 1_200''
     ;xyouts,500,5,'fn',color=1,charsize=2
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
   sigd=smooth(sig2,10)
   pr2d[k,*]=sigd*ht^2

   x=findgen(nx)
   y=ht1


   k=k+1

  ENDFOR

  col = 240 ; don't change it
  cmaxd= 3*max(pr2d[nf-ni-nx/2,400:500]);300;   0./5
  cmind=0;   0
  cint = (cmaxd-cmind)/nlevs_max
  CLEVS = CMIND + FINDGEN(NLEVS_MAX+1)*CINT
 ;CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
  clevs0 = clevs ; for plot the color bar
  NLEVS = N_ELEMENTS(CLEVS)+1 ;actual number of countour levels


   C_INDEX=(FINDGEN(NLEVS)+1)*col/(NLEVS)
   c_index(NLEVS-1) = 1 ; missing data = white


   contour,pr2d,x,y,xtitle='d channel time',ytitle='km',title=dnm, yrange=[h1,h2],LEVELS = CLEVS, /FILL,$
    C_COLORS = C_INDEX, color=2,/FOLLOW,position=plot_position2
   ;xyouts,500,5,'fn',color=1,charsize=2
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
  ;read,yr2,prompt='year as 02 for 2002: '
  ;fnm='R04'+dnm+'.txt'
  cwb=''
  read,cwb,prompt='radiosonde file name:  '
  Rdata=sonding_data(cwb,km,T,RH)
  plot,T,km,color=2,xrange=[-20,20],xtitle='Temperature',yrange=[h1,h2],ytitle='km',charsize=0.8,position=plot_position3
  plot,RH,km,psym=2,xrange=[50,100],xtitle='RH%',yrange=[h1,h2],ytitle='km',charsize=0.8,color=2,position=plot_position4
  stop

  DEVICE, DECOMPOSED=0
  ;fnmc=''
  ;read,fnm,prompt='filename to output'
  cntrname =bpath+'output2018\'+dnm+'.BMP'

WRITE_BMP, cntrname, TVRD(/TRUE)
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

