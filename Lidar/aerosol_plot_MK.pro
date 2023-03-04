
Pro aerosol_plot_MK
;plot m/d file: parallel polarization
;-----------------------------
device, decomposed=0

!p.multi=[0,1,2]
!p.background=255
 ;loadct,39
plot,[0,10],[-1,1],COLOR = 0
plot,[0,1],xrange=[0,20],yrange=[-2,2],/nodata,COLOR = 0
oplot,[0,20],[1.5,1.5];COLOR = 50
;stop
plot_position1 = [0.1,0.15,0.98,0.49]; plot_position=[0.1,0.15,0.95,0.45]
   plot_position2 = [0.1,0.6,0.98,0.94]; plot_position2=[0.1,0.6,0.95,0.95]
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 read,year, prompt='year as 2003: ?  '
 ;year=2009
 yr=string(year,format='(I4.4)')
  dnm=''
 read,dnm,prompt='data filename as mr022018    ???'
 month=''
 month=strmid(dnm,0,2)
; read,month,prompt='month:ja,fe,mr,ap,ma,jn....? '
 bpath='D:\Lidar_data\'
 ;bpath='d:\Lidar systems\Rayleigh\'
 fpath=bpath+yr+'\'+month+'\'
 ;path='d:\LidarPro\Depolar\2004\mr\mr041947.'  ;072150.' ;202312.'; 312023.'; mr192028.' ;mr312023.'

 ;file_basename1='d:\LidarPro\Depolar\2004\ap\ap022014.' ;
 fnm=fpath+dnm+'.'
;資料夾輸入:
;file_basename1='d:\LidarPro\Data\2002mr\';mr312023.'  ;072150.' ;202312.'; 312023.'; mr192028.' ;mr312023.'

fn1=''
fn2=''
; 資料檔輸入
;read,fd,prompt='data file such as mr182309'
;fx=path+fd+'.'
read,ni,nf, prompt='Initial and last file number as 1,99: '
  nx=nf-ni+1
 s1=strtrim(fix(ni),2)
 s2=strtrim(fix(nf),2)
 S=dnm+'                                       file:'+s1+'_'+s2
read,h1,h2,prompt='Initial and final height as ,1,5 km:'

  T=findgen(2000)
  pr2m=fltarr(nx,2000)
  pr2d=fltarr(nx,2000)
  dz=24.0
  ht=3.0E8*160.E-9*T/2./1000.   ;convert ht to km
  bin=h2*1000/dz
  ht1=ht[0:bin]


    fn1=fnm+strtrim(fix(ni),2)+'m'

    data_M=read_binary(fn1,DATA_TYPE=2)

    j=0
    sig1=data_m[0:bin]
    pr2m[j,0:bin]=smooth(sig1,10);*ht^2

    maxa=max(Pr2m[j,0:bin])
    dv=maxa/nx
   plot,Pr2m[j,0:bin],ht1,color=2,background=-2,position=plot_position1,xrange=[0,2*maxa],yrange=[h1,h2],xtitle='m channel',ytitle='km' ,title=S

   stop
   j=1

   FOR n=ni+1,nf do begin

   sn=strtrim(fix(n),2)
  ;ln=strlen(sn)

   fn1=fnm+strtrim(sn,2)+'m'

   data_a=read_binary(fn1,DATA_TYPE=2)
   sig1=data_a[0:bin]
   sig=smooth(sig1,10) ;smooth by 10
   pr2m[j,0:bin]=sig*ht1^2
   ;oplot,sig+50*j,ht1, color=2 ;background=-2,color=1,xtitle='Signal/channel',ytitle='km'
   oplot,pr2m[j,0:bin]+2*dv*j,ht1,color=2;
   j=j+1
  ;xyouts,1000+300*n,30,n,color=1,charsize=1


  ENDFOR
  stop
 ;;;;;;;;;;;;
 ;;d file;;;;;;;;;;;;;;;;;;
     j2=0
    fn2=fnm+strtrim(fix(ni),2)+'d'
    data_d=read_binary(fn2,DATA_TYPE=2)

    ; datab=read_ascii(fn1)
    sig2=data_d[0:bin]
    pr2d[j2,0:bin]=smooth(sig2,10)*ht1^2

    maxb=max(Pr2d[j2,*])
    dv=maxb/nx
    plot,pr2d[j2,0:bin],ht1,position=plot_position2, background=-2,color=2,xrange=[0,10*maxb],yrange=[h1,h2],xtitle='m channel',ytitle='km' ,title=S


  FOR nd=ni+1,nf do begin
   sn2=strtrim(fix(nd),2)
  ;ln=strlen(sn)

   fn2=fnm+strtrim(sn2,2)+'d'

   data_d=read_binary(fn2,DATA_TYPE=2)
   sig2=data_d[0:bin]
   sig_d=smooth(sig2,10)
   pr2d[j2,0:bin]=sig_d*ht1^2
   ;oplot,sig+50*j,ht1, color=2 ;background=-2,color=1,xtitle='Signal/channel',ytitle='km'
   oplot,pr2d[j2,0:bin]+dv*j2*10,ht1,color=2;
   j2=j2+1
  ;xyouts,1000+300*n,30,n,color=1,charsize=1


  ENDFOR
stop
 DEVICE, DECOMPOSED=0

   outnm=dnm+'_plt.tiff'
   cntrname ='f:\Lidar_data\output\'+outnm; \lidarPro\depolar\cirrus plots\'+yr+dnm+'_plt.TIFF
WRITE_tiff, cntrname, TVRD(/TRUE)
stop
read,n,prompt='plot file for nth data ;'
a=max(pr2m[n-ni,*])
b=max(pr2d[n-ni,*])
plot,smooth(pr2m[n-ni,*],10),ht1,color=2,xrange=[0,a/10],yrange=[h1,h2],xtitle='count',ytitle='km',title='perpendicular'
plot,smooth(pr2d[n-ni,*],10),ht1,color=2,xrange=[0,b/10],yrange=[h1,h2],xtitle='count',ytitle='km',title='parallel'
;cntrname =bpath+'_1.TIFF
;WRITE_tiff, cntrname, TVRD(/TRUE)
stop
 end
