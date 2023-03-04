Pro RDbinary
openr,1,"G:\LidarPro\DATA\Rayleigh\1999\FE\Fe092341.2R"

 Fe09=bytarr(4096)
 readu,1,Fe09
 close,1
 ;plot,Fe09
 T=findgen(4096)
 x=3.0E8*160.E-9*T/4./1000.   ;convert to ht in km
 y=Fe09
 plot,x,y
 stop
 end
