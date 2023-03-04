Pro Licel_cirrus_Plt_edit


!p.multi=[0,1,2]
!p.background=255

  bpath='d:\Lidar_systems\lidarPro\depolar\'
 ;bpath='d:\Lidar systems\Raman lidar\2009\ja\'
;path='d:\LidarPro\Raman2009\532_0314\';'d:\Lidar systems\Raman lidar\20090314\532_0314\'
close,/all
fd=''
dnm=''
T=findgen(4000)
sig1=fltarr(4000)
sig2=fltarr(4000)
ht1=3.0E8*50.E-9*T/2./1000.+0.001   ;convert ht to km and remove 0 with bin resolution 50 ns
;ht1=2*7.5*T/1000  ; ht in km with resoluton 7.5m
year=2009
 ;read,year, prompt='year as 2003: ?  '
 yr=string(year,format='(I4.4)')

 month=''
 ; read,month,prompt='month:ja,fe,mr,ap,ma,jn....? '
 ;bpath='d:\Lidar systems\Raman lidar\'
; fpath=bpath+yr+'\'+month+'\'
 read,dnm,prompt='data file such as mr142042'
 month=strmid(dnm,0,2)
 fx=bpath+yr+'\'+month+'\'+dnm+'.'
 ;fx=bpath+fnm+'.'

; read,h1,h2,prompt='Initial and final height as ,1,5 km:'
  h1=10
  h2=20
 n1=round(h1*1000./7.5)  ;channel number
 n2=round(h2*1000./7.5)  ;ch

 read,ni,nf, prompt='Initial and last file number as 1,99: '
  nx=nf-ni+1
  s1=strtrim(fix(ni),2)
  s2=strtrim(fix(nf),2)
  S='                                       file:'+s1+'_'+s2;used to print title

read,nav, prompt='how many files to add to average? '
 ig=nx/nav  ;group number id


sigxm=fltarr(nx,4000);n2-n1+1)
sigxd=fltarr(nx,4000)
pr2m=fltarr(nx,4000);n2-n1+1)
pr2d=fltarr(nx,4000)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; read the first data and plot


   FOR ig=0,ng do begin   ;      ni+1,nf do begin
     iset=[(n*nav+st,  (n+1)*nav+st-1]
     sn=strtrim(fix(n),2)

    jset=[(ig-1)*avex+st ig*avex+st-1];  % j is the jth set of data for averaging given by ave
    tmp_a=0
    tmp_b=0

   FOR nf =jset[0]:jset[1]  ;addition within the group
     sn=strtrim(fix(nf),2)
     fn1= fx+strtrim(sn,2)+'m'   ;;;sprintf('%s\\%s\\%s.%d%s',path,fam(1:2),fam(1:8),f,'m');
     fn2= fx+strtrim(sn,2)+'d'
      openr,2,fn1
      readf,2,sig1
      openr,2,fn2
      readf,2,sig2
     close,2
    tmp_a=tmp_a+sig1
    tmp_b=tmp_b+sig2
endfor; nf

   pr2m[ig,*]=(smooth(tmp_a[ig,*],10))/nav ;*ht^2
   ;oplot,sig+50*j,ht1, color=2 ;background=-2,color=1,xtitle='Signal/channel',ytitle='km'
    j=0


  plot,pr2m[j,*]+dv*j,ht1,color=2;
   j=j+1
  ;xyouts,1000+300*n,30,n,color=1,charsize=1

close,2
  ENDFOR ;ig
  close,2
 ;;;;;;;;;;;;;;d file;;;;;;;;;;;;;;;;;;
     j2=0
    fn2=fx+strtrim(fix(ni),2)+'d'
    openr,3,fn2
    readf,3,sig2
    ; datab=read_ascii(fn1)
    minb=mean(sig2[n2:n2+500])   ;background  [n1:n2])
    sigxd[j2,*]=sig2-minb;[n1:n2]-mina

     pr2d[j2,*]=smooth(sigxd[j2,*],10);*(ht1^2) ;
     maxb=max(Pr2d[j2,*])
     dv2=maxb/nx
    plot,pr2d[j2,*],ht1,position=plot_position2, background=-2,color=2,xrange=[0,1*maxa],yrange=[h1,h2],xtitle='d channel',ytitle='km' ,title=S

  close,3
  FOR nd=ni+1,nf do begin
   sn2=strtrim(fix(nd),2)
  ;ln=strlen(sn)

   fn2=fx+strtrim(sn2,2)+'d'
   openr,2,fn2
   readf,2,sig2
    minb=mean(sig2[n2:n2+500])   ;background  [n1:n2])
    sigxd[j2,*]=sig2-minb;[n1:n2]-mina

     pr2d[j2,*]=smooth(sigxd[j2,*],10);*(ht1^2) ;
     ;maxb=max(Pr2d[j2,*])
    ; dv2=maxb/nx
   ;oplot,sig+50*j,ht1, color=2 ;background=-2,color=1,xtitle='Signal/channel',ytitle='km'
   oplot,pr2d[j2,*]+dv2*j2,ht1,color=2;
   j2=j2+1
  ;xyouts,1000+300*n,30,n,color=1,charsize=1

close,2
  ENDFOR
  close,2

stop
 DEVICE, DECOMPOSED=0
  opath='d:\Lidar_systems\lidarPro\depolar\cirrus\'

   ;read,fnm,prompt='affix filename to output'
  ; cntrname =opath+dnm+fnm+'.tiff'

  cntrname =opath+yr+fnm+'.TIFF
WRITE_tiff, cntrname, TVRD(/TRUE)
stop
read,n,prompt='plot file for nth data ;'
a=max(pr2m[n-ni,*])
b=max(pr2d[n-ni,*])
plot,smooth(pr2m[n-ni,*],10),ht1,color=2,xrange=[0,a/10],yrange=[h1,h2],xtitle='count',ytitle='km',title='perpendicular'
plot,smooth(pr2d[n-ni,*],10),ht1,color=2,xrange=[0,b/10],yrange=[h1,h2],xtitle='count',ytitle='km',title='parallel'
cntrname =opath+yr+fnm+'_plt.TIFF
WRITE_tiff, cntrname, TVRD(/TRUE)
stop
 end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 ;

