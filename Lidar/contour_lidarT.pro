Pro contour_LidarT
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
;cmax=20.
;cmin=-20.
Cmax=20
cmin=-20
nlevs_max=40

    nlevs_max = 20 ; choose what you think is right
    cint = (cmax-cmin)/nlevs_max
    CLEVS = CMIN + FINDGEN(NLEVS_MAX+1)*CINT
    CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
    clevs0 = clevs ; for plot the color bar

    NLEVS = N_ELEMENTS(CLEVS)+1 ;actual number of countour levels

    ;print,i0,' cmin,cmax',cmin,cmax,cint,nlevs

    col = 240 ; don't change it
    C_INDEX=(FINDGEN(NLEVS)+1)*col/(NLEVS)
    c_index(NLEVS-1) = 1 ; missing data = white

   col = 240 ; don't change it

i0=1
 plot_position = [0.1+i0*0.45,0.6,0.45+i0*0.45,0.9]
 BAR_POSITION=[0.50+i0*0.47,0.6,0.52+i0*0.47,0.9]
close,/all

;Tdata=fltarr(16,915)  ;for Lidar_T2000JN06 last line for radio
;Tdata=fltarr(15,915)
;openr,1,"d:\RSI\Lidar\Ray_data\Lidar_T2000JN07.txt"
path="d:\RSI\Lidar\Ray_data\"
file1=''
read,file1,prompt='file catelog as 2000DT txt?  '
dnm=''
read,dnm,prompt='data name as 20000607 : '
read,col,prompt='input column number as 15,23etc.look data file first:  '
Tdata=fltarr(col,915)
file2=path+file1+'\'+dnm+'.dat'
openr,1,file2

 readf,1,line
 readf,1,Tdata
 y=Tdata[0,*]
 x=findgen(col-1)
 ;radio=Tdata[15,*]; this is for Lidar_T2000JN07
 Zdata=Tdata[1:col-1,*]



 contour,zdata,x,y,xtitle='time',ytitle='km',yrange=[10,30],LEVELS = CLEVS, /FILL,$
    C_COLORS = C_INDEX, color=2,/FOLLOW
 ;xyouts,500,5,'fn',color=1,charsize=2
 stop
 ; plot a color bar, use the same clevs as in the contour
    ;nlevs=10
    zb = fltarr(2,nlevs)

    for k = 0, nlevs-1 do zb(0:1,k) = cmin + cint*k
     xb = [0,2]
     yb = cmin + findgen(nlevs)*cint
     xname = [' ',' ',' ']
     CONTOUR, zb, xb(0:1), yb(0:nlevs-1),position=bar_position,$
      xrange=[0,1],/xstyle,xtickv=findgen(2),$
      xticks=1,xtickname=xname,yrange =[cmin,cmax],/YSTYLE, $
      LEVELS = CLEVS0,C_COLOR = C_INDEX, /FILL, ycharsize=0.7, $
      xcharsize=0.8,/noerase


 stop
 close,1
 DEVICE, GET_DECOMPOSED=old_decomposed
 DEVICE, DECOMPOSED=0
 fnm=''
 read,fnm,prompt='filename to output'
filename ='d:\RSI\Lidar\Ray_data\'+fnm+'.png'

WRITE_PNG, filename, TVRD(/TRUE)

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

