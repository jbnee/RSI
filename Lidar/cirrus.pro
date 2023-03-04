
Pro cirrus;_plots
;plot m/d file: parallel polarization
;-----------------------------

plot_position1 = [0.1,0.15,0.98,0.49]; plot_position=[0.1,0.15,0.95,0.45]
   plot_position2 = [0.1,0.6,0.98,0.94]; plot_position2=[0.1,0.6,0.95,0.95]
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 read,year, prompt='year as 2003: ?  '
 yr=string(year,format='(I4.4)')
 month=''
 read,month,prompt='month:ja,fe,mr,ap,ma,jn....? '
 bpath='c:\JB\'
 ;bpath='d:\Lidar systems\Rayleigh\'
 fpath=bpath+yr+'\'+month+'\'
 ;path='d:\LidarPro\Depolar\2004\mr\mr041947.'  ;072150.' ;202312.'; 312023.'; mr192028.' ;mr312023.'
 dnm=''
 read,dnm,prompt='data filename as mr022018    ???'
 ;file_basename1='d:\LidarPro\Depolar\2004\ap\ap022014.' ;
 fnm=fpath+dnm+'.'
;資料夾輸入:
;file_basename1='d:\LidarPro\Data\2002mr\';mr312023.'  ;072150.' ;202312.'; 312023.'; mr192028.' ;mr312023.'

fn1=''
; 資料檔輸入
;read,fd,prompt='data file such as mr182309'
;fx=path+fd+'.'
read,ni,nf, prompt='Initial and last file number as 1,99: '
  nx=nf-ni+1
 s1=strtrim(fix(ni),2)
 s2=strtrim(fix(nf),2)
 S='                                       file:'+s1+'_'+s2
;read,h1,h2,prompt='Initial and final height as ,1,5 km:'
  h1=10
  h2=20
  T=findgen(1000)
  pr2m=fltarr(nx,1000)
  pr2d=fltarr(nx,1000)
  ht=3.0E8*160.E-9*T/2./1000.   ;convert ht to km
   ht1=ht[0:999]
  ; !P.MULTI = [0,1,2]

    j=0
   ;fn1=fnm+strtrim(sn,2)+'m'
    fn1=fnm+strtrim(fix(ni),2)+'m'

    datab=read_binary(fn1,DATA_TYPE=2)

    ; datab=read_ascii(fn1)
    sig1=datab[0:999]
    pr2m[j,*]=smooth(sig1,10)*ht^2

    maxa=max(Pr2m[j,*])
    dv=maxa/nx
    plot,pr2m[j,*],ht1,position=plot_position1, background=-2,color=2,xrange=[0,1*maxa],yrange=[h1,h2],xtitle='m channel',ytitle='km' ,title=S

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
   ;oplot,sig+50*j,ht1, color=2 ;background=-2,color=1,xtitle='Signal/channel',ytitle='km'
   oplot,pr2m[j,*]+dv*j,ht1,color=2;
   j=j+1
  ;xyouts,1000+300*n,30,n,color=1,charsize=1


  ENDFOR
 ;;;;;;;;;;;;;;d file;;;;;;;;;;;;;;;;;;
stop
