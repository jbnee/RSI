Pro RDlicel
close,/all
!p.multi=[0,1,2]
 plot_position1 = [0.1,0.15,0.43,0.95]; plot_position=[0.1,0.15,0.95,0.45]
 plot_position2 = [0.5,0.15,0.93,0.94];
;fpath="d:\LidarPro\DATA\Rayleigh\1999\FE\Fe092341.2R"
;fn="D:\LidarPro\Rayleigh\2007\de\de291954.10m"
 fn='f:\RSI\licel_data\e1561621.101575'

 datab=read_binary(fn,DATA_TYPE=6)
   T=findgen(8192)
 ht=3.0E8*50.E-9*T/2./1000.   ;convert to ht in km
 ;
 sig1=-datab(250:4000)
 ;sig2=imaginary(datab)
 ht1=ht[250:4000]
 plot,real_part(sig1),ht,background=-2,color=1,xtitle='Signal/channel',ytitle='km',position=plot_position1
 xyouts,1600,40,fn,color=1,charsize=2
 ;stop
 ; write_bmp,"d:\lidarsystem\Rayleigh\1993\sigse010044.bmp",tvrd()
 plot,imaginary(sig1),ht1,background=-2,color=1,xtitle='Signal/channel',ytitle='km',position=plot_position2
 ;plot,sig2,ht,background=-2,color=1,xtitle='Signal/channel',ytitle='km',position=plot_position2
 close,1
 stop
 end
 ;jn042240.4A
