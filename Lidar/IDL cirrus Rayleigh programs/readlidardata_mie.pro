PRO readlidardata_mie,fn,day,starttime,ch_d,ch_m,DR,int532

;    Read Licel DATA
     fn='Z:\Ddisk\My paper\2012dust\DATA\NCU Raman\LICEL\'
     cd,fn
     file=findfile('mr*',count=numfiles)
     ch_d=fltarr(numfiles/2.,4000) &  ch_m=fltarr(numfiles/2.,4000)

     FOR ii=0,numfiles-1.,2 DO BEGIN
       filename_d=file(ii)
       result_split=STRSPLIT(filename_d,'.',/EXTRACT)

       OPENR, lun, filename_d, /GET_LUN
       temp=fltarr(4000)
       READF, lun,temp
       ch_d(float(result_split(1))-1.,*)=SMOOTH(temp-mean(temp(3500:3999)),11)
       CLOSE, lun & FREE_LUN, lun

       filename_m=file(ii+1)
       OPENR, lun, filename_m, /GET_LUN
       temp=fltarr(4000)
       READF, lun,temp
       ch_m(float(result_split(1))-1.,*)=SMOOTH(temp-mean(temp(3500:3999)),11)
       CLOSE, lun & FREE_LUN, lun
;       plot,ch_d(float(result_split(1))-1.,*)/ch_m(float(result_split(1))-1.,*),yr=[0,1.0],xr=[0,2000]

     ENDFOR

     day=STRMID(STRTRIM(result_split(0),2),5,2, /REVERSE_OFFSET)
     hour=STRMID(STRTRIM(result_split(0),2),3,2, /REVERSE_OFFSET)
     minute=STRMID(STRTRIM(result_split(0),2),1,2, /REVERSE_OFFSET)
     starttime=float(hour)+float(minute)/60.

     DR=0.5*ch_d/ch_m
     int532=0.5*ch_d+ch_m


END
