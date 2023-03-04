Pro Rdbinary1
close,/all
fn="d:\LidarPro\Rayleigh\1995\se\se042137.2m"
;fn="D:\LidarPro\Rayleigh\2007\de\de291954.10m"

 ;read,ni,nf,prompt='initial and final file numbers:'

 ni=1
 nf=10
 nx=nf-ni+1
 sig1=fltarr(nx,4096) ; Take first 2048 BINS or 48 km
  T=findgen(4096)
  ht=3.0E8*160.E-9*T/2./1000.   ;convert to ht in km
  ht1=ht[0:1023]
 for n=ni,nf do begin

  datab=read_binary(fn,DATA_TYPE=2)
 ;T=findgen(8192)



  sig1[n,*]=datab[0:4095]
  sig=sig1[n,0:1023]
  plot,sig,ht1,background=-2,color=1,xtitle='Signal/channel',ytitle='km'
 ;xyouts,1600,40,fn,color=1,charsize=2
 wait,1
 endfor
 stop
 ; write_bmp,"d:\lidarsystem\Rayleigh\1993\sigse010044.bmp",tvrd()

 close,1
 end
 ;jn042240.4A
