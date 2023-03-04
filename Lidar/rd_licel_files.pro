Pro rd_licel_files

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
;openr,2,'k:\idl62\hues.dat'
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
 ;opath='c:\JB\Raman09\'


 ;bpath='d:\Lidar systems\Raman lidar\2009\ja\'
;path='d:\LidarPro\Raman2009\532_0314\';'d:\Lidar systems\Raman lidar\20090314\532_0314\'
close,/al
 fd=''
 dnm=''

 bpath='f:\RSI\Licel_data\';
 fpath=bpath+'e*'
 Rs=file_search(fpath)
 z1=size(Rs)
  nx=z1[1]   ;nx is the number of files
  print,'number of files; ',nx
  yr=''
  mon=''
  day1=''
  hr=''
  fn1=strmid(Rs[0],13,15)  ;take first file to find year,month,date
  a=strmid(fn1,0,1)
  yr=strmid(fn1,1,2)
  mon=strmid(fn1,3,1)
  day1=strmid(fn1,4,2)
  hr=strmid(fn1,6,2)
 ; read,month,prompt='month:ja,fe,mr,ap,ma,jn....? '
 ;bpath='d:\Lidar systems\Raman lidar\'
; fpath=bpath+yr+'\'+month+'\'
 ;read,dnm,prompt='data file such as mr142042'

  fx=bpath+yr+'\'+mon+'\'+dnm+'.'
 ;fx=bpath+dnm+'.'

T=findgen(4000)
sig1=fltarr(4000)
sig2=fltarr(4000)
ht1=3.0E8*50.E-9*T/2./1000.+0.001   ;convert ht to km and remove 0 with bin resolution 50 ns
;ht1=2*7.5*T/1000  ; ht in km with resoluton 7.5m

; read,h1,h2,prompt='Initial and final height as ,1,5 km:'
  h1=10
  h2=20
 n1=round(h1*1000./7.5)  ;channel number
 n2=round(h2*1000./7.5)  ;ch

 read,ni,nf, prompt='Initial and last file number as 1,99: '
  ;nx=nf-ni+1
 s1=strtrim(fix(ni),2)
 s2=strtrim(fix(nf),2)
 S='                                       file:'+s1+'_'+s2;used to print title
sigxm=fltarr(nx,4000);n2-n1+1)
sigxd=fltarr(nx,4000)
pr2m=fltarr(nx,4000);n2-n1+1)
;pr2d=fltarr(nx,4000)

  j=0
  T=findgen(8192)

FOR n1=ni,nf do begin
   fnm=strmid(Rs[n1],18,15)
 ;  sn=strtrim(fix(n1),2)
  ; fn1=fx+strtrim(sn,2)+'M'
    fn1=bpath+fnm
   openr,2,fn1;/get_lun
   datab=read_binary(fn1,DATA_TYPE=2)
   sig1=datab[0:3999]
   ;readf,2,sig1
   ;sigsm=smooth(sig1,10)
   ;datab=read_binary(fn,DATA_TYPE=2)
    mina=mean(sig1[n2:n2+500])   ;background  [n1:n2])
    sigxm[j,*]=sig1-mina;[n1:n2]-mina

   pr2m[j,*]=sigxm[j,*]*(ht1^2) ;  *ht1^2
   j=j+1
  close,2
  ENDFOR

  col = 240 ; don't change it
cmax=max(pr2m[10,1000:1999])/3;  use floating pt like 24.5
cmin=min(pr2m[10,1000:1999])
nlevs_max=20.
nlevs_max = 20. ; choose what you think is right
 cint = (cmax-cmin)/nlevs_max
 CLEVS = CMIN + FINDGEN(NLEVS_MAX+1)*CINT
 ;CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
 clevs0 = clevs ; for plot the color bar

 NLEVS = N_ELEMENTS(CLEVS)+1 ;actual number of countour levels

    ;print,i0,' cmin,cmax',cmin,cmax,cint,nlevs

    col = 240. ; don't change it
    C_INDEX=(FINDGEN(NLEVS)+1)*col/(NLEVS)
    c_index(NLEVS-1) = 1 ; missing data = white



 plot_position1 = [0.1,0.15,0.93,0.49]; plot_position=[0.1,0.15,0.95,0.45]
 plot_position2 = [0.1,0.6,0.93,0.94]; plot_position2=[0.1,0.6,0.95,0.95]
 BAR_POSITION1=[0.97,0.2,0.99,0.45]
 BAR_POSITION2=[0.97,0.7,0.99,0.95]
 x=findgen(nx)
 contour,pr2m,x,ht1,xtitle='time m channel',ytitle='km', title=dnm+S,yrange=[h1,h2],LEVELS = CLEVS, /FILL,$
    C_COLORS = C_INDEX, color=2,/FOLLOW,position=plot_position1
 ;xyouts,500,5,'fn1',color=1,charsize=2
 ;stop
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
 end