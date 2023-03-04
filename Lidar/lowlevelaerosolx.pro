Pro lowlevelaerosolx


close,/all
;openr,1,"d:\LidarPro\DATA\Rayleigh\1999\FE\Fe092341.2R"
;fn="D:\Lidar systems\lidarPro\Rayleigh\1993\se\se010044.10m"
;file_basename1='d:\Lidar systems\LidarPro\Rayleigh\1993\se\se010044.'
;file_basename1='d:\Lidar systems\Depolar\2002\mr\mr192028.'  ;072150.' ;202312.'; 312023.'; mr192028.' ;mr312023.'

 file_basename1='d:\LidarPro\Depolar\2004\ap\ap022014.' ;
read,ni,nf, prompt='Initial and file number as 1,99: '
  nx=nf-ni+1
  j=0
  T=findgen(8192)
  pr2=fltarr(nx,2000)
  ht=3.0E8*160.E-9*T/2./1000.   ;convert ht to km
   ht1=ht[0:1999]
 FOR n=ni,nf do begin

   sn=strtrim(fix(n),2)
  ;ln=strlen(sn)

   fn=file_basename1+strtrim(sn,2)+'m'

   datab=read_binary(fn,DATA_TYPE=2)
   sig=datab[0:1999]
   pr2[j,*]=sig*ht^2

   if (n EQ ni) then begin

   plot,pr2[j,*],ht1,background=-2,color=2,xrange=[0,1000],yrange=[0,5],xtitle='Signal/channel',ytitle='km'

   endif else begin


  ;oplot,sig+50*j,ht1, color=2 ;background=-2,color=2,xtitle='Signal/channel',ytitle='km'
   oplot,pr2[j,*]+30*j,ht1,color=2;
   j=j+1
  ;xyouts,1000+300*n,30,n,color=1,charsize=1
   endelse

  ENDFOR

 xyouts,500,5,'fn',color=1,charsize=2
 stop
 close,1
 end



 ; read,nx,prompt='which file number to process such as 5';

 ; write_bmp,"d:\lidar systems\lidarpro\Rayleigh\1993\93se010044.bmp",tvrd()
;;;;Rayleigh backscattering coefficient
;;;;;;;; density of air is the polynomial fit of height determined from radiosonde

   ; density= 1.E25*(2.4498-0.22114*ht1+0.00701*ht1^2-7.75225E-5*ht1^3)  ;ht in km; in molec/m3
   ; beta_r=5.45E-32*(550./532.)^4*density  ;Rayleigh backscattering coefficient
   ; xsray=(8*3.1416/3.)*beta_r   ;Rayleigh cross section
   ;kext=xsray                   ;Rayleigh extinction
   ; transm=exp(-2*kext)             ;atmosph transmission
   ; y=dblarr(1024)
   ; y=(sig[0:600]*ht1[0:600]^2)/(transm*beta_r); bin 200 is 4.8 km
   ; plot,y,ht1,background=-2,color=2;xrange=[0,10000],yrange=[5,40],xtitle='Signal/channel',ytitle='km'
   ; stop
    ;wait,2
   ;  plot,y[0:200]/y[300],ht1,background=-2,color=2

   ; stop
    ; bratio=fltarr(2,1250)
    ; bratio[1,100:1249]=transpose(y[100:1249]/y[600])
    ; bratio[0,100:1249]=transpose(ht1[100:1249])
    ; openw,2,'d:\lidar systems\lidarpro\Rayleigh\1993\Bratio93se010044_14.txt'
    ; printf,2,bratio
    ; close,2

 ;close,1
;end

