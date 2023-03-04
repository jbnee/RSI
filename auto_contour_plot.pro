Pro auto_contour_plot
;auto plot all lidar data by search filelist
;also name:contour_aerosol_search_plot
;in the data list, number must follow by name with only one space as Ap082011 230
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
plot_position1 = [0.1,0.15,0.90,0.49]; plot_position=[0.1,0.15,0.95,0.45]
 plot_position2 = [0.1,0.6,0.90,0.95]; plot_position2=[0.1,0.6,0.95,0.95]
 BAR_POSITION1=[0.97,0.2,0.99,0.45]
 BAR_POSITION2=[0.97,0.7,0.99,0.95]

 year='2009'

 ; read,year, prompt='year as 2009: ?  '
  yr=string(year,format='(I4.4)')

 files=''
 read,files,prompt='name of the list file: as FILES2004July.txt'
 PATH1='E:\RSI\LIDAR\DATA_list\'+files; FILES2004July.TXT'
 READ,Nz, PROMPT='INPUT NUMBER OF FILES AS 9 '
 XNM=STRARR(Nz)
 YNM=INTARR(nz)
 LN1=''
 OPENR,1,PATH1
 FOR Ns=0,Nz-1 do begin


 READF,1,LN1
 ;PRINT,LN1
 xnm[ns]=strmid(LN1,0,8)  ;filename
 ynm[ns]=strmid(LN1,9,6) ;file number
 print,xnm[NS],Ynm[NS]
;WHILE N LT 10 DO BEGIN

 endfor ;Ns
 STOP
 read,h1,h2,prompt='Height regions as 5,10 km: '

month=strmid(Xnm[0],0,2)
mn=strmid(month,0,2)
 ;read,month,prompt='month:ja,fe,mr,ap,ma,jn....? '
 bpath='E:\lidar_data\';  +yr+'\'+month
 FOR Nj=0,NZ-1 do begin
   dnm=xnm[NJ]
    ; read,dnm,prompt='data filename as mr022018'
   month=strmid(dnm,0,2)

  ; bpath='F:\Lidar_data\';   systems\depolar\'
   fnm=bpath+yr+'\'+month+'\'+dnm+'.';

   ; fnm=FILE_SEARCH(fpath); +'.'
  ;print,size(fnm)
    ;
  ;STOP
  ni=1
  nf=ynm[NJ]

; read,ni,nf, prompt='Initial and file number as 1,99: '
 ;read,h1,h2,prompt='Height range in km as 1,5: '
  nx=nf-ni+1
  j=0
  bnum=1000  ;total bin number
  T=findgen(bnum)
  datab=fltarr(bnum)
  pr2m=fltarr(nx,bnum)
  pr2d=fltarr(nx,bnum)
  ;fbk=fltarr(nx)
  ;dt=50; nanosecond
  dt=50;
  ht=3.0E8*dt*1.E-9*T/2./1000.   ;convert ht to km
   ht1=ht[0:bnum-1]
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
   y=ht1

   j=j+1
   close,1
  ENDFOR;n

  col = 240 ; don't change it

  cmax=0.5*max(pr2m[nx/2,10:200]);400;1500;500;./2
  cmin=cmax/100; cmax/10;min(pr2m[nf-ni-nx/2,0:200])

  nlevs_max =20. ; choose what you think is right
 cint = (cmax-cmin)/nlevs_max
 CLEVS = CMIN + FINDGEN(NLEVS_MAX+1)*CINT
 ;CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
 clevs0 = clevs ; for plot the color bar

 NLEVS = N_ELEMENTS(CLEVS)+1 ;actual number of countour levels


 C_INDEX=(FINDGEN(NLEVS)+1)*col/(NLEVS)
 c_index(NLEVS-1) = 1 ; missing data = white

 ;f1=string(ni,format='(I3.3)')
 ;f2=string(nf,format='(I3.3)')
 ;f3=f1+'--'+f2
 s1=strtrim(fix(ni),2)
 s2=strtrim(fix(nf),2)
 S='                                       file:'+s1+'_'+s2;used to print title
 xtitle=yr+dnm
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
 STOP

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

   x=findgen(nx)
   y=ht1


   k=k+1
   close,2
  ENDFOR  ;nd

  col = 240 ; don't change it
  cmaxd=0.5*max(pr2d[nx/2,10:200]);300;   0./5
  cmind=cmaxd/20.
   nlevs_max =10.
  cint = (cmaxd-cmind)/nlevs_max
  CLEVS = CMIND + FINDGEN(NLEVS_MAX+1)*CINT
 ;CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
  clevs0 = clevs ; for plot the color bar
  NLEVS = N_ELEMENTS(CLEVS)+1 ;actual number of countour levels


   C_INDEX=(FINDGEN(NLEVS)+1)*col/(NLEVS)
   c_index(NLEVS-1) = 1 ; missing data = white

   ;!x.range=[ni,ni+nf]
   contour,pr2d,x,y,xtitle='d channel time',ytitle='km',title=xtitle, yrange=[h1,h2],LEVELS = CLEVS, /FILL,$
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
 ; stop

WAIT,2
  ;opath='E:\lidar_data\output\'   ;output path Rayleigh\1995\se\se112342
   opath2='E:\cirrus clouds\cirrus_2009\';
    cname =opath2+yr+'_'+dnm+'A.png
WRITE_png,cname,TVRD(/TRUE)
;stop
ENDFOR ; NJ


 end



