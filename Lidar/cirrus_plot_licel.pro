Pro cirrus_plot_Licel
close,/all
 !p.multi=[0,1,2]
 pls1 = [0.1,0.2,0.45,0.95];
 pls2 = [0.6,0.2, 0.95,0.95];


dnm='' ;   se112342'
READ,dnm, prompt='file name: '

 month=strmid(dnm,0,2)
fpath='f:\Lidar_data\2009\'
fnb=fpath+month+'\'+dnm+'.'

read,ni,nf,prompt='Initial and file number as 1,99: '
nx=nf-ni+1
range=4000; 2000 for SR430
J=0
sumsig=0
S=fltarr(nx,range)
datab=bytarr(2048)
   ;2000 is 48 km
T=findgen(range)
bw=50
ht=3.0E8*bw*1.E-9*T/2./1000.   ;convert ht to km
range=4000  ;2000
ht1=ht[0:range-1]
datab=fltarr(nx,range)
for n=ni,nf do begin
; read,ni,prompt='which file number to process such as 5',
  sn=strtrim(fix(n),2)
  fn=fnb+strtrim(sn,2)+'m'   ;(n,format='(1(I3))')+'m'  ; m or d for polarization component
  datab=fltarr(range)
 ; datab=read_binary(fn,DATA_TYPE=2)
  close,1
   openr,1,fn
   readf,1,datab
  close,1

  S[J,*]=datab[0:range-1]
 sumsig=sumsig+S[J,*]
  xmax=max(S[0,*])
 if (n EQ ni) then begin
  plot,S[J,*],ht1,background=-2,color=2,xrange=[0,xmax],yrange=[10,20],xtitle='Signal/channel',ytitle='km',position=pls1
 ; goto,jp1
 endif else begin
 oplot,S[J,*]+J*10,ht1,color=2
 endelse
 ;jp1: wait,0.5  ;wait 0.5 sec

 J=J+1
endfor
stop
 Avesig=total(S,1)/nx;sumsig/(nf-ni+1)
 ci=1330; cloud lower height in km
  z1=ht1[ci]
 cf=2660;cloud upper level height
  z2=ht1[cf]
 A1=max(avesig[ci:cf])
 A2=min(avesig[ci:cf])

 plot,ht1,avesig,background=-2,color=2,yrange=[A2,A1],xrange=[z1,z2],$
 ytitle='Signal/channel',xtitle='km',thick=1.2,xcharsize=1.2,ycharsize=1.2,$
 position=pls2,xticks=1
 ;title='average signal'
 ;xyouts,100,10,fnm,color=1,charsize=1.2
 stop

  q1=ht1[ci]
  q2=avesig[ci]

  plots,q1,q2,psym=2,thick=2,color=80
  p1=ht1[cf]
  p2=avesig[cf]
  plots,p1,p2,psym=2,thick=2,color=80
  stop

 chanl=findgen(40)
  plot,chanl,avesig[ci:ci+40],yrange=[15,18],psym=2,color=2,$
  xtitle='bin number',ytitle='count',xcharsize=1.2,ycharsize=1.0,thick=1.2,$
  position=pls1;xticks=1
  oplot,chanl,avesig[cf:cf+40],psym=2,color=2,thick=1.2

  opath='f:\RSI\cirrus\cirrus_transmission\'
  fname1=opath+dnm+"_se11fig1.bmp"
  write_bmp,fname1,TVRD()
 stop
 T1=mean(avesig[ci:ci+40])
 T2=mean(avesig[cf:cf+40])
 print,T1,T2 ;mean(avesig[ci:ci+40]),mean(avesig[cf:cf+40])
 T=sqrt(T2/T1)
 dz=ht1[cf]-ht1[ci]
 opt=alog(T)
 kext=opt/(dz*1000)
 print,opt,kext
 stop
 end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

