PRO readSR430,ni,nf ;day,starttime,ch_ram
   fn1=''
   read,fn1, prompt='filename as mr182309'
   fn='d:\lidar systems\Rayleigh\2001\ja\'+fn1
;    Read SR430
     ;file=findfile('mr*m',count=numfiles)
     ;ch_ram=fltarr(numfiles,8192)
     read,ni,nf,prompt='begining and end file number such as 1,35   '
      T=findgen(4096);  8192

     FOR n=ni,nf DO BEGIN
       sn=strtrim(fix(n),2)
       filename=fn+'.'+strtrim(sn,2)+'m'

       ;filename=fn+'.'+string(n,format='(1(I3))')+'m'   ;file(ii)   'd'ni+n+
       ;result_split1=STRSPLIT(filename_ram,'.',/EXTRACT)
       sig=READ_BINARY(filename,DATA_TYPE=2)

       ht=3.0E8*160.E-9*T/2./1000.   ;convert ht to km
       ;sig=X1[0:2000]
       pr2=sig*ht^2
       ;ht1=ht[0:2000]
       if (n EQ ni) then begin
       plot,smooth(sig,100),ht,background=-2,color=2,xrange=[0,1000],yrange=[10,35],xtitle='Signal/channel',ytitle='km'
       endif else begin
       oplot,smooth(sig,100)+n*50,ht
       endelse
       ;ch_ram(float(result_split1(1))-1.,*)=SMOOTH(result-mean(result(7000:8191)),5)
;       print,filename_ram,float(result_split1(1))-1.,mean(result(7000:8191))
     ENDFOR

   stop
     ;starttime=float(hour)+float(minute)/60.

END
