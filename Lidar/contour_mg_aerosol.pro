Pro contour_MG_aerosol
ERASE
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
openr,2,'E:\rsi\hues.dat'
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

close,/all
fd=''
dnm=''
bnum=1000
T=findgen(bnum)
sig1=fltarr(bnum)
sig2=fltarr(bnum)
dt=50;
c=3.0e8
dz=dt*1.e-9*c/2
ht1=dz*T/1000.;   ;convert ht to km and remove 0 with bin resolution 50 ns

htm=ht1*1000 ; ht in m
year=2020
; read,year, prompt='year as 2009: ?  '
 yr=string(year,format='(I4.4)')

 month=''
 ; read,month,prompt='month:ja,fe,mr,ap,ma,jn....? '
 ;bpath='d:\Lidar systems\Raman lidar\'
; fpath=bpath+yr+'\'+month+'\'
 read,dnm,prompt='data file name as 0807 ASC '
 month=strmid(dnm,0,2)
 bpath='E:\Lidar_data\'
 fx=bpath+yr+'\ASC\'+dnm+'\a*'
 ;fx=bpath+dnm+'.'
 fls=file_search(fx)
   Sf=size(fls)
    PRINT,'NUM OF TOTAL FILES IN THIS DIRECTORY: ',SF

  STOP

  ; SEARCH files of the day, starting with 0


da=strmid(dnm,0,4)

print,da  ;day of data

 read,ni,nf, prompt='Initial and last file number as 1,99: '
  nx=nf-ni+1
 s1=strtrim(fix(ni),2)
 s2=strtrim(fix(nf),2)
 S='     file:'+s1+'_'+s2;used to print title
sigxm=fltarr(nx,bnum);n2-n1+1)
sigxd=fltarr(nx,bnum)
pr2m=fltarr(nx,bnum);n2-n1+1)
pr2d=fltarr(nx,bnum)

  j=0
  T=findgen(8192)

 read,h1,h2,prompt='Initial and final height as ,1,5 km:'
 n1=round(h1*1000./7.5)  ;channel number
 n2=round(h2*1000./7.5)  ;ch
 ;;;;;;;;;;;;;;;;;;;;
 FOR n1=ni+1,nf do begin
   sn=strtrim(fix(n1),2)
   fn1=fx+strtrim(sn,2)+'M'

   openr,2,fn1;/get_lun
   readf,2,sig1
   ;sigsm=smooth(sig1,10)
   ;datab=read_binary(fn,DATA_TYPE=2)
    bk1=min(sig1[bnum-500:bnum-1])   ;background  [n1:n2])
   sigxm[j,*]=sig1-bk1;[n1:n2]-bk1

   pr2m[j,*]=sigxm[j,*]*(ht1^2) ;  *ht1^2
   PR2M[j,*]=smooth(Pr2m[j,*],10)
   j=j+1
  close,2
  ENDFOR

col = 240 ; don't change it
cmax=1*max(pr2m[(nf-NI)/2,50:599])
cmin=cmax/30
nlevs_max = 40. ; choose what you think is right
 cint = (cmax-cmin)/nlevs_max
 CLEVS = CMIN + FINDGEN(NLEVS_MAX+1)*CINT
 ;CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
 clevs0 = clevs ; for plot the color bar

 NLEVS = N_ELEMENTS(CLEVS)+1 ;actual number of countour levels

    ;print,i0,' cmin,cmax',cmin,cmax,cint,nlevs

    col = 240. ; don't change it
    C_INDEX=(FINDGEN(NLEVS)+1)*col/(NLEVS)
    c_index(NLEVS-1) = 1 ; missing data = white



 pl1 = [0.1,0.15,0.93,0.49]; plot_position=[0.1,0.15,0.95,0.45]
 pl2 = [0.1,0.6,0.93,0.94]; plot_position2=[0.1,0.6,0.95,0.95]
 BAR_POSITION1=[0.97,0.2,0.99,0.45]
 BAR_POSITION2=[0.97,0.7,0.99,0.95]
 x=findgen(nx)
 contour,pr2m,x,ht1,xtitle='Time (min)',ytitle='Height (km)',xrange=[0,nf-ni],yrange=[h1,h2],LEVELS = CLEVS, /FILL,$
    C_COLORS = C_INDEX, color=2,/FOLLOW,charsize=1.5,charthick=2,$
   position=pl1
 xyouts,500,150,'Parallel channel',color=2,charsize=1.2,/device
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

 xyouts,500,150,'Parallel channel',color=2,charsize=1.2
 stop
 k=0


 FOR nd=ni+1,nf do begin
   sn=strtrim(fix(nd),2)
   fn2=fx+strtrim(sn,2)+'D'
   ;datab=read_binary(fn2,DATA_TYPE=2)
    openr,3,fn2;/get_lun
    readf,3,sig2
    bk2=min(sig2[bnum-500:bnum-1])

   sigxd[k,*]=sig2-bk2

   PR2D[k,*]=sigxd[k,*]*(ht1^2)
   pr2d[k,*]=smooth(PR2D[k,*],10);

   k=k+1
  close,3
  ENDFOR
  col = 240. ; don't change it
cmaxd=1*max(pr2d[(nf-NI)/2,50:599]); 50
cmind=cmax/20.;  0;min(pr2d[10,1000:1999])

nlevs_max =40. ;.choose what you think is right
 cintd = (cmaxd-cmind)/nlevs_max
 CLEVSd = CMINd + FINDGEN(NLEVS_MAX+1)*CINTD
 ;CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
 clevs0 = clevsd ; for plot the color bar

 NLEVS = N_ELEMENTS(CLEVSd)+1 ;actual number of countour levels

    ;print,i0,' cmin,cmax',cmin,cmax,cint,nlevs

    col = 240. ; don't change it
    C_INDEX=(FINDGEN(NLEVS)+1)*col/NLEVS
    ;c_index(NLEVS-1) = 1 ; missing data = white



   contour,pr2d,x,ht1,ytitle='Height (km)',xrange=[0,nf-ni],yrange=[h1,h2],LEVELS = CLEVSD, /FILL,$
    C_COLORS = C_INDEX, color=2,/FOLLOW,charsize=1.5,charthick=2,$
    position=pl2;, title=dnm+s

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
   xyouts,500,330,'Perpend. channel',color=2,charsize=1.2,/device
   xyouts,100,330,yr+dnm,color=2,charsize=1.2,/device
  stop

  DEVICE, DECOMPOSED=0
 ; opath='f:\Lidar_data\output812\'
   ;read,fnm,prompt='affix filename to output'
  ; cntrname =opath+dnm+fnm+'.tiff'
  opath='f:\rsi\lidar\ev_plots\'
  FNM=STRMID(DNM,0,4)

  cntrname =opath+Fnm+'.png'
  WRITE_png, cntrname, TVRD(/TRUE)
stop
!P. multi=[0,1,1]
;read,n,prompt='plot file for nth data ;'
a=max(pr2m[0,10:300])
b=max(pr2d[0,10:300])

;;;;adjust range here
plot,smooth(pr2m[0,*],10),ht1,xrange=[0, 1*a],yrange=[h1,h2],xtitle='count',ytitle='km',$
title='parallel/perpend.'; position=pl1
;;;; plot average 5 profiles
read,nt1,nt2,prompt='1st and last file numbers to plot'

For J2=nt1,nt2-1 do begin
 I2=0
 oplot,smooth(pr2m[J2,*],10)+200*I2,ht1
 oplot,smooth(Pr2d[J2,*],10)+400*I2,ht1,color=250
I2=I2+10
endfor ;J2
stop
;plot,smooth(pr2d[ni,*],10),ht1,xrange=[0,b],yrange=[h1,h2],ytitle='km',$
;title='perpendicular', position=pl2
pltname =opath+yr+dnm+'_pr2m.png'


WRITE_png, cntrname, TVRD(/TRUE)
print,'files range, cmax/cmin, cmaxd/cmind:',ni,nf,cmax,cmin,cmaxd,cmind

stop
 end



