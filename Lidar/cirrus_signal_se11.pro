Pro cirrus_signal_se11
close,/all
 ;file_basename1='d:\LidarPro\Rayleigh\1995\se\se300039.'; 292328.' ;252155.';se252044.'; se190211.'; se190048.';  se182335.'  ;se182042.'; se142256.';  se142035.'; se140017.'; 132154.'
 fpath='f:\Lidar_data\Rayleigh\1995\se\'; 292328.' ;252155.';se252044.'; se190211.'; se190048.';  se182335.'  ;se182042.'; se142256.';  se142035.'; se140017.'; 132154.'
  ; fnm='se300039.'
fnm='se112342'
fnb=fpath+fnm+'.'

read,ni,nf,prompt='Initial and file number as 1,99: '
mf=nf-ni+1
J=0
sumsig=0
S=fltarr(mf,2000)
datab=bytarr(2048)
   ;2000 is 48 km
T=findgen(2048)
 ht=3.0E8*160.E-9*T/2./1000.   ;convert ht to km
  ht1=ht[0:2000]
for n=ni,nf do begin
; read,ni,prompt='which file number to process such as 5',
  sn=strtrim(fix(n),2)
  fn=fnb+strtrim(sn,2)+'m'   ;(n,format='(1(I3))')+'m'  ; m or d for polarization component
  datab=read_binary(fn,DATA_TYPE=2)
  S[J,*]=datab[0:1999]
 sumsig=sumsig+S[J,*]
  xmax=max(S[0,*])
 if (n EQ ni) then begin
  plot,S[J,*],ht1,background=-2,color=2,xrange=[0,xmax],yrange=[5,35],xtitle='Signal/channel',ytitle='km'
 ; goto,jp1
 endif else begin
 oplot,S[J,*]+J*500,ht1,color=2
 endelse
 ;jp1: wait,0.5  ;wait 0.5 sec

 J=J+1
endfor
stop
 Avesig=sumsig/(nf-ni+1)
 !p.multi=[0,1,2]
 pls1 = [0.1,0.20,0.95,0.45];
 pls2 = [0.1,0.65,0.95,0.95];
 plot,avesig,ht1,background=-2,color=2,xrange=[0,15000],yrange=[10,20]$
 ,xtitle='Signal/channel',ytitle='km',thick=1.2,xcharsize=1.2,ycharsize=1.2,$
 position=pls2,xticks=1
 ;title='average signal'
 ;xyouts,100,10,fnm,color=1,charsize=1.2
 stop
  x1=avesig[656]
  y1=ht1[656]
  plots,x1,y1,psym=2,thick=2,color=2
  x2=avesig[720]
  y2=ht1[720]
  plots,x2,y2,psym=2,thick=2,color=2
  stop

 chanl=findgen(10)
  plot,chanl,avesig[656:665],yrange=[400,1400],psym=2,color=2,$
  xtitle='bin number',ytitle='count',xcharsize=1.2,ycharsize=1.0,thick=1.2,$
  position=pls1;xticks=1
  oplot,chanl,avesig[720:729],psym=2,color=2,thick=1.2

opath='f:\RSI\cirrus\cirrus_transmission\'
  fname1=opath+fnm+"_se11fig1.bmp"
  write_bmp,fname1,TVRD()
 stop
 T1=mean(avesig[656:665])
 T2=mean(avesig[720:729])
 print,T1,T2 ;mean(avesig[656:665]),mean(avesig[720:729])
 T=sqrt(T2/T1)
 dz=ht1[725]-ht1[660]
 opt=alog(T)
 kext=opt/(dz*1000)
 print,opt,kext
 stop
 end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

