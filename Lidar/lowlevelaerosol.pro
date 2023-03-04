Pro lowlevelaerosol

;-----------------------------
;start with a colour table, read in from an external file hues.dat

 read,year, prompt='year as 2003: ?  '
 yr=string(year,format='(I4.4)')
 month=''
 read,month,prompt='month:ja,fe,mr,ap,ma,jn....? '
  opath='d:\Lidar_systems\LidarPro\Depolar\outputfile\'   ;output path Rayleigh\1995\se\se112342
 ;bpath='c:\test\new\';
 bpath='d:\lidar_systems\LidarPro\Depolar\';+yr+month
 fpath=bpath+yr+'\'+month+'\'
 ;path='d:\LidarPro\Depolar\2004\mr\mr041947.'  ;072150.' ;202312.'; 312023.'; mr192028.' ;mr312023.'
 dnm=''
 read,dnm,prompt='data filename as mr022018'

 fnm=fpath+dnm+'.'; fpath+dnm+'.'
read,h1,h2,prompt='Interested height region as 1,5 km : '
ch1=round(h1/0.024)
ch2=round(h2/0.024)
read,ni,nf, prompt='Initial and file number as 1,99: '
read,f, prompt='profile multiplier as 5,10,,,,'
  nx=nf-ni+1
 s1=strtrim(fix(ni),2)
 s2=strtrim(fix(nf),2)
 S='                                       file:'+s1+'_'+s2

  T=findgen(1000)
  pr2m=fltarr(nx,1000)
  pr2d=fltarr(nx,1000)
  ht=3.0E8*160.E-9*T/2./1000.   ;convert ht to km
   ht1=ht[ch1:ch2]  ;ht1[1000]=24km
   !P.MULTI = [0,1,2]
   plot_position1 = [0.1,0.15,0.98,0.49]; plot_position=[0.1,0.15,0.95,0.45]
   plot_position2 = [0.1,0.6,0.98,0.94]; plot_position2=[0.1,0.6,0.95,0.95]
    j=0
   ;fn1=fx+ '1m'
    fn10=fnm+strtrim(fix(ni),2)+'m'
    datab=read_binary(fn10,DATA_TYPE=2)
    sig=datab[0:999]
    pr2m[j,*]=smooth(sig,10)*ht^2
    maxa=max(Pr2m[j,*])

    dv=maxa/nx
    plot,f*pr2m[j,*]/(maxa),ht1,background=-2,color=2,position=plot_position1,  $
    xrange=[0,5*nx],yrange=[h1,h2],xtitle='m channel',ytitle='km' ,title=S,charsize=0.75

   ;stop
   j=1

   FOR n=ni+1,nf do begin

   sn=strtrim(fix(n),2)
  ;ln=strlen(sn)

   fn1=fnm+strtrim(sn,2)+'m'

   datab=read_binary(fn1,DATA_TYPE=2)
   sig1=datab[0:1999]
   sig=smooth(sig1,10)
   pr2m[j,*]=sig*ht^2
   maxaj=max(pr2m[j,*])
   ;oplot,sig+50*j,ht1, color=2 ;background=-2,color=1,xtitle='Signal/channel',ytitle='km'
   ;oplot,pr2m[j,*]+5*dv*j,ht1,color=2;
    oplot,f*pr2m[j,*]/maxaj+5*j,ht1,color=2
   j=j+1
  ;xyouts,1000+300*n,30,n,color=1,charsize=1


  ENDFOR
  stop
 ;;;;;;;;;;;;;;d file;;;;;;;;;;;;;;;;;;

k=0

  fn20=fnm+strtrim(fix(ni),2)+'d'
  ;fn1d=fx+'1d'
  databd=read_binary(fn20,DATA_TYPE=2)
  sigd=databd[0:999]
  pr2d[k,*]=sigd*ht^2
  maxb=max(pr2d[k,*])
  dv2=maxb/nx
    plot,f*pr2d[k,*]/maxb,ht1,background=-2,color=2,position=plot_position2,$
    xrange=[0,5*nx],yrange=[h1,h2],xtitle='d channel',ytitle='km' ,Title=dnm,charsize=0.75

  k=1

 FOR nd=ni+1,nf do begin
   sn=strtrim(fix(nd),2)
   fn2=fnm+strtrim(sn,2)+'D'
   datab=read_binary(fn2,DATA_TYPE=2)
   sig2=datab[0:1999]
   sigd=smooth(sig2,10)

   pr2d[k,*]=sigd*ht^2
   maxbk=max(pr2d[k,*])
   ;oplot,sig+50*j,ht1, color=2 ;background=-2,color=1,xtitle='Signal/channel',ytitle='km'
   oplot,f*pr2d[k,*]/maxbk+5*k,ht1,color=2
  ;xyouts,1000+300*n,30,n,color=1,charsize=1

   k=k+1

  ENDFOR
  stop





  S2=s1+'_'+s2

  outnm=dnm+'_'+S2
  write_bmp,"d:\lidar systems\lidarPro\depolar\outputpk\1997\"+outnm+'.bmp',tvrd()
;;;;Rayleigh backscattering coefficient
;;;;;;;; density of air is the polynomial fit of height determined from radiosonde

   ; density= 1.E25*(2.4498-0.22114*ht1+0.00701*ht1^2-7.75225E-5*ht1^3)  ;ht in km; in molec/m3
   ; beta_r=5.45E-32*(550./532.)^4*density  ;Rayleigh backscattering coefficient
   ; xsray=(8*3.1416/3.)*beta_r   ;Rayleigh cross section
   ;kext=xsray                   ;Rayleigh extinction
   ; transm=exp(-2*kext)             ;atmosph transmission
   ; y=dblarr(1024)
   ; y=(sig[0:600]*ht1[0:600]^2)/(transm*beta_r); bin 200 is 4.8 km
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
end
