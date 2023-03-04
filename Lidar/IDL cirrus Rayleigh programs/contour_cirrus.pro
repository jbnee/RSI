Pro contour_cirrus
;
device, decomposed=0
;
;-----------------------------
;start with a colour table, read in from an external file hues.dat
rgb = bytarr(3,256)
openr,2,'d:\rsi\hues.dat'
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

;col = 240 ; don't change it
;cmax=200
;cmin=5
;nlevs_max=20
;nlevs_max = 20 ; choose what you think is right
 ;cint = (cmax-cmin)/nlevs_max
 ;CLEVS = CMIN + FINDGEN(NLEVS_MAX+1)*CINT
 ;CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
 ;clevs0 = clevs ; for plot the color bar

 NLEVS = N_ELEMENTS(CLEVS)+1 ;actual number of countour levels

    ;print,i0,' cmin,cmax',cmin,cmax,cint,nlevs

    col = 240 ; don't change it
    C_INDEX=(FINDGEN(NLEVS)+1)*col/(NLEVS)
    c_index(NLEVS-1) = 1 ; missing data = white


i0=1
 plot_position1 = [0.1,0.15,0.98,0.49]; plot_position=[0.1,0.15,0.95,0.45]
 plot_position2 = [0.1,0.6,0.98,0.98]; plot_position2=[0.1,0.6,0.95,0.95]
 BAR_POSITION1=[0.95,0.2,0.97,0.45]
 BAR_POSITION2=[0.95,0.7,0.97,0.95]



;openr,1,"d:\LidarPro\DATA\Rayleigh\1999\FE\Fe092341.2R"
;fn="D:\Lidar systems\lidarPro\Rayleigh\1993\se\se112342.';se010044.10m"
;path='d:\LidarPro\Rayleigh\1995\se\se112342.';.'
 read,year, prompt='year as 2003: ?  '
 yr=string(year,format='(I4.4)')
 month=''
 read,month,prompt='month:ja,fe,mr,ap,ma,jn....? '
 bpath='d:\Lidar systems\Rayleigh\'
 fpath=bpath+yr+'\'+month+'\'
 ;path='d:\LidarPro\Depolar\2004\mr\mr041947.'  ;072150.' ;202312.'; 312023.'; mr192028.' ;mr312023.'
dnm=''
 read,dnm,prompt='data filename as mr022018    ???'
 ;file_basename1='d:\LidarPro\Depolar\2004\ap\ap022014.' ;
 fnm=fpath+dnm+'.'
read,ni,nf, prompt='Initial and file number as 1,99: '
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

  ;fn=file_basename1+strtrim(sn,2)+'m'
   fn1=fnm+strtrim(sn,2)+'m'
   datab=read_binary(fn1,DATA_TYPE=2)
   sig=datab[0:1999]
   pr2m[j,*]=sig*ht^2
   x=findgen(nx)
   y=ht1

   j=j+1

  ENDFOR
 ;plot setup

 col=240; don't change
 NLEVS_MAX=20
 cmax=max(Pr2m)/2
 cmin=max(Pr2m)/100
 cint = (cmax-cmin)/ NLEVS_MAX
 CLEVS = CMIN + FINDGEN(NLEVS_MAX+1)*CINT
 ;CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
 clevs0 = clevs ; for plot the color bar
 NLEVS = N_ELEMENTS(CLEVS)+1 ;actual number of countour levels

 C_INDEX=(FINDGEN(NLEVS)+1)*col/(NLEVS)
 c_index(NLEVS-1) = 1 ; missing data = white



 ;nlevs_max=20nlevs_max
;CLEVS = CMIN + FINDGEN(NLEVS_MAX+1)*CINT
;CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
 ;C_INDEX=(FINDGEN(NLEVS)+1)*col/(NLEVS)
 ;c_index(NLEVS-1) = 1 ; missing data = white


 ;plot_position = [0.1+i0*0.45,0.6,0.45+i0*0.45,0.9]
  plot_position = [0,0,0.9,0.95]
 ;BAR_POSITION=[0.50+i0*0.45,0.6,0.51+i0*0.45,0.9]
  BAR_POSITION=[0.9,0.1,0.95,0.5]
 contour,pr2m,x,y,xtitle='time',ytitle='km',yrange=[10,20],LEVELS = CLEVS, /FILL,$
    C_COLORS = C_INDEX, xcharsize=1.5,ycharsize=1.5, color=2,/FOLLOW
 xyouts,500,5,'fn',color=1,charsize=2
 stop
 ; plot a color bar, use the same clevs as in the contour
    nlevs=40
    zb = fltarr(2,nlevs)
    for k = 0, nlevs-1 do zb(0:1,k) = cmin + cint*k
     xb = [0,1]
     yb = cmin + findgen(nlevs)*cint
     xname = [' ',' ',' ']
  CONTOUR, zb, xb(0:1), yb(0:nlevs-1),position=bar_position,$
      xrange=[0,1],/xstyle,xtickv=findgen(2),$
      xticks=1,xtickname=xname,yrange =[cmin,cmax],/YSTYLE, $
      LEVELS = CLEVS,C_COLOR = C_INDEX, /FILL, ycharsize=1, $
      xcharsize=1,/noerase


 stop
 close,1

 ;print image to a png file
DEVICE, GET_DECOMPOSED=old_decomposed
DEVICE, DECOMPOSED=0
cntrname =bpath+'contour\'+dnm+'.png'
WRITE_PNG, cntrname, TVRD(/TRUE)
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

