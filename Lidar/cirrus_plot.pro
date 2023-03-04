
Pro cirrus_plot
 ;plot md file: parallel polarization
;for 50 ns,width
;-----------------------------
;device, decomposed=0
erase
!p.multi=[0,1,2]
;!p.background=255
 ;loadct,39
;plot,[0,10],[-1,1],COLOR = 0
;plot,[0,1],xrange=[0,20],yrange=[-2,2],/nodata,COLOR = 0
;oplot,[0,20],[1.5,1.5];COLOR = 50
;stop
plot_position1 = [0.1,0.15,0.98,0.49]; plot_position=[0.1,0.15,0.95,0.45]
   plot_position2 = [0.1,0.6,0.98,0.94]; plot_position2=[0.1,0.6,0.95,0.95]
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
year='';
 read,year, prompt='year as 2003: ?  '
; year=
 yr=string(year,format='(I4.4)')
  dnm=''
 read,dnm,prompt='data filename as mr022018    ???'
 month=''
 month=strmid(dnm,0,2)
; read,month,prompt='month:ja,fe,mr,ap,ma,jn....? '
 bpath='D:\Lidar_data\'

 opath=bpath+yr+'\plots\'

 fnm=bpath+yr+'\'+month+'\'+dnm+'.'

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
read,h1,h2,prompt='Initial and final height as ,1,5 km:'
  binN=4000
  bwidth=50.0e-9;
  C=3.0e8

  dz=C*bwidth/2; 6.0  ; 6 meter for 40 ns binwidth

  T=findgen(binN)
  bn1=fix(h1*1000./dz)
  bn2=fix(h2*1000./dz)


   ht=dz*T
   ht1=dz*T/1000. ; in km

  pr2m=fltarr(nx,binN)
  pr2d=fltarr(nx,binN)
  ;ht=3.0E8*bwidth*1.E-9*T/2./1000.   ;convert ht to km

   j=0

    fn1=fnm+strtrim(fix(ni),2)+'m'

   ;data_M=read_binary(fn1,DATA_TYPE=2)

    data_M=read_ascii(fn1)
    sig1=data_m.(0)
    pr2m[j,*]=smooth(sig1,10);*ht^2

    maxa=max(Pr2m[j,*])
    dv=maxa/nx
    plot,pr2m[j,*],ht1,position=plot_position1, background=-2,color=2,xrange=[maxa,2*maxa],yrange=[h1,h2],xtitle='m channel',ytitle='km' ,title=S

   stop
   j=1

   FOR n=ni+1,nf do begin

   sn=strtrim(fix(n),2)
  ;ln=strlen(sn)

   fn1=fnm+strtrim(sn,2)+'m'

   ;data_a=read_binary(fn1,DATA_TYPE=2)
   data_a=read_ascii(fn1)
   sig1=data_a.(0);   [0:binN-1]

   siga=smooth(sig1,10)
   pr2m[j,*]=siga;*ht^2
   ;oplot,sig+50*j,ht1, color=2 ;background=-2,color=1,xtitle='Signal/channel',ytitle='km'
   oplot,pr2m[j,*]+dv*j*2,ht1,color=2;
   j=j+1
  ;xyouts,1000+300*n,30,n,color=1,charsize=1


  ENDFOR
  T_Pr2m=total(pr2m,1)/nx
  bk1=mean(T_pr2m[bn2-200:bn2-5])
  oplot,T_pr2m-bk1,ht1,color=2,thick=1.5
  stop
 ;;;;;;;;;;;;
 ;;d file;;;;;;;;;;;;;;;;;;

    fn2=fnm+strtrim(fix(ni),2)+'d'
    ;data_d=read_binary(fn2,DATA_TYPE=2)

     datab=read_ascii(fn2)

    sig2=datab.(0);   [0:binN-1]

    j2=0
    pr2d[j2,*]=smooth(sig2,10);*ht^2

    maxb=max(Pr2d[j2,*])
    dv=maxb/nx
    plot,pr2d[j2,*],ht1,position=plot_position2, background=-2,color=2,xrange=[maxb,2*maxb],yrange=[h1,h2],xtitle='d-channel',ytitle='km' ,title=dnm


  FOR nd=ni+1,nf do begin
   sn2=strtrim(fix(nd),2)
  ;ln=strlen(sn)

   fn2=fnm+strtrim(sn2,2)+'d'

   ;data_d=read_binary(fn2,DATA_TYPE=2)
   data_d=read_ascii(fn2)
    sig2=data_d.(0) ;   [0:binN-1]
   sig_d=smooth(sig2,10)
   pr2d[j2,*]=sig_d;*ht^2
   ;oplot,sig+50*j,ht1, color=2 ;background=-2,color=1,xtitle='Signal/channel',ytitle='km'
   oplot,pr2d[j2,*]+dv*j2*2,ht1,color=2;
   j2=j2+1
  ;xyouts,1000+300*n,30,n,color=1,charsize=1


  ENDFOR; nd
stop
T_pr2m=total(pr2m,1)
bk1=mean(T_pr2m[bn2-200:bn2-5])
T_pr2d=total(Pr2d,1)
bk2=mean(T_pr2d[bn2-200:bn2-5])
!p.multi=[0,1,1]
plot,T_pr2m-bk1,color=2,background=-2
oplot,T_pr2d-bk2,color=100,thick=1.5


 ;DEVICE, DECOMPOSED=0
  ;opath='d:\Lidar_systems\lidarPro\depolar\cirrus plots\'

   ;read,fnm,prompt='affix filename to output'
  ; cntrname =opath+dnm+fnm+'.tiff'

  cntrname =opath+dnm+'_plt.bmp
  ;'d:\Lidar_systems\lidarPro\depolar\cirrus plots\'+yr+dnm+'_plt.TIFF
;WRITE_bmp, cntrname, TVRD(/TRUE)
stop
;read,n,prompt='plot file for nth data ;'
;a=max(pr2m[n,*])
;b=max(pr2d[n,*])
;plot,smooth(pr2m[n,*],10),ht1,color=2,xrange=[0,a/10],yrange=[h1,h2],xtitle='count',ytitle='km',title='perpendicular'
;plot,smooth(pr2d[n,*],10),ht1,color=2,xrange=[0,b/10],yrange=[h1,h2],xtitle='count',ytitle='km',title='parallel'
;cntrname =opath+dnm+'_plt.TIFF
;WRITE_tiff, cntrname, TVRD(/TRUE)
;stop
;!p.multi=[0,1,1]
;plot,pr2m[100,1400:2000],ht1,color=2
stop

 end
