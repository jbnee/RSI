Pro Rayleigh_se112342
device, decomposed=0



!p.background=-2
;;;---------------------
!p.multi=[0,1,1]

  bnum=1350 ; up to 32 km

  dz=0.024;
  dz1000=24.0
  T=findgen(bnum)
  ht=3.0E8*160.E-9*T/2./1000.   ;convert ht to km
 ; ht1=ht[0:bnum-1]; ht1{500]=12 km, ht[1000]=24 km



Rayx=5.32e-31 ; cross section in m2/sr
 N=density(Ht);density of air
 Sr=8*3.14/3.;
Br=Rayx*N/Sr;backscattering coeff
;;;;;;;;;transmission function;;;;;;;;;;;;;;;;
tau=fltarr(bnum)
;tau[bnum]=0
tau[bnum-1]=Br[bnum-1]*dz1000
for m=bnum-2,1,-1 do begin
  Tau[m]=tau[m+1]+dz1000*sr*(Br[m+1]+Br[m])/2
endfor;m

Tm=exp(-2*tau)
plot,tm,ht,color=2,background=-2,title='transmission'

stop
;fn="D:\Lidar systems\lidarPro\Rayleigh\1993\se\se112342.';se010044.10m"
;path='d:\LidarPro\Rayleigh\1995\se\se112342.';.'
 ;read,year, prompt='year as 2003: ?  '
 year=1995
 yr=string(year,format='(I4.4)')
 month=''
 dnm='se112342'
 ;read,dnm,prompt='data filename as mr022018    ???'

 month=strmid(dnm,0,2)
; read,month,prompt='month:ja,fe,mr,ap,ma,jn....? '
 bpath='f:\Lidar_data\Rayleigh\'
 ;bpath='d:\Lidar systems\Rayleigh\'
 fpath=bpath+yr+'\'+month+'\'


; read,month,prompt='month:ja,fe,mr,ap,ma,jn....? '
 ;bpath='e:\Lidar_files\Rayleigh\'  ;Depolar\'
 ;fpath=bpath+yr+'\'+month+'\'
 ;path='d:\LidarPro\Depolar\2004\mr\mr041947.'  ;072150.' ;202312.'; 312023.'; mr192028.' ;mr312023.'

 ;read,dnm,prompt='data filename as mr022018'
 ;file_basename1='d:\LidarPro\Depolar\2004\ap\ap022014.' ;
 fnm=fpath+dnm+'.'
ni=1;
nf=70;
nx=nf-ni+1
;read,ni,nf, prompt='Initial and file number as 1,99: '
;read,h1,h2, prompt='height range as,10,30:  '
h1=10.
h2=20

  pr2m=fltarr(nx,bnum)
  pr2d=fltarr(nx,bnum)


  j=0
 FOR n=ni,nf do begin

   sn=strtrim(fix(n),2)
  ;ln=strlen(sn)

   fn1=fnm+strtrim(sn,2)+'m'

   datab=read_binary(fn1,DATA_TYPE=2)
   sig=datab[0:bnum-1]
   pr2m[j,*]=sig*ht^2
   x=findgen(nx)
   y=ht[0:bnum-1]

   j=j+1

  ENDFOR

!p.multi=[0,2,1]
plot_position1 = [0.1,0.15,0.40,0.95];
plot_position2 = [0.6,0.15,0.90,0.95];

plot,pr2m[nx/2,*],ht,color=2,background=-2,position=plot_postion1
stop



;
;;;;;;;;;;;;;;;;;;;;Rayleigh fit;;;;;;;;;

PR2mx=Pr2m/Br ;range-correct,scattering corrected
;window,1
;plot,Pr2m,ht,color=20,background=-2,position=plot_position1
;stop
plot,Pr2mx,ht,color=2,background=-2, position=plot_position2
stop




 end



