
Pro cirrus_plot_wave
;plot m/d file: parallel polarization
;-----------------------------
device, decomposed=0

;!p.multi=[0,1,2]
!p.background=255
 ;loadct,39
;plot,[0,10],[-1,1],COLOR = 0
;plot,[0,1],xrange=[0,20],yrange=[-2,2],/nodata,COLOR = 0
;oplot,[0,20],[1.5,1.5];COLOR = 50
;stop
;plot_position1 = [0.1,0.15,0.98,0.49]; plot_position=[0.1,0.15,0.95,0.45]
 ;  plot_position2 = [0.1,0.6,0.98,0.94]; plot_position2=[0.1,0.6,0.95,0.95]
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;read,year, prompt='year as 2003: ?  '
 year=2006
 yr=string(year,format='(I4.4)')
  dnm=''
 read,dnm,prompt='data filename as mr022018    ???'
 month=''
 month=strmid(dnm,0,2)
; read,month,prompt='month:ja,fe,mr,ap,ma,jn....? '
 bpath='f:\Lidar_data\'

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
  bwidth=40
  T=findgen(binN)
  pr2m=fltarr(nx,binN)
  pr2d=fltarr(nx,binN)
  ht=3.0E8*bwidth*1.E-9*T/2./1000.   ;convert ht to km
   ht1=ht[0:binN-1]
   j=0

    fn1=fnm+strtrim(fix(ni),2)+'m'

    data_M=read_binary(fn1,DATA_TYPE=2)

    ; datab=read_ascii(fn1)
    sig1=data_m[0:binN-1]
    pr2m[j,*]=smooth(sig1,10);*ht^2

    maxa=max(Pr2m[j,*])
    dv=maxa/nx
    plot,pr2m[j,*],ht1,position=plot_position1, background=-2,color=2,xrange=[0,maxa],yrange=[5,10],xtitle='m channel',ytitle='km' ,title=S

   stop
   j=1

   FOR n=ni+1,nf do begin

   sn=strtrim(fix(n),2)
  ;ln=strlen(sn)

   fn1=fnm+strtrim(sn,2)+'m'

   data_a=read_binary(fn1,DATA_TYPE=2)
   sig1=data_a[0:binN-1]
   sig=smooth(sig1,10)
   pr2m[j,*]=sig; *ht^2
   ;oplot,sig+50*j,ht1, color=2 ;background=-2,color=1,xtitle='Signal/channel',ytitle='km'
   oplot,pr2m[j,800:1600]+dv*j*2,ht1[800:1600],color=2;
   j=j+1
  ;xyouts,1000+300*n,30,n,color=1,charsize=1


  ENDFOR
  stop
 ;;;;;;;;;;;;
 pr2mean=total(pr2m,1)/nx
 p0=make_array(1,4000,/integer,value=0)
 stPr2=fltarr(nx,binN)
 smpr2m=fltarr(nx,binN)
 ;plot,pr2m[j,*],ht1,position=plot_position1, background=-2,color=2,xrange=[0,maxa],yrange=[h1,h2],xtitle='m channel',ytitle='km' ,title=S

 plot,p0[800:1600],ht1[800:1600],color=2,background=-2,xrange=[0,maxa],yrange=[5,10],xtitle='STD Pr2m',ytitle='km'

 FOR n=ni+1,nf-1,2 do begin
     smPr2m[n,*]=smooth(pr2m[n,*],10)
     STPr2[n,*]=sqrt((smpr2m[n,*]-pr2mean)^2)
     oplot,STPr2[n,800:1600]+dv*n*1.5,ht1[800:1600],color=2;
   ;j=j+1
  ;xyouts,1000+300*n,30,n,color=1,charsize=1
endfor
  stop
  cntrname =opath+dnm+'_pltDiff.bmp
  ;'d:\Lidar_systems\lidarPro\depolar\cirrus plots\'+yr+dnm+'_plt.TIFF
WRITE_bmp, cntrname, TVRD(/TRUE)
stop
read,n,prompt='plot file for nth data ;'
a=max(pr2m[n,*])
b=max(pr2d[n,*])
plot,smooth(pr2m[n,*],10),ht1,color=2,xrange=[0,a/10],yrange=[h1,h2],xtitle='count',ytitle='km',title='perpendicular'
plot,smooth(pr2d[n,*],10),ht1,color=2,xrange=[0,b/10],yrange=[h1,h2],xtitle='count',ytitle='km',title='parallel'
;cntrname =opath+dnm+'_plt.TIFF
;WRITE_tiff, cntrname, TVRD(/TRUE)
stop
 end
