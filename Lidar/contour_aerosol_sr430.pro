
Pro contour_aerosol_SR430

;ERASE,COLOR=-2
close,/all
device, decomposed=0

!p.multi=[0,1,2]
;!p.background=255
; loadct,39
plot,[0,10],[-1,1],COLOR = 0
plot,[0,1],xrange=[0,20],yrange=[-2,2],/nodata,COLOR = 0
oplot,[0,20],[1.5,1.5],COLOR = 50

;
;-----------------------------
;start with a colour table, read in from an external file hues.dat
rgb = bytarr(3,256)
openr,2,'F:\RSI\hues.dat'
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
 ; year=2009
 ;print,year
 read,year, prompt='year as 2009: ?  '
  yr=string(year,format='(I4.4)')
 ;month=''
 ;read,month,prompt='month:ja,fe,mr,ap,ma,jn....? '

 ;bpath='f:\DISC G\lidarpro\Depolar\';+yr+month
 ;fpath=bpath+yr+'\'+month+'\'
 ;path='d:\LidarPro\Depolar\2004\mr\mr041947.'  ;072150.' ;202312.'; 312023.'; mr192028.' ;mr312023.'
  dnm=''
  read,dnm,prompt='data filename as mr022018'
   month=strmid(dnm,0,2)
   bpath='F:\Lidar_data\';   systems\depolar\'
  fpath=bpath+yr+'\'+month+'\'

  fnm=fpath+dnm+'.'

    ;
  month=strmid(dnm,0,2)

  read,ni,nf, prompt='Initial and file number as 1,99: '
 read,h1,h2,prompt='Height range in km as 1,5: '
  nx=nf-ni+1
  j=0
  bnum=1000  ;total bin number
  T=findgen(bnum)
  datab=fltarr(bnum)
  pr2m=fltarr(nx,bnum)
  pr2d=fltarr(nx,bnum)
  dt=50; nanosecond
  ;dt=160
  ht=3.0E8*dt*1.E-9*T/2./1000.   ;convert ht to km
   ht1=ht[0:1999]
 FOR n=ni,nf do begin

   sn=strtrim(fix(n),2)
  ;ln=strlen(sn)

   fn1=fnm+strtrim(sn,2)+'m'
   openr,1,fn1; data_file;

   datab=read_binary(fn1,DATA_TYPE=2)
   sigm=datab[0:1999]
   sigm=smooth(sigm,10)
   bk=min(smooth(datab[bnum-200:bnum-1],20))
   pr2m[j,*]=(sigm-bk)*ht^2
   x=findgen(nx)
   y=ht1

   j=j+1
   close,1
  ENDFOR;n

  col = 240 ; don't change it

  cmax=1*max(pr2m[(nf-ni)/2,50:400]);400;1500;500;./2
  cmin=cmax/40.; cmax/10;min(pr2m[nf-ni-nx/2,0:200])
  ;nlevs=40
  ;nlevs_max=40
  nlevs_max =80 ; choose what you think is right
 cint = (cmax-cmin)/nlevs_max
 CLEVS = CMIN + FINDGEN(NLEVS_MAX+1)*CINT
 ;CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
 clevs0 = clevs ; for plot the color bar

 NLEVS = N_ELEMENTS(CLEVS)+1 ;actual number of countour levels

 col = 240 ; don't change it
 C_INDEX=(FINDGEN(NLEVS)+1)*col/(NLEVS)
; c_index(NLEVS-1) = 1 ; missing data = white

 plot_position1 = [0.1,0.15,0.90,0.49]; plot_position=[0.1,0.15,0.95,0.45]
 plot_position2 = [0.1,0.6,0.90,0.95]; plot_position2=[0.1,0.6,0.95,0.95]
 BAR_POSITION1=[0.97,0.2,0.99,0.45]
 BAR_POSITION2=[0.97,0.7,0.99,0.95]

 ;f1=string(ni,format='(I3.3)')
 ;f2=string(nf,format='(I3.3)')
 ;f3=f1+'--'+f2
 s1=strtrim(fix(ni),2)
 s2=strtrim(fix(nf),2)
 S='                                       file:'+s1+'_'+s2;used to print title

 contour,pr2m,x,y,xtitle='m channel time',ytitle='km',yrange=[h1,h2],LEVELS = CLEVS, /FILL,$
    C_COLORS = C_INDEX, color=2,/FOLLOW,position=plot_position1,title=S
; xyouts,1.5*max(x),0.2*max(y),f3,/device
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


 ;stop
 k=0

 FOR nd=ni+1,nf do begin
   sn=strtrim(fix(nd),2)
   fn2=fnm+strtrim(sn,2)+'d'
    openr,2,fn2; data_file;

   datab=read_binary(fn2,DATA_TYPE=2)
   sigd=datab[0:1999]
   sigd=smooth(sigd,10)

   bk2=min(smooth(datab[bnum-200:bnum-1],20))
   pr2d[k,*]=(sigd-bk2)*ht^2


   x=findgen(nx)
   y=ht1


   k=k+1
   close,2
  ENDFOR  ;nd

  col = 240 ; don't change it
  cmaxd=0.1*max(pr2d[nf-ni-nx/2,0:30]);300;   0./5
  cmind=0;cmaxd/50.
  nlevs_max=3 ;increase to show background color
  cint = (cmaxd-cmind)/nlevs_max
  CLEVS = CMIND + FINDGEN(NLEVS_MAX+1)*CINT
 ;CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
  clevs0 = clevs ; for plot the color bar
  NLEVS = N_ELEMENTS(CLEVS)+1 ;actual number of countour levels


   C_INDEX=(FINDGEN(NLEVS)+1)*col/(NLEVS)
   c_index(NLEVS-1) = 1 ; missing data = white

   ;!x.range=[ni,ni+nf]
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

  DEVICE, DECOMPOSED=0
  ;opath='F:\lidar_data\output\'   ;output path Rayleigh\1995\se\se112342
   ;opath2='F:\lidar_data\out2002\';
    OPATH3='F:\aerosols\Aerosol 2002_10\out2002\'
    cname =opath3+dnm+'.bmp'

WRITE_bmp,cname,TVRD(/TRUE)
stop


 end


