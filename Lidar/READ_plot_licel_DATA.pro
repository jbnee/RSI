Pro READ_PLOT_Licel_DATA
;  We will read LICEL data and plot;
; In the second part, we will process signal according to Fernald
;Part I Rayleigh calcution
 ; read,bnum, prompt='Enter total number bins (eg.4096)  '
   ;constants  for the program
   bT=50      ;160 ns for SR430 bin width

   ns=1.0E-9   ;nanosecond
   c=3.0E8     ;speed of light
   bnum= 4000  ;24 km
   dz= bT*ns*(c/2)/1000  ;increment in height is dz=24 m
   ht=findgen(bnum)*dz  ; height in km
   dz1000=dz*1000 ;in meter
   z=ht*1000 ; in meter
  ;treat Rayleigh scattering

    bn=fltarr(bnum+1); bin array of 1250 for 1250*0.024=30km
 !p.multi=[0,1,2]
    !p.background=255
     pl1 = [0.1,0.15,0.98,0.49]; plot_position 1
     pl2 = [0.1,0.6,0.98,0.94];  plot_position 2

;Part 2 Read data
  close,/all

  Data_path="F:\lidar_data\";

  year=2009;   year\month
  yr=strtrim(year,2);  remove white space

  ;Read,yr,  prompt='Enter  Year as 2009 '

  event=0
  ;RB=fltarr(16,30)  ; output file type
  dnm=''
  fnm=strmid(dnm,0,4)

  Read, dnm, PROMPT='Enter filename dnm as ja162136;'   ; Enter date+code
  month=strmid(dnm,0,2)

  READ,n1, n2, PROMPT='Intial and final records;eg.10,100 129: '
  n1=fix(n1)
  n2=fix(n2)
  nx=n2-n1+1
  n5=nx/5
  F1=strtrim(fix(n1),2)
  F2=strtrim(fix(n2),2)
  FS='                         file:'+F1+'_'+F2;used to print title
  Ftitle=yr+dnm

  ;define arrays

  sg=fltarr(nx,bnum)
  cnt_sig=fltarr(bnum)
  PR2=fltarr(n2-n1+1,bnum) ;average 5 PR2
  X=fltarr(n5,bnum); PR2

  read,h1,h2,prompt='height region as 1, 6 km  '
  ; input data
  ;

  For Jr=0,nx-1  do begin  ;1st For ; automatically read as many files
     jf=n1+jr ;file index starting from n1
      ;multp=n2-n1+1/Mav
    ni=strcompress(jf,/remove_all)

    fn1=Data_path+yr+'\'+month+'\'+dnm+'.'+ni+'m'  ;input filename
    fn2=Data_path+yr+'\'+month+'\'+dnm+'.'+ni+'d'  ;input filename

    openr,1,fn1
    readf,1,cnt_sig

     ;cnt_sig=read_binary(fn, DATA_TYPE=2)  ; cnt_sig  ;read binary file
    ;
     close,1
    ; cnt_sig=cnt_sig(0:bnum-1)
      bk=mean(cnt_sig[bnum-200:bnum-1]);  treat background
   ;for jr=0,nx do begin
      sg[Jr,*]=smooth(cnt_sig,10)-bk ;smooth signal

     PR2[jr,*]=sg[jr,*]*(z^2)


   endfor;   jr

 a0=max(PR2[0,*])
 plot,PR2[0,*],ht,color=2,background=-2,xrange=[0,10*a0],yrange=[h1,h2],position=plt1,title='PR2_m',xtitle= 'pr2_m',ytitle='km';file 1',color=2
 stop

;average 5 profiles
 j2=0
FOR i=0 , nx-5, 5 do begin; average 5 profiles
 oplot,PR2[i,*]+i*a0/5,ht,color=2
For iy=0,bnum-1 do begin
  X[J2,iy]=MEAN(PR2[i:i+4,iy])

endfor
  j2=j2+1
endfor
stop
;;;;;;;;;;;;;;;;;;;;;;;; read d channel;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
for jd=0,nx-1 do begin
     sg[jd,*]=smooth(cnt_sig,10)-bk ;smooth signal

     PR2[jd,*]=sg[jd,*]*(z^2)

endfor; jd
 a0=max(PR2[0,*])
 plot,PR2[0,*],ht,color=2,background=-2,xrange=[0,10*a0],yrange=[h1,h2],position=plt2,title='PR2_d',xtitle= 'pr2_m',ytitle='km';file 1',color=2
 stop

;average 5 profiles
 j2=0
FOR i=0 , nx-5, 5 do begin; average 5 profiles
 oplot,PR2[i,*]+i*a0/5,ht,color=2
For iy=0,bnum-1 do begin
  X[J2,iy]=MEAN(PR2[i:i+4,iy])

endfor ;jy
  j2=j2+1
endfor; i
stop
end