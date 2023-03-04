Pro contour_plot_ratio

device, decomposed=0

!p.multi=[0,1,2]
!p.background=255
 loadct,39
plot,[0,10],[-1,1],COLOR = 0
plot,[0,1],xrange=[0,20],yrange=[-2,2],/nodata,COLOR = 0
oplot,[0,20],[1.5,1.5],COLOR = 50


 read,year, prompt='year as 2003: ?  '
 yr=string(year,format='(I4.4)')
 month=''
 dnm=''
 read,dnm,prompt='data filename as mr022018'
 month=strmid(dnm,0,2)

 ;bpath='e:\DISC G\lidarpro\Depolar\';+yr+month
 opath='F:\Lidar_DATA\OutOUT2018\'   ;output path Rayleigh\1995\se\se112342
 bpath='F:\Lidar_DATA\';    systems\Depolar\';

 fpath=bpath+yr+'\'+month+'\'
 ;path='d:\LidarPro\Depolar\2004\mr\mr041947.'  ;072150.' ;202312.'; 312023.'; mr192028.' ;mr312023.'

  fpath=bpath+yr+'\'+month+'\'
 fnm=fpath+dnm+'.'; fpath+dnm+'.'
read,ni,nf, prompt='Initial and file number as 1,99: '
read,h1,h2,prompt='Height range in km as 1,5: '
  nx=nf-ni+1
  j=0
  k=0
  T=findgen(8192)
  pr2m=fltarr(nx,2000)
  pr2d=fltarr(nx,2000)
  ht=3.0E8*160.E-9*T/2./1000.   ;convert ht to km
   ht1=ht[0:1999]
   pk=fltarr(2,nf-ni+1)
 FOR n=ni,nf do begin

   sn=strtrim(fix(n),2)
  ;ln=strlen(sn)

   fn1=fnm+strtrim(sn,2)+'m'
   fn2=fnm+strtrim(sn,2)+'d'
   datab=read_binary(fn1,DATA_TYPE=2)
   datad=read_binary(fn2,DATA_TYPE=2)

   sigm=datab[0:1999]
    ;sigm=smooth(sigm,10)
   sigd=datad[0:1999]
   ;sigd=smooth(sigd,10)
   pr2m[j,*]=sigm*ht^2
   pr2d[k,*]=sigd*ht^2

   j=j+1
   k=k+1
  ENDFOR

 plot_position1 = [0.1,0.15,0.93,0.49]; plot_position=[0.1,0.15,0.95,0.45]
 plot_position2 = [0.1,0.6,0.93,0.95]; plot_position2=[0.1,0.6,0.95,0.95]
 ;BAR_POSITION1=[0.97,0.2,0.99,0.45]
 ;BAR_POSITION2=[0.97,0.7,0.99,0.95]

 s1=strtrim(fix(ni),2)
 s2=strtrim(fix(nf),2)
 S='                                       file:'+s1+'_'+s2;used to print title

   ; DEVICE, DECOMPOSED=0
   ;fnmc=''
  ; read,fnm,prompt='filename to output'
    ;cntrname =opath+fnm+dnm+'.tiff'

   ;WRITE_tiff, cntrname, TVRD(/TRUE)

    s0=strtrim(fix(ni),2)

    read,hx,prompt='input height of  cloud presence as 2 km: '
    ichn=round(hx/0.024)  ; chnn number

    plot,pr2d[0,ichn:ichn+49],color=2,background=-2,position=plot_position1
    oplot,pr2m[0,ichn:ichn+49],color=2
    for ix1=1,nf-ni do begin
    sn=strtrim(fix(ix1),2)

    oplot,pr2d[sn,ichn:ichn+49],color=2
    ;wait,2
    endfor;ix1
    ;stop

     dmratio0=pr2m[s0,ichn:ichn+49]/pr2d[s0,ichn:ichn+49]
    plot,smooth(dmratio0,5),color=2,position=plot_position2;yrange=[0,0.2]


    for ix2=1,nf-ni do begin
    sn=strtrim(fix(ix2),2)
    dmratio=pr2m[sn,ichn:ichn+49]/(pr2d[sn,ichn:ichn+49]+pr2m[sn,ichn:ichn+49])
    pkratio=max(dmratio)
    bin1=where(dmratio eq pkratio)
    pk[*,ix2]=[bin1,pkratio]

    oplot,smooth(dmratio,5),color=2;
    xyouts,bin1,pkratio,sn+ni,color=2
;wait,2
    endfor  ;ix2
    stop
    x=pk[0,*]
    y=pk[1,*]
    plot,x,color=2,psym=2,xtitle='ht position'
    plot,y,color=2,psym=2,xtitle='peak d/m value'
    stop
     DEVICE, DECOMPOSED=0
  ;fnmc=''
   read,fnm,prompt='filename to output'
   cntrname =opath+fnm+dnm+'.BMP'

   WRITE_BMP, cntrname, TVRD(/TRUE)

    stop


 end

 ;;;;Rayleigh backscattering coefficient
;;;;;;;; density of air is the polynomial fit of height determined from radiosonde
  ;lidar eq: S=k*J*[beta_a+beta_c]*T/z^2  a:air; c: clouds
   ; density= 1.E25*(2.4498-0.22114*ht1+0.00701*ht1^2-7.75225E-5*ht1^3)  ;ht in km; in molec/m3
   ; beta_r=5.45E-32*(550./532.)^4*density  ;Rayleigh backscattering coefficient
   ; cxsray=(8*3.1416/3.)*beta_r   ;Rayleigh cross section
   ; kext=cxsray*density                   ;Rayleigh extinction
   ; transm=exp(-2*kext)             ;atmosph transmission
   ; y=dblarr(800)             ;
    ;Sg=sig[0:800]   ;bin 400 is 9.6 km
    ;ht1=ht1[0:800]
   ; y=(Sg*ht1^2)/(transm*beta_r); pr^2/T
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

