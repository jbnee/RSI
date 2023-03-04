Pro overlapfunction
close,/all
;openr,1,"d:\LidarPro\DATA\Rayleigh\1999\FE\Fe092341.2R"
filepath='D:\Lidar_systems\lidarPro\Rayleigh\1993\se\'
fnm='se010044.'
file_basename1=filepath+fnm;"D:\Lidar_systems\lidarPro\Rayleigh\1993\se\se010044."

;file_basename1='d:\Lidar systems\Rayleigh\1995\se\se300039.'; 292328.' ;252155.';se252044.'; se190211.'; se190048.';  se182335.'  ;se182042.'; se142256.';  se142035.'; se140017.'; 132154.'
;file_basename1='d:\Lidar systems\Depolar\2002\mr\mr192028.'; mr182309.'
;mdx=''
read,ni,nf,prompt='Initial and file number as 1,99: '
J=0

for n=ni,nf do begin

  sn=strtrim(fix(n),2)
  ;ln=strlen(sn)

   fn=file_basename1+strtrim(sn,2)+'m'   ;(n,format='(1(I3))')+'m'  ; m or d for polarization component


  datab=bytarr(8192)
 ;datab=bytarr(2048)
 datab=read_binary(fn,DATA_TYPE=2)

 T=findgen(8192)
 ht=3.0E8*160.E-9*T/2./1000.   ;convert ht to km
 sig=datab[0:2000]
 ht1=ht[0:2000]
 if (n EQ ni) then begin
  plot,sig,ht1,background=-2,color=2,xrange=[0,10000],yrange=[5,40],xtitle='Signal/channel',ytitle='km'
  goto,jp1
 endif else begin
 ;goto, JP
  oplot,sig+500*J,ht1, color=2 ;background=-2,color=1,xtitle='Signal/channel',ytitle='km'
 ; xyouts,2000+300*n,30,n,color=1,charsize=1
 endelse
 jp1: wait,0.5  ;wait 0.5 sec
 J=J+1
endfor
 xyouts,6000,30,fnm,color=1,charsize=1.2
 stop
 ; read,nx,prompt='which file number to process such as 5';

 ; write_bmp,"d:\lidar systems\lidarpro\Rayleigh\1993\93se010044.bmp",tvrd()
;;;;Rayleigh backscattering coefficient
;;;;;;;; density of air is the polynomial fit of height determined from radiosonde

    density= 1.E25*(2.4498-0.22114*ht1+0.00701*ht1^2-7.75225E-5*ht1^3)  ;ht in km; in molec/m3
    beta_r=5.45E-32*(550./532.)^4*density  ;Rayleigh backscattering coefficient
    xsray=(8*3.1416/3.)*beta_r   ;Rayleigh cross section
    kext=xsray                   ;Rayleigh extinction
    transm=exp(-2*kext)             ;atmosph transmission
    y=dblarr(1024)
    y=(sig[0:1249]*ht1[0:1249]^2)/(transm*beta_r)
    plot,y,ht1,background=-2,color=2;xrange=[0,10000],yrange=[5,40],xtitle='Signal/channel',ytitle='km'
    stop
    wait,2
     plot,y[100:1200]/y[600],ht1,xrange=[1,10],background=-2,color=2

    stop
    ; bratio=fltarr(2,1250)
    ; bratio[1,100:1249]=transpose(y[100:1249]/y[600])
    ; bratio[0,100:1249]=transpose(ht1[100:1249])
    ; openw,2,'d:\lidar systems\lidarpro\Rayleigh\1993\Bratio93se010044_14.txt'
    ; printf,2,bratio
    ; close,2

 close,1
 end