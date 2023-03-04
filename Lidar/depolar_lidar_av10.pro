Pro depolar_lidar_av10

;-----------------------------
;start with a colour table, read in from an external file hues.dat

 read,year, prompt='year as 2003: ?  '
 yr=string(year,format='(I4.4)')
 dnm=''
  Read,dnm,PROMPT='Enter dnm as mr041947 '
  month=strmid(dnm,0,2)
 ;read,month,prompt='month:ja,fe,mr,ap,ma,jn....? '
  bpath='f:\lidar_data\'; \LidarPro\Depolar\';+yr+month
  opath='f:\Lidar_data\output2\';  systems\LidarPro\Depolar\outputfile\'   ;output path Rayleigh\1995\se\se112342
 ;bpath='c:\test\new\';

  fpath=bpath+yr+'\'+month+'\'
 ;path='d:\LidarPro\Depolar\2004\mr\mr041947.'  ;072150.' ;202312.'; 312023.'; mr192028.' ;mr312023.'

  fnm=fpath+dnm+'.'; fpath+dnm+'.'
 read,h1,h2,prompt='Interested height region as 1,5 km : '
 ch1=round(h1/0.024)
 ch2=round(h2/0.024)
 nbin=ch2-ch1+1
 read,ni,nf, prompt='Initial and file number  as 10,209¾ in multiples of 10: '
 ;read,f, prompt='profile multiplier as 5,10,,,,'
  nx=nf-ni+1
  n10=round(nx/10) ;average 10 profile

 s1=strtrim(fix(ni),2)
 s2=strtrim(fix(nf),2)
 S='                                       file:'+s1+'_'+s2

  T=findgen(1000)
  pr2m=fltarr(nx,1000)
  pr2m_A=fltarr(nx/10,nbin)
  pr2d=fltarr(nx,1000)
  pr2d_A=fltarr(nx/10,nbin)

  ht=3.0E8*160.E-9*T/2./1000.   ;convert ht to km
  ht1=ht[ch1:ch2]  ;ht1[1000]=24km
   !P.MULTI = [0,3,1]
   plot_position1 = [0.1,0.1,0.4,0.95];
   plot_position2 = [0.45,0.1,0.75,0.95];
   plot_position3 = [0.8,0.1,0.98,0.95];
    j=0
   ;fn1=fx+ '1m'

   ;stop
   j=0;counter for data file since ni not necessary starts from 0

   FOR n=ni+1,nf do begin

   sn=strtrim(fix(n),2)
  ;ln=strlen(sn)

   fn1=fnm+strtrim(sn,2)+'m'

   datab=read_binary(fn1,DATA_TYPE=2)
   sig1=datab[0:1999]
   sig=smooth(sig1,10)
   pr2m[j,*]=sig*ht^2
   j=j+1
   endfor

   pr2m_rb=rebin(pr2m,n10,1000);average of 10 profiles
   pr2m_A=pr2m_rb[*,0:nbin]
    maxa=max(pr2m_A)
   fa=maxa/n10
   plot,pr2m_A[0,*],ht1,background=-2,color=2,position=plot_position1,  $
    xrange=[0,maxa*n10/10],yrange=[h1,h2],xtitle='m channel',ytitle='km' ,title=S,charsize=1.2
   For m=1,nx/10-1 do begin
     ;oplot,sig+50*j,ht1, color=2 ;background=-2,color=1,xtitle='Signal/channel',ytitle='km'
   ;oplot,pr2m[j,*]+5*dv*j,ht1,color=2;
    oplot,pr2m_A[m,*]+ fa*m,ht1,color=2
    endfor
  ;xyouts,1000+300*n,30,n,color=1,charsize=1



  stop
 ;;;;;;;;;;;;;;d file;;;;;;;;;;;;;;;;;;

 k=0

 FOR nd=ni+1,nf do begin
   sn=strtrim(fix(nd),2)
   fn2=fnm+strtrim(sn,2)+'D'
   datab=read_binary(fn2,DATA_TYPE=2)
   sig2=datab[0:1999]
   sigd=smooth(sig2,10)
   pr2d[k,*]=sigd*ht^2
   k=k+1
   endfor

     pr2d_rb=rebin(pr2d,n10,1000);average of 10 profiles
     pr2d_A=pr2d_rb[*,0:nbin]
     maxb=max(pr2d_A)
     fb=maxb/n10
    plot,pr2d_A[0,*],ht1,background=-2,color=2,position=plot_position2,  $
    xrange=[0,n10*maxb/10],yrange=[h1,h2],xtitle='d channel',ytitle='km' ,title=dnm,charsize=1.2

    For md=1,n10-1 do begin

    oplot,pr2d_A[md,*]+fb*md,ht1,color=2
    endfor
  ;xyouts,1000+300*n,30,n,color=1,charsize=1

    stop
;;;;;;;;;;;;;;;;;;;;;;;; depolarization ratio
      rp=fltarr(nx/10,nbin+1)
     rp[0,*]=pr2m_A[0,*]/(pr2d_A[0,*]+0.01)   ; to avoid divide by 0
     mrp=max(rp[0,*])
     ;plot,rp[0,*],ht1,color=2,background=-2,xrange=[0,2*mrp], position=plot_position3, $
    ; xtitle='depolarization ratio',ytitle='km'

    For m3=1,n10-1 do begin

     rp[m3,*]=pr2m_A[m3,*]/(pr2d_A[m3,*]+0.01)
     ;oplot,rp[m3,*]+10*m3,ht1,color=4
    endfor
    Adepolar=total(rp,1)/n10; average depolarization ratio
     plot,Adepolar,ht1,color=2,background=-2,position=plot_position3,xrange=[0,mrp/5], yrange=[0,3], xtitle='average d',ytitle='km'
    stop
  S2=s1+'_'+s2

  outnm=dnm+'_'+S2
  write_bmp,opath+outnm+'.bmp',tvrd()

 close,1
 stop
end
