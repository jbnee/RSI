Pro RDbinary
close,/all
;fpath="d:\LidarPro\DATA\Rayleigh\1999\FE\Fe092341.2R"
fn="D:\LidarPro\Rayleigh\2007\de\de291954.10m"


 datab=read_binary(fn,DATA_TYPE=1)
 T=findgen(8192)
 ht=3.0E8*160.E-9*T/2./1000.   ;convert to ht in km
 ;sig=abs(datab[0:2000])
 sig=datab[0:2000]
 ht1=ht[0:2000]
 plot,sig,ht1,background=-2,color=1,xtitle='Signal/channel',ytitle='km'
 xyouts,1600,40,fn,color=1,charsize=2
 stop
  write_bmp,"d:\lidarsystem\Rayleigh\1993\sigse010044.bmp",tvrd()

 close,1
 end
 ;jn042240.4A
