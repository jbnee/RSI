Pro READ_SR430

bpath='F:\lidar_data\355nm\2004\ma\'
dnm=''
Read, dnm, PROMPT='Enter filename dnm as de262313:  '

;'   ; Enter date+code
;  month=strmid(dnm,0,2)
  fnm=strmid(dnm,0,4); Enter date+code
  ;F1=bpath+dnm
  n1=1
  nx=10
  bin=24
  tbin=8192
  H=indgen(1000)*bin
  cnt_sig1=fltarr(nx,tbin)
  cnt_sig2=fltarr(nx,tbin)
  For Jr=0,nx-1  do begin  ;1st For ; automatically read as many files
    jf=n1+jr ;file index starting from n1
      ;multp=n2-n1+1/Mav
    ni=strcompress(jf,/remove_all)

     fn1=bpath+ dnm+'.'+ni+'m'
     fn2=bpath+dnm+'.'+ni+'d'

     cnt_sig1[Jr,*]=read_binary(fn1,data_type=2)
     cnt_sig2[Jr,*]=read_binary(fn2,data_type=2)
     ;read_binary(fn1, DATA_TYPE=2)  ; cnt_sig  ;read binary file
   endfor

    plot,cnt_sig1[0,0:999],H/1000.,yrange=[0,10],xrange=[0,200]
    oplot,cnt_sig2[0,0:999],H/1000
   for kr=1,nx-1 do begin
     oplot,cnt_sig1[kr,0:999],H/1000.
    oplot,cnt_sig2[kr,0:999],H/1000


    endfor
    stop
    end