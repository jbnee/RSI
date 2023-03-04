Pro READ_lidar_md
; In the first part we will read data and plot;
; In the second part, we will process signal according to Fernald
; Part I Rayleigh calcution
 ; read,bnum, prompt='Enter total number bins (eg.4096)  '
   ;constants  for the program
   device, decomposed=0
   Loadct,5
  bT=50      ;160 ns for SR430 bin width

   ns=1.0E-9   ;nanosecond
   c=3.0E8     ;speed of light
    bnum= 4000  ;24 km
   dz= bT*ns*(c/2)/1000  ;increment in height is dz=
   ht=(findgen(bnum+1)+1)*dz  ; height in km start from dz meter
   dz1000=dz*1000 ;in meter
   z=ht*1000 ; in meter
  ;treat Rayleigh scattering

  ;  bn=fltarr(bnum+1); bin array of 1250 for 1250*0.024=30km
  ;ITz1=fltarr(bnum)
  ;ITz2=fltarr(bnum)


;Part 2 Read data
  close,/all
;;;;;;;;;;;;;;;;;;;;;Parallel channel;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;


  ;event=0
  ;RB=fltarr(16,30)  ; output file type
  dnm=''
  Read, dnm, PROMPT='Enter filename dnm as ja162136;'   ; Enter date+code
  month=strmid(dnm,0,2)
  fnm=strmid(dnm,0,4)
  READ,n1, n2, PROMPT='Intial and final records;eg.10,100 129: '
  n1=fix(n1)
  n2=fix(n2)
  nx=n2-n1+1
  n5=round(nx/5.0)  ;average 5 profiles
  ;Data_path="D:\lidar_files\Depolar\";\Lidar_systems\LidarPro\DePolar\";  2003\jn022058\jn022058.4M""   ; AUR or SPR
   Data_path='F:\lidar_data\'; 2008Licel\"   ;\Lidar_systems\LidarPro\DePolar\";  2003\jn022058\jn022058.4M""   ; AUR or SPR
   out_path='F:\lidar_data\temp\'; lidarPro\output\yrmn"
  yr=''
  year=2009;Licel;   year\month
  yr=string(year,format='(I4.4)')
 ; yr=strtrim(year,2);  remove white space

   sg1=fltarr(nx,bnum)
   sg2=fltarr(nx,bnum)
   ;sumsg1=0
  X10=fltarr(nx,bnum) ;average 5 PR2
  X1=fltarr(n5,bnum); PR2m
   X20=fltarr(nx,bnum); PR2d
  X2=fltarr(n5,bnum);  smoothed PR2d
  bratio=dblarr(n5,bnum)
  read,h2,prompt='height region as 6 km  '
  h1=0
  lo_bin=floor(h1/dz)
  hi_bin=floor(h2/dz)
  ; input data
  ; data_file=fltarr(n2-n1,bnum)
   cnt_sig1=fltarr(bnum)
    cnt_sig2=fltarr(bnum)

;;;;;input data
  For Jr=0,nx-1  do begin  ;1st For ; automatically read as many files
     jf=n1+jr ;file index starting from n1
      ;multp=n2-n1+1/Mav
    ni=strcompress(jf,/remove_all)

    ;fn1=Data_path+month+'\'+ dnm+'.'+ni+'m'
    fn1=Data_path+yr+'\'+month+'\'+ dnm+'.'+ni+'m'

   ;  out_file1=data_path+'\output\'+'pr2m.txt'

     openr,1,fn1;    m  data_file;
     readf,1,cnt_sig1
     ;cnt_sig=read_binary(fn, DATA_TYPE=2)  ; cnt_sig  ;read binary file
    ; plot,cnt_sig
     close,1

      ; treat background
     sg1[Jr,*]=smooth(cnt_sig1,10) ;smooth signal
     bk1=mean(sg1[jr,bnum-200:bnum-1]);
     X10[jr,*]=(sg1[jr,*]-bk1)*(z^2);


     if (Jr eq 0) then begin
     plot,X10[jr,*],ht,color=2,background=-2,yrange=[0,h2],title='PR2_m',xtitle= 'X10:pr2_m',ytitle='km';file 1',color=2
     endif else begin
    ; oplot,X10[jr,*]+10*Jr,ht,color=2;
     ;xyouts,2000+Jr*100,15,'Files',color=2
     ;V1[jr,*]=X10[jr,*]*exp(-2*(Sa-Sr)*INTB)
   endelse
   endfor  ;Jr

;average 5 profiles
 j2=0
FOR i=0 , nx-5, 5 do begin; average 5 profiles
For iy=0,999 do begin
X10[J2,iy]=MEAN(X10[i:i+4,iy])

endfor
j2=j2+1
endfor
For ix=0,n5-1 do begin
X1[ix,0:hi_bin]=smooth(X10[ix,0:hi_bin],10)
oplot,X1[ix,0:hi_bin],ht,color=5*ix
endfor

 outfile1=out_path+fnm+'_pr2m.txt'
openw,2, outfile1
printf,2,X1
close,2
stop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;input d file;;;;;;;;;;;;;;;;;;;;;;;;;;
 For Jr=0,nx-1  do begin  ;1st For ; automatically read as many files
     jf=n1+jr ;file index starting from n1
      ;multp=n2-n1+1/Mav
    ni=strcompress(jf,/remove_all)



    fn2=Data_path+yr+'\'+month+'\'+dnm+'.'+ni+'d'

     openr,1,fn2;    m  data_file;
     readf,1,cnt_sig2
    close,1
     sg2[Jr,*]=smooth(cnt_sig2,10) ;smooth signal
     bk2=mean(sg2[jr,bnum-200:bnum-1]);
     X20[jr,*]=(sg2[jr,*]-bk2)*(z^2);


     if (Jr eq 0) then begin
     plot,X20[jr,*],ht,color=2,background=-2,yrange=[0,h2],title='PR2_d',xtitle= 'X20:pr2_d',ytitle='km';file 1',color=2
     endif else begin

   endelse
   endfor  ;Jr

;average 5 profiles
 j2=0
FOR i=0 , nx-5, 5 do begin; average 5 profiles
For iy2=0,999 do begin
X20[J2,iy2]=MEAN(X20[i:i+4,iy2])

endfor
j2=j2+1
endfor
For ix2=0,n5-1 do begin
X2[ix2,0:hi_bin]=smooth(X20[ix2,0:hi_bin],10)
oplot,x2[ix2,0:hi_bin],ht,color=5*ix2
endfor ;ix2

 outfile1=out_path+fnm+'_pr2d.txt'
openw,2, outfile1
printf,2,X2
close,2
stop
end