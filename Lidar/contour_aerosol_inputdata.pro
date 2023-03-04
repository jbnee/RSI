
Pro contour_aerosol_inputdata
;plot contour by using contour_make,z,x,y
ERASE,COLOR=-2
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
openr,2,'E:\RSI\hues.dat'
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
 read,year, prompt='year as 2003: ?  '
  yr=string(year,format='(I4.4)')
 ;month=''
 ;read,month,prompt='month:ja,fe,mr,ap,ma,jn....? '

 ;bpath='f:\DISC G\lidarpro\Depolar\';+yr+month
 ;fpath=bpath+yr+'\'+month+'\'
 ;path='d:\LidarPro\Depolar\2004\mr\mr041947.'  ;072150.' ;202312.'; 312023.'; mr192028.' ;mr312023.'
  dnm=''
  read,dnm,prompt='data filename as mr022018'
   month=strmid(dnm,0,2)
   bpath='E:\Lidar_data\';   systems\depolar\'
  fpath=bpath+yr+'\ASC\''+'\'

  fnm=fpath+dnm+'.'

    ;
  month=strmid(dnm,0,2)

  read,ni,nf, prompt='Initial and file number as 1,99: '
 read,h1,h2,prompt='Height range in km as 1,5: '
  nx=nf-ni+1
  j=0
  bnum=4000  ;total bin number
  T=findgen(bnum)
  datab=fltarr(bnum)
  pr2m=fltarr(nx,2000)
  pr2d=fltarr(nx,2000)
  ;dt=50; nanosecond
  dt=160
  ht=3.0E8*dt*1.E-9*T/2./1000.   ;convert ht to km
   ht1=ht[0:1999]
 FOR n=ni,nf do begin

   sn=strtrim(fix(n),2)
  ;ln=strlen(sn)

   fn1=fnm+strtrim(sn,2)+'m'
   ;openr,1,fn1; data_file;
    ; readf,1,datab
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



 stop
 k=0

 FOR nd=ni+1,nf do begin
   sn=strtrim(fix(nd),2)
   fn2=fnm+strtrim(sn,2)+'d'
    ;openr,2,fn2; data_file;
    ; readf,2,datab
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


  DEVICE, DECOMPOSED=0
  ;opath='F:\lidar_data\output\'   ;output path Rayleigh\1995\se\se112342
   ;opath2='F:\lidar_data\out2002\';
    OPATH3='E:\RSI\lidar\Fernald\2020\'
    cname =opath3+dnm+'PR2.png'

WRITE_png,cname,TVRD(/TRUE)
stop
print,cmax,cmin,nlevs_m,cmaxd,cmind,nlevs_d

 end


