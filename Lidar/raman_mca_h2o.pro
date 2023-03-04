Pro RAMAN_MCA_H2O
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
openr,2,'f:\RSI\hues.dat'
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
 year=2009
 ;read,year, prompt='year as 2003: ?  '
 yr=string(year,format='(I4.4)')
  dnm=''
 read,dnm,prompt='data filename as mr022018'
 month=''
 ;read,month,prompt='month:ja,fe,mr,ap,ma,jn....? '
 month=strmid(dnm,0,2)
  ;output path Rayleigh\1995\se\se112342
 ;bpath='d:\lidar_files\RamanData\Raman\MCA_H2O\2009\';
 ;opath= 'd:\lidar_files\RamanData\Raman\MCA_H2O\output\'

  bpath='f:\lidar_data\2008_09_Raman\MCA_H2O\2009\';
  opath= 'F:\RSI\lidar\fernald\new2019\'

 ;bpath='f:\DISC G\lidarpro\Depolar\'
 fpath=bpath+'\'+month+'\'
 ;path='d:\LidarPro\Depolar\2004\mr\mr041947.'  ;072150.' ;202312.'; 312023.'; mr192028.' ;mr312023.'

 ;file_basename1='d:\LidarPro\Depolar\2004\ap\ap022014.' ;
 fnm=fpath+dnm+'.'
 read,ni,nf, prompt='Initial and file number as 1,99: '
 ;read,h1,h2,prompt='Height range in km as 1,5: '
h1=0
h2=2
bnum=500
nx=nf-ni+1
n5=3
na=floor(nx/n5);
  j=0
  T=findgen(8192)
  sigxm=fltarr(nx,bnum);n2-n1+1)
 ; sigxd=fltarr(nx,200)
  sigxm1=fltarr(nx,bnum);n2-n1+1)
 ; sigxd1=fltarr(nx,200)
  pr2m=fltarr(nx,bnum);n2-n1+1)
  pr2m_a=fltarr(na,bnum)
  ht=3.0E8*(160.E-9)*T/2./1000.   ;convert ht to km
   ht1=ht[0:bnum-1]

  b1=round(h1*1000/24)  ;channel number;24 is the height resolution binwidth
   b2=round(h2*1000/24)  ;ch
 FOR n=ni,nf do begin

   sn=strtrim(fix(n),2)
  ;ln=strlen(sn)

   fn1=fnm+strtrim(sn,2)+'m'

   datab=read_binary(fn1,DATA_TYPE=2)
   sig1=datab[0:bnum-1]
   mina=mean(sig1[bnum-200:bnum-1])
   ;mina=mean(sig1[b2:2*b2])   ;background  [b1:b2])
   sigxm1[j,*]=sig1-mina;[n1:n2]-mina
   sigxm=smooth(sigxm1,10)
   pr2m[j,*]=sigxm[j,*]*(ht1^2) ;
      ;pr2m[j,*]=sigm*ht^2


   j=j+1

  ENDFOR


  plot_position1 = [0.1,0.15,0.93,0.49]; plot_position=[0.1,0.15,0.95,0.45]
  plot_position2 = [0.1,0.6,0.93,0.95]; plot_position2=[0.1,0.6,0.95,0.95]
 ;BAR_POSITION1=[0.97,0.2,0.99,0.45]
  BAR_POSITION=[0.97,0.2,0.99,0.5]

  maxa=max(Pr2m[0,b1:b2])
    s1=strtrim(fix(ni),2)
    s2=strtrim(fix(nf),2)
    Sc=dnm+'_Raman_H20                              file:'+s1+'_'+s2
    plot,smooth(pr2m[0,*],20),ht1, background=1,color=2 ,xrange=[0,maxa],yrange=[0,h2],ytitle='km',$
    position=plot_position2,title=Sc
    ;stop
    Nt=nf-ni-1
    ik=0
    for k=0,nx-n5,n5 do begin
     ;print,k,ik
     sum =pr2m[k,*]+pr2m[k+1,*]+pr2m[k+2,*];+pr2m[k+3,*]+pr2m[k+4,*]
     pr2m_a[ik,*]=sum/n5
      oplot,smooth(pr2m_a[ik,*],10)+ik*20,ht1,color=2

     ik=ik+1

    endfor
  stop
  col = 240. ; don't change it

  cmax=150;max(pr2m[150,0:200]);1500;500;./2  use floating point like 25.5
   cmin=cmax/100
  ;nlevs=40
  ;nlevs_max=40
  nlevs_max =20 ; choose what you think is right
 cint = (cmax-cmin)/nlevs_max
 CLEVS = CMIN + FINDGEN(NLEVS_MAX)*CINT
 ;CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
 clevs0 = clevs ; for plot the color bar

 NLEVS = N_ELEMENTS(CLEVS)+1 ;actual number of countour levels


 C_INDEX=(FINDGEN(NLEVS)+1)*col/(NLEVS)
 c_index(NLEVS-1) = 1 ; missing data = white



 f1=string(ni,format='(I3.3)')
 f2=string(nf,format='(I3.3)')
 f3=f1+'--'+f2
  x=findgen(ik)
  y=ht1

 contour,pr2m_a,x,y,xtitle=' time',ytitle='km',xrange=[0,na],yrange=[0,h2],charsize=1.3,charthick=2,LEVELS = CLEVS, /FILL,$
    C_COLORS = C_INDEX, color=2,/FOLLOW,position=Plot_position1;,title=f3
; xyouts,2.5*max(x),2*max(y),f3,/device
 stop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ; plot a color bar, use the same clevs as in the contour
 ; compared with RH
 zb = fltarr(2,nlevs)
 RHmax=100
 RHmin=40
 RHint=(RHmax-RHmin)/(nlevs-1)

  for m = 0, nlevs-1 do zb(0:1,m) = RHmin + cint*m;
 ;  for m = 0, nlevs-2 do zb(0:1,m) = RHmin + RHint*m
     xb = [0,1]

     yb = RHmin + findgen(nlevs)*RHint
     xname = [' ',' ',' ']
     CONTOUR, zb, xb(0:1), yb(0:nlevs-1),position=BAR_POSITION,$
      xrange=[0,1],/xstyle,xtickv=findgen(2),$
      xticks=1,xtickname=xname,yrange =[RHmin,RHmax],/YSTYLE, $
      LEVELS = CLEVS0,C_COLOR = C_INDEX, /FILL, ycharsize=0.7, $
      xcharsize=0.8,/noerase
 xyouts,660,50,'RH',color=2,charthick=1.5,/device


 stop

  DEVICE, DECOMPOSED=0
  ;fnmc=''
  ;read,fnm,prompt='filename to output'
  cntrname =opath+dnm+'H2OB.png'

  WRITE_png, cntrname, TVRD(/TRUE)
stop
 end



