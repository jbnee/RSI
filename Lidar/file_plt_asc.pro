Pro File_Plt_asc
;;
; also named lidar_signal_plot_asc
!P.MULTI = [0,1,2]
   plot_position1 = [0.1,0.15,0.98,0.49]; plot_position=[0.1,0.15,0.95,0.45]
  plot_position2 = [0.1,0.6,0.98,0.94]; plot_position2=[0.1,0.6,0.95,0.95]

!p.background=255

  bpath='f:\Lidar_data\';   lidarPro\depolar\'
  ;bpath='d:\lidar_files\RamanData\Raman\MCA_H2O\2009\';   _files\depolar\'
 ;bpath='d:\Lidar systems\Raman lidar\2009\ja\'
  ;opath='d:\LidarPro\Raman2009\532_0314\';'d:\Lidar systems\Raman lidar\20090314\532_0314\'
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
 fx=bpath+month+'\'+dnm+'.'
 ;fx=bpath+fnm+'.'

 read,h1,h2,prompt='Initial and final height as ,1,5 km:'

 n1=round(h1*1000./7.5)  ;channel number
 n2=round(h2*1000./7.5)  ;ch

 read,ni,nf, prompt='Initial and last file number as 1,99: '
  nx=nf-ni+1
 s1=strtrim(fix(ni),2)
 s2=strtrim(fix(nf),2)
 S='                                       file:'+s1+'_'+s2;used to print title
sigxm=fltarr(nx,4000);n2-n1+1)
sigxd=fltarr(nx,4000)
pr2m=fltarr(nx,4000);n2-n1+1)
pr2d=fltarr(nx,4000)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    j=0

    fn1=fx+strtrim(fix(ni),2)+'m'
    openr,1,fn1;/get_lun
    ;readf,1,sig1
    sig1=read_binary(fn1,data_type=2)
    close, 1;
   ;sigsm=smooth(sig1,10)
   ;datab=read_binary(fn,DATA_TYPE=2)
    mina=mean(sig1[3800:3999])   ;background  [n1:n2])
    sigxm[j,*]=sig1[0:3999]-mina;[n1:n2]-mina

     pr2m[j,*]=smooth(sigxm[j,*],20);*(ht1^2) ;


    ; datab=read_ascii(fn1)

    ;pr2m[j,*]=smooth(sig1,10);*ht^2

    maxa=max(Pr2m[j,*])
    dv=maxa/nx
    s1=strtrim(fix(ni),2)
    s2=strtrim(fix(nf),2)
   S=dnm+'                                       file:'+s1+'_'+s2;used to print title
    ;;plot,pr2m[j,*],ht1, background=-2,color=2 ,xrange=[0,.3*maxa],yrange=[h1,h2],xtitle='pll channel',ytitle='km' ,title=S
     ;position=plot_position1,
    plot,smooth(sigxm[j,*],20),ht1, background=-2,color=2 ,xrange=[0,.3*maxa],yrange=[h1,h2],xtitle='pll channel',ytitle='km',$
    position=plot_position1,title=S
   j=1
    stop
   FOR n=ni+1,nf do begin

   sn=strtrim(fix(n),2)
  ;ln=strlen(sn)

   fn1=fx+strtrim(sn,2)+'m'
   openr,2,fn1
   ;readf,2,sig1
   sig1=read_binary(fn1,data_type=2)
   mina=mean(sig1[3900:3999]);  [n2:n2+500])   ;background  [n1:n2])
   sigxm[j,*]=sig1[0:3999]-mina;[n1:n2]-mina

   pr2m[j,*]=smooth(sigxm[j,*],20)*ht1^2
   ;oplot,sig+50*j,ht1, color=2 ;background=-2,color=1,xtitle='Signal/channel',ytitle='km'
   ; oplot,pr2m[j,*]+dv*j/3,ht1,color=2;
   ;oplot,smooth(sigxm[j,*],20)+dv*j/3,ht1,color=2
   ;wait,1
   j=j+1
  ;xyouts,1000+300*n,30,n,color=1,charsize=1

   close,2
  ENDFOR
   AV_PR2M=total(pr2m,1)/nx
   plot,AV_PR2m,ht1,color=2,background=-2,xrange=[0,100],yrange=[0,2], $
   position=plot_position2,title='H2O'
  close,2

  stop
   opath=bpath+yr+'\output\'

   ;read,fnm,prompt='affix filename to output'
  ; cntrname =opath+dnm+fnm+'.tiff'

  cntrname =opath+yr+dnm+'-m-'+s2+'.bmp'
;WRITE_bmp, cntrname, TVRD()
 ;;;;;;;;;;;;;;d file;;;;;;;;;;;;;;;;;;
     j2=0
    fn2=fx+strtrim(fix(ni),2)+'d'
    openr,3,fn2
    ;readf,3,sig2
    sig2=read_binary(fn2,DATA_TYPE=2); MCA SR430
    ; datab=read_ascii(fn1)
    minb=mean(sig2[3800:3999]);n2: n2+500])   ;background  [n1:n2])
    sigxd[j2,*]=sig2[0:3999]-minb;
     pr2d[j2,*]=smooth(sigxd[j2,*],20)*(ht1^2) ;
     maxb=max(Pr2d[j2,*])
     dv2=maxb/nx
    plot,pr2d[j2,0:500],ht1,color=2,background=-2,xrange=[0, 100],yrange=[0,h2], $
     xtitle='d channel',ytitle='km' ,$
    title=S, position=plot_position1
    stop

   FOR nd=ni+1,nf do begin
   sn2=strtrim(fix(nd),2)
  ;ln=strlen(sn)

   fn2=fx+strtrim(sn2,2)+'d'
   openr,2,fn2
   ;readf,2,sig2
   sig2=read_binary(fn2,data_type=2)
    minb=mean(sig2[n2:n2+500])   ;background  [n1:n2])
    sigxd[j2,*]=sig2[0:3999]-minb;[n1:n2]-mina

     pr2d[j2,*]=smooth(sigxd[j2,*],20);*(ht1^2) ;
     ;maxb=max(Pr2d[j2,*])
    ; dv2=maxb/nx
     ;oplot,sig+50*j,ht1, color=2 ;background=-2,color=1,xtitle='Signal/channel',ytitle='km'
    ;oplot,pr2d[j2,*]+dv2*j2/5,ht1,color=2;
    j2=j2+1
    ;xyouts,1000+300*n,30,n,color=1,charsize=1

    close,2
    ENDFOR
      AV_PR2D=total(pr2D,1)/nx
   plot,AV_PR2D,ht1,color=2,background=-2,xrange=[0,1000],yrange=[0,h2],position=plot_position2

stop

  opath=bpath+yr+'_licel\test\
   ;read,fnm,prompt='affix filename to output'
  ; cntrname =opath+dnm+fnm+'.tiff'

  cntrname =opath+yr+dnm+'-d-'+s2+'.bmp'
;WRITE_bmp, cntrname, TVRD()
stop

 end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 ;

