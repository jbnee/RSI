
Pro cirrus_plot
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
 yr=string(year,format='(I4.4)')
  dnm=''
 read,dnm,prompt='data filename as mr022018    ???'
 month=''
 month=strmid(dnm,0,2)
; read,month,prompt='month:ja,fe,mr,ap,ma,jn....? '
 bpath='d:\Lidar_systems\Lidarpro\Depolar\'
 ;bpath='d:\Lidar systems\Rayleigh\'
 fpath=bpath+yr+'\'+month+'\'
 ;path='d:\LidarPro\Depolar\2004\mr\mr041947.'  ;072150.' ;202312.'; 312023.'; mr192028.' ;mr312023.'

 ;file_basename1='d:\LidarPro\Depolar\2004\ap\ap022014.' ;
 fnm=fpath+dnm+'.'


fn1=''
fn2=''
; ¸ê®ÆÀÉ¿é¤J
;read,fd,prompt='data file such as mr182309'
;fx=path+fd+'.'
read,ni,nf, prompt='Initial and last file number as 1,99: '
  nx=nf-ni+1
 s1=strtrim(fix(ni),2)
 s2=strtrim(fix(nf),2)
 S='                                       file:'+s1+'_'+s2
 read,nav, prompt='how many files to add to average? '
 ig=nx/nav  ;group number id


;read,h1,h2,prompt='Initial and final height as ,1,5 km:'
  h1=10
  h2=20
  T=findgen(1000)
  pr2m=fltarr(nx,1000)
  pr2d=fltarr(nx,1000)
  ht=3.0E8*160.E-9*T/2./1000.   ;convert ht to km
   ht1=ht[0:999]
   j=0

    fn1=fnm+strtrim(fix(ni),2)+'m'

    data_M=read_binary(fn1,DATA_TYPE=2)

    ; datab=read_ascii(fn1)
    sig1=data_m[0:999]
    pr2m[j,*]=smooth(sig1,10);*ht^2

    maxa=max(Pr2m[j,*])
    dv=maxa/nx
    plot,pr2m[j,*],ht1,position=plot_position1, background=-2,color=2,xrange=[0,1*maxa],yrange=[h1,h2],xtitle='m channel',ytitle='km' ,title=S

   FOR ig=0,ng do begin   ;      ni+1,nf do begin
     ;iset=[(ig*nav+ni,  (ig+1)*nav+ni-1]
    ;sn=strtrim(fix(n),2)

     jset=[ig*nav+ni , (ig+1)*nav+ni-1];  % j is the jth set of data for averaging given by ave
    tmp_a=0
    tmp_b=0
   ;stop
   j=1

   FOR nm=ni+1,nf do begin

   sn=strtrim(fix(nm),2)
  ;ln=strlen(sn)

   fn1=fnm+strtrim(sn,2)+'m'

   data_a=read_binary(fn1,DATA_TYPE=2)


   sig1=data_a[0:999]
   sig=smooth(sig1,10)
   tmp_a=tmp_a+sig1

   pr2m[j,*]=tmp_a/nav; *ht^2
   ;oplot,sig+50*j,ht1, color=2 ;background=-2,color=1,xtitle='Signal/channel',ytitle='km'
   oplot,pr2m[j,*]+dv*j,ht1,color=2;
   j=j+1
  ;xyouts,1000+300*n,30,n,color=1,charsize=1


  ENDFOR  ;nm
  ENDFOR  ;ig
 ;;;;;;;;;;;;;;d file;;;;;;;;;;;;;;;;;;
     j2=0
    fn2=fnm+strtrim(fix(ni),2)+'d'
    data_d=read_binary(fn2,DATA_TYPE=2)

    ; datab=read_ascii(fn1)
    sig2=data_d[0:999]
    pr2d[j2,*]=smooth(sig2,10);*ht^2

    maxb=max(Pr2d[j2,*])
    dv=maxb/nx
    plot,pr2d[j2,*],ht1,position=plot_position2, background=-2,color=2,xrange=[0,1*maxa],yrange=[h1,h2],xtitle='m channel',ytitle='km' ,title=S


  FOR nd=ni+1,nf do begin
   sn2=strtrim(fix(nd),2)
  ;ln=strlen(sn)

   fn2=fnm+strtrim(sn2,2)+'d'

   data_d=read_binary(fn2,DATA_TYPE=2)
   sig2=data_d[0:999]
   sig_d=smooth(sig2,10)
   pr2d[j2,*]=sig_d;*ht^2
   ;oplot,sig+50*j,ht1, color=2 ;background=-2,color=1,xtitle='Signal/channel',ytitle='km'
   oplot,pr2d[j2,*]+dv*j2,ht1,color=2;
   j2=j2+1
  ;xyouts,1000+300*n,30,n,color=1,charsize=1


  ENDFOR
stop
 DEVICE, DECOMPOSED=0
  opath='d:\Lidar_systems\lidarPro\depolar\cirrus\'

   ;read,fnm,prompt='affix filename to output'
  ; cntrname =opath+dnm+fnm+'.tiff'

  cntrname =opath+yr+dnm+'.TIFF
WRITE_tiff, cntrname, TVRD(/TRUE)
stop
read,n,prompt='plot file for nth data ;'
a=max(pr2m[n-ni,*])
b=max(pr2d[n-ni,*])
plot,smooth(pr2m[n-ni,*],10),ht1,color=2,xrange=[0,a/10],yrange=[h1,h2],xtitle='count',ytitle='km',title='perpendicular'
plot,smooth(pr2d[n-ni,*],10),ht1,color=2,xrange=[0,b/10],yrange=[h1,h2],xtitle='count',ytitle='km',title='parallel'
cntrname =opath+yr+dnm+'_plt.TIFF
WRITE_tiff, cntrname, TVRD(/TRUE)
stop
 end
