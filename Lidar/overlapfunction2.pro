Pro overlapfunction2
close,/all
;below:Rayleigh extinctin
 n=1250
ht1=findgen(n)*0.024
density=fltarr(n)
beta_r=fltarr(n)
kext=fltarr(n)
tau=fltarr(n)
tm=fltarr(n)

 density= 1.E25*(2.4498-0.22114*ht1+0.00701*ht1^2-7.75225E-5*ht1^3)  ;ht in km; in molec/m3

  beta_r=5.45E-32*(550./532.)^4*density  ;Rayleigh backscattering coefficient

  kext=(8*3.1416/3.)*beta_r   ;Rayleigh total extinction

   ;Rayleigh cross section
    ;kext=xsray                   ;Rayleigh extinction
   z=24*findgen(n)
 ztop=z[1249]; top of the atmosphere 24 km
 tau1=fltarr(n)  ; for solar light from top of the atmosphere
 tau2=fltarr(n)  ;for lidar : light from ground

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;optical thickness tau1 and tau2
  tau1=qromb('opthick',z,ztop)  ;Integration using qromb

  tau2=qromb('opthick',0,z);integration

  plot,tau2,z/1000,color=2,background=-2,xtitle='tau' ,ytitle='km'
  ;stop
  T1=exp(-2*tau1);round trip transmission for solar from top atm
  T2=exp(-2*tau2);transmission for lidar from ground
  plot,T2,z/1000,color=2,background=-2,xtitle='Transmission %',ytitle='km'
 ; stop

 ;file_basename1='d:\LidarPro\Rayleigh\1995\se\se300039.'; 292328.' ;252155.';se252044.'; se190211.'; se190048.';  se182335.'  ;se182042.'; se142256.';  se142035.'; se140017.'; 132154.'
 fpath='d:\Lidar_systems\LidarPro\Rayleigh\1995\se\'; 292328.' ;252155.';se252044.'; se190211.'; se190048.';  se182335.'  ;se182042.'; se142256.';  se142035.'; se140017.'; 132154.'
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
 plot,avesig,ht1,background=-2,color=2,xrange=[0,2*max(avesig)],yrange=[5,20]$
 ,xtitle='Signal/channel',ytitle='km',title='Average signal'
 xyouts,100,10,fnm,color=1,charsize=1.2
 stop
 NAvesig=Avesig/Avesig[400]
   ; transm=exp(-2*kext)             ;atmosph transmission
   ; PR2=dblarr(1024)
   ; PR2=(avesig[0:1249]*z^2);/(tau2*beta_r)
    ;yc=(Rvsig[0:1249]*ht1[0:1249]^2)/(tau2*beta_r)
   ; plot,PR2,ht1,background=-2,color=2;xrange=[0,10000],yrange=[5,40],xtitle='Signal/channel',ytitle='km'
    ;oplot,yc,ht1,color=3,psym=3
   ; stop
   ; wait,2
    ;normalize at 10 km ht1[400]
   ; PR20=PR2[400];
   ; NPR2=PR2/PR20  ;normalizedPR2
   ; plot,NPR2,z/1000.,xrange=[0,1.5],background=-2,color=2
      ; oplot,yc[100:1200]/yc[600],ht1,xrange=[0,5],color=2,psym=3
   ; stop
    ;den0=density[400]
   ; Nden=density/den0
    SmA=density*beta_r*T2/(z[400]^2) ;simulated signal based on density
    NSmA=SmA/SmA[400]
    plot,NSmA,z/1000.,color=2,background=-2,xtitle='Signal',ytitle='km',$
    xrange=[0,1.5],yrange=[8,30], title='Simulate signal and Lidar comparison'

    oplot,NAvesig,z/1000,color=2
  stop
  Bratio=NAvesig/NSMA
  plot,Bratio,ht1,background=-2,color=2,yrange=[10,20],$
   xtitle='Backscattering Ratio',ytitle='km',title=fnm
  stop
  opath='d:\Lidar_systems\LidarPro\Rayleigh\output\'
  fname1=opath+fnm+"_Bkratio.bmp"
  write_bmp,fname1,TVRD()
 stop
 psn1 = [0.1,0.05,0.95,0.4];
 psn2 = [0.1,0.6,0.95,0.95];
  plot,channel,avesig[661:670],yrange=[400,1200],psym=2,color=2,background=-2,$
  xtitle='bin number',ytitle='count',xcharsize=1.2,ycharsize=1.2,thick=1.2,position=psn2
  oplot,channel,avesig[720:729],psym=2,color=2,thick=1.2

 end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

function opthick,z
  ht1=z/1000.
  density= 1.E25*(2.4498-0.22114*ht1+0.00701*ht1^2-7.75225E-5*ht1^3)  ;ht in km; in molec/m3
   beta_r=5.45E-32*(550./532.)^4*density  ;Rayleigh backscattering coefficient
   kext=(8*3.1416/3.)*beta_r
  opthick=kext
  return,opthick
  end
