Pro testaero
close,/all
;openr,1,"d:\LidarPro\DATA\Rayleigh\1999\FE\Fe092341.2R"
;fn="D:\Lidar systems\lidarPro\Rayleigh\1993\se\se010044.10m"
;file_basename1='d:\Lidar systems\LidarPro\Rayleigh\1993\se\se010044.'
file_basename1='d:\Lidarsystem\Depolar\2002\mr\mr080057.'   ;mr312023.
;mdx=nf-ni
read,ni,nf, prompt='Initial and file number as 1,99: '

j=0
T=findgen(8192)
for n=ni,nf do begin
; read,ni,prompt='which file number to process such as 5',
 if (n GE 100) then begin   ;
 fn=file_basename1+string(n,format='(1(I3))')+'m'  ; m or d for polarization component
 goto, JP0
 endif

 if (n LT 10 ) then begin  ;if less than 9 there is single digit
   fn=file_basename1+string(n,format='(1(I1))')+'m'  ;m or d
    endif else begin
  ;if larger than 10, then there is double digit
    fn=file_basename1+string(n,format='(1(I2))')+'m' ;m or d
 endelse
; stop
 JP0:;
  datab=bytarr(8192)
 ;datab=bytarr(2048)
 datab=read_binary(fn,DATA_TYPE=2)


 ht=3.0E8*160.E-9*T/2./1000.   ;convert ht to km
 sig=datab[0:2000]
 pr2=sig*ht^2
 ht1=ht[0:2000]
 if (n EQ ni) then begin
  ;plot,sig,ht1,background=-2,color=2,xrange=[0,10000],yrange=[0,40],xtitle='Signal/channel',ytitle='km'
  ;plot,sig,ht1,background=-2,color=2,xrange=[0,2000],yrange=[0,5],xtitle='Signal/channel',ytitle='km'

  plot,pr2,ht1,background=-2,color=2,xrange=[0,50000],yrange=[0,5],xtitle='Signal/channel',ytitle='km'
  goto,jp1
  endif else begin

 j=j+1
  ;oplot,sig+50*j,ht1, color=2 ;background=-2,color=1,xtitle='Signal/channel',ytitle='km'
 oplot,pr2+500*j,ht1,color=2;
  ;xyouts,1000+300*n,30,n,color=1,charsize=1
 endelse
 jp1: wait,0.5  ;wait 0.5 sec
endfor

stop
end