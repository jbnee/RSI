PRO readlidardata_Raman,fn,day,starttime,ch_ram
fn=''
;    Read RAMAN DATA
     file=FILE_SEARCH(fn,count=numfiles)
     ch_ram=fltarr(numfiles,8192)

     FOR ii=0,numfiles-1.,1 DO BEGIN
       filename_ram=file(ii)
       result_split1=STRSPLIT(filename_ram,'.',/EXTRACT)

       result=READ_BINARY(filename_ram,DATA_TYPE=2)
;       ch_ram(ii,*)=SMOOTH(result-mean(result(7000:8191)),5);CHANGED BY ME
       ch_ram(float(result_split1(1))-1.,*)=SMOOTH(result-mean(result(7000:8191)),5)
;       print,filename_ram,float(result_split1(1))-1.
     ENDFOR

     day=STRMID(STRTRIM(result_split1(0),2),5,2, /REVERSE_OFFSET)
     hour=STRMID(STRTRIM(result_split1(0),2),3,2, /REVERSE_OFFSET)
     minute=STRMID(STRTRIM(result_split1(0),2),1,2, /REVERSE_OFFSET)
     starttime=float(hour)+float(minute)/60.

END
