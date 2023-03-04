Pro contour_aerosol
ERASE
close,/all
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
  year=''
 ;print,year
 read,year, prompt='year as 2003: ?  '
  yr=string(year,format='(I4.4)')
; month=''
 ;read,month,prompt='month:ja,fe,mr,ap,ma,jn....? '

   dnm=''
  read,dnm,prompt='data filename as mr022018'
   month=strmid(dnm,0,2)
   ;mn=strmid(month,0,2)
   bpath='F:\Lidar_data\';   systems\depolar\'
   fnm=bpath+yr+'\'+month+'\'+dnm+'.';

   ; fnm=FILE_SEARCH(fpath); +'.'
  ;print,size(fnm)
    ;
  ;STOP
 ;dt=50; nanosecond
  dt=160
  c=3.0e8
  ns=1.e-9
  dz=dt*c*ns/2     ;meter
  dz1000=dz/1000. ;  km
   bnum=1000  ;total bin number
  T=findgen(bnum)
  ht=dz*T/1000.+0.01   ;convert ht to km



 read,ni,nf, prompt='Initial and file number as 1,99: '
 read,h1,h2,prompt='Height range in km as 1,5: '
 bin1=round(h1/dz1000)
 bin2=round(h2/dz1000)
 nx=nf-ni+1
 F1=strtrim(fix(ni),2)
  F2=strtrim(fix(nf),2)
  FS='                         file:'+F1+'_'+F2;used to print title
  Ftitle=yr+dnm+FS

  datab=fltarr(bnum)
  pr2m=fltarr(nx,bnum)
  pr2d=fltarr(nx,bnum)
  ;fbk=fltarr(nx)

  j=0

 FOR n=ni,nf do begin

   sn=strtrim(fix(n),2)
  ;ln=strlen(sn)

   fn1=fnm+strtrim(sn,2)+'m'
   ;openr,1,fn1; data_file;
    ; readf,1,datab
   datab=read_binary(fn1,DATA_TYPE=2)
   sigm=datab[0:bnum-1]
   sigm=smooth(sigm,10)
   bk1=mean(smooth(sigm[bnum-200:bnum-1],20))
   pr2m[j,*]=(sigm-bk1)*ht^2
   x=findgen(nx)
   y=ht[0:bin2]

   j=j+1
   close,1
  ENDFOR;n
  pr2m=pr2m[*,0:bin2]
  col = 240 ; don't change it
  maxa=max(pr2m[nf/4,0:bin2])
  cmax=20.0; 0.1*maxa;  (pr2m[nf/4,0:bin2]);400;1500;500;./2
  cmin=cmax/100.0; cmax/10;min(pr2m[nf-ni-nx/2,0:200])

  nlevs_max =40. ; choose what you think is right
 cint = (cmax-cmin)/nlevs_max
 CLEVS = CMIN + FINDGEN(NLEVS_MAX+1)*CINT
 ;CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
 clevs0 = clevs ; for plot the color bar

 NLEVS = N_ELEMENTS(CLEVS)+1 ;actual number of countour levels

 col = 240 ; don't change it
 C_INDEX=(FINDGEN(NLEVS)+1)*col/(NLEVS)
 c_index(NLEVS-1) = 1 ; missing data = white

 plot_position1 = [0.1,0.15,0.90,0.49]; plot_position=[0.1,0.15,0.95,0.45]
 plot_position2 = [0.1,0.6,0.90,0.95]; plot_position2=[0.1,0.6,0.95,0.95]
 BAR_POSITION1=[0.95,0.2,0.97,0.45]
 BAR_POSITION2=[0.95,0.7,0.97,0.95]

 ;f1=string(ni,format='(I3.3)')
 ;f2=string(nf,format='(I3.3)')
 ;f3=f1+'--'+f2
 s1=strtrim(fix(ni),2)
 s2=strtrim(fix(nf),2)
 S='                                       file:'+s1+'_'+s2;used to print title
 ctitle=yr+dnm
 contour,pr2m,x,y,xtitle='channel time',ytitle='km',yrange=[h1,h2],LEVELS = CLEVS, /FILL,$
    C_COLORS = C_INDEX, color=2,/FOLLOW,position=plot_position1
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
      xcharsize=0.8,/noerase,xtitle='PR2m'


 stop
 k=0

 FOR nd=ni+1,nf do begin
   sn=strtrim(fix(nd),2)
   fn2=fnm+strtrim(sn,2)+'d'
    ;openr,2,fn2; data_file;
    ; readf,2,datab
   datab=read_binary(fn2,DATA_TYPE=2)
   ;datab=datab[0:bnum-1]
   sigd=datab[0:bnum-1]
   sigd=smooth(sigd,10)

   bk2=mean(smooth(sigd[bnum-200:bnum-1],20))
  ; fbk[nd]=bk2/bk1
   ;print,bk2

  ; pr2d[k,*]=pr2d[k,*]/fbk[nd]
   pr2d[k,*]=(sigd-bk2)*ht^2

  ; x=findgen(nx)



   k=k+1
   close,2
  ENDFOR  ;nd
    pr2d=pr2d[*,0:bin2]
  col = 240 ; don't change it
  cmaxd=0.001 ;0.1*max(pr2d[nF/4,10:bin2]);300;   0./5
  cmind=cmaxd/100.
   nlevs_max =40
  cint = (cmaxd-cmind)/nlevs_max
  CLEVS = CMIND + FINDGEN(NLEVS_MAX+1)*CINT
 ;CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
  clevs0 = clevs ; for plot the color bar
  NLEVS = N_ELEMENTS(CLEVS)+1 ;actual number of countour levels


   C_INDEX=(FINDGEN(NLEVS)+1)*col/(NLEVS)
   c_index(NLEVS-1) = 1 ; missing data = white

   ;!x.range=[ni,ni+nf]
   contour,pr2d,x,y,ytitle='km',title=Ftitle, yrange=[h1,h2],LEVELS = CLEVS, /FILL,$
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
      xcharsize=0.8,/noerase,xtitle='PR2d'
  stop




  ;DEVICE, DECOMPOSED=0
  ;opath='F:\lidar_data\output\'   ;output path Rayleigh\1995\se\se112342
   opath2='F:\lidar_data\'+yr+'\CONTOUR\'
    cname =opath2+yr+'_'+dnm+'A.png
WRITE_png,cname,TVRD(/TRUE)
stop


 end



