Pro contour_Licel_cirrus_MK

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

  bpath='f:\Lidar_data\'
 ;bpath='d:\Lidar systems\Raman lidar\2009\ja\'
;path='d:\LidarPro\Raman2009\532_0314\';'d:\Lidar systems\Raman lidar\20090314\532_0314\'
close,/all
fd=''
dnm=''
T=findgen(4000)
sig1=fltarr(4000)
sig2=fltarr(4000)
dt=50e-9
ht1=3.0E8*dt*T/2./1000.+0.001   ;convert ht to km and remove 0 with bin resolution 50 ns
;ht1=2*7.5*T/1000  ; ht in km with resoluton 7.5m
year=2007
 ;read,year, prompt='year as 2003: ?  '
 yr=string(year,format='(I4.4)')

 month=''
 ; read,month,prompt='month:ja,fe,mr,ap,ma,jn....? '
 ;bpath='d:\Lidar systems\Raman lidar\'
; fpath=bpath+yr+'\'+month+'\'
 read,dnm,prompt='data file such as mr142042'
 month=strmid(dnm,0,2)
 fx=bpath+yr+'\'+month+'\'+dnm+'.'
 ;fx=bpath+dnm+'.'

; read,h1,h2,prompt='Initial and final height as ,1,5 km:'
  h1=1.0
  h2=20
 n1=round(h1*1000./7.5)  ;channel number
 n2=round(h2*1000./7.5)  ;ch

 read,ni,nf, prompt='Initial and last file number as 1,99: '
  nx=nf-ni+1
 s1=strtrim(fix(ni),2)
 s2=strtrim(fix(nf),2)
 S='                                           file:'+s1+'_'+s2;used to print title
sigxm=fltarr(nx,4000);n2-n1+1)
sigxd=fltarr(nx,4000)
pr2m=fltarr(nx,4000);n2-n1+1)
pr2d=fltarr(nx,4000)

  j=0
  T=findgen(8192)


 ;FOR n=ni,nf do begin
 ;;;;;;;;;;;;;;;;;;;;
 FOR n1=ni+1,nf do begin
   sn=strtrim(fix(n1),2)
   fn1=fx+strtrim(sn,2)+'M'

   openr,2,fn1;/get_lun
   readf,2,sig1
   ;sigsm=smooth(sig1,10)
   ; sig1=read_binary(fn,DATA_TYPE=2)
    mina=mean(sig1[n2:n2+500])   ;background  [n1:n2])
   sigxm[j,*]=sig1-mina;[n1:n2]-mina

   pr2m[j,*]=sigxm[j,*]*(ht1^2) ;  *ht1^2
   j=j+1
  close,2
  ENDFOR

  col = 240 ; don't change it
  cmax=5*max(pr2m[10,0:999])/3;  use floating pt like 24.5
  cmin=min(pr2m[10,0:999])
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
 contour,pr2m,x,ht1,xtitle='time (min)',ytitle='km', title=S,   yrange=[h1,h2],LEVELS = CLEVS, /FILL,$
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


 ;stop
 k=0


 FOR nd=ni+1,nf do begin
   sn=strtrim(fix(nd),2)
   fn2=fx+strtrim(sn,2)+'D'

    openr,3,fn2;/get_lun
    readf,3,sig2
    ; sig2=read_binary(fn2,DATA_TYPE=2)
    minb=mean(sig2[n2:500+n2])

   sigxd[k,*]=sig2-minb

   pr2d[k,*]=10*sigxd[k,*]*(ht1^2)


   k=k+1
  close,3
  ENDFOR
  col = 240. ; don't change it
  cmaxd=5*max(pr2d[10,0:999])/3; 50
  cmind=0;min(pr2d[10,0:999])

  nlevs_max =20. ;.choose what you think is right
   cintd = (cmaxd-cmind)/nlevs_max
   CLEVSd = CMINd + FINDGEN(NLEVS_MAX+1)*CINTD
   ;CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
   clevs0 = clevsd ; for plot the color bar

    NLEVS = N_ELEMENTS(CLEVSd)+1 ;actual number of countour levels

    ;print,i0,' cmin,cmax',cmin,cmax,cint,nlevs

    col = 240. ; don't change it
    C_INDEX=(FINDGEN(NLEVS)+1)*col/NLEVS
    ;c_index(NLEVS-1) = 1 ; missing data = white



   contour,pr2d,x,ht1,ytitle='km',title=dnm,yrange=[h1,h2],LEVELS = CLEVSD, /FILL,$
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


   ;read,fnm,prompt='affix filename to output'
  ; cntrname =opath+dnm+fnm+'.tiff'

  cntrname =bpath+yr+'\output\'+dnm+'.png
;WRITE_png, cntrname, TVRD(/TRUE)
 stop
 ;read,n,prompt='plot file for nth data ;'
 a=max(pr2m[0,*])
 b=max(pr2d[0,*])
 plot,smooth(pr2m[0,*],20),ht1,xrange=[0,a],yrange=[h1,h2],xtitle='count',ytitle='km',title='perpendicular'
plot,smooth(pr2d[0,*],20),ht1,xrange=[0,b/10],yrange=[h1,h2],xtitle='count',ytitle='km',title='parallel'
for np=5,nx-1,5 do begin
oplot,smooth(pr2m[np,*],20)+np*5,ht1,color=2
oplot,smooth(pr2d[np,*],20)+np*5,ht1,color=3
endfor
stop
cntrname =bpath+yr+'\output\'+dnm+'_plt.png
;WRITE_png, cntrname, TVRD(/TRUE)
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

