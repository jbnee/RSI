Pro Fernald_2017
; In the first part we will read data and plot;
; In the second part, we will process signal according to Fernald
;Part I Rayleigh calcution
 ; read,bnum, prompt='Enter total number bins (eg.4096)  '
   ;constants  for the program
   bT=50      ;160 ns for SR430 bin width

   ns=1.0E-9   ;nanosecond
   c=3.0E8     ;speed of light
    bnum= 5000  ;24 km
   dz= bT*ns*(c/2)/1000  ;increment in height is dz=24 m
   ht=findgen(5000)*dz  ; height in km
   dz1000=dz*1000 ;in meter
  ;treat Rayleigh scattering

    bn=fltarr(bnum+1); bin array of 1250 for 1250*0.024=30km
  ;ITz1=fltarr(bnum)
  ;ITz2=fltarr(bnum)
  beta_r=fltarr(bnum+1) ;Rayleigh backscattering coefficient
  kext=fltarr(bnum+1)

  beta_r=dblarr(bnum+1) ;backscattering coefficient of air
   TAU=fltarr(bnum+1); Rayleigh optical thickness
   TM=fltarr(bnum+1)  ;  Rayleigh transmission
      ;density=fltarr(bnum+1);air density
      ;density= 1.E25*(2.4498-0.22114*ht+0.00701*ht^2-7.75225E-5*ht^3)  ;ht in km; in molec/m3
     beta_r=5.45E-32*(550./532.)^4*density(ht)  ;Rayleigh backscattering coefficient

     plot,beta_r,ht, background=-2,color=2,title='Rayleigh backscattering coefficient',ytitle='km',xtitle='beta -m'
     stop
  Sa=32; lidar ratio  ;for cirrus cloud
  Sr=8*!pi/3; lidar ratio for air

   kext=(8*3.1416/3.)*beta_r   ;Rayleigh extinction
 for j=1,bnum-1 do begin
    tau[j]=kext[j]*dz+tau[j-1]
    Tm[j]=exp(-2*tau[j])
endfor
plot,tau,ht,position=plot_position1,title='tau',ytitle='km';charsize=2.0
xyouts,0.02,15,'tau optical thickness'
plot,Tm,ht,position=plot_position2,xrange=[0.75,1],ytitle='km',xtitle='opt,thickness';
xyouts,0.85,15,'laser atmospheric transmission'
stop
INTB=fltarr(bnum+1); integral of beta_r from top down
INTB[bnum]=0
FOR I1=bnum-1,1,-1 do begin

 INTB[I1]=INTB[bnum]+(beta_r[I1]+beta_r[I1-1])*(dz1000/2)
ENDFOR
plot,INTB,ht
INTB=fltarr(bnum+1); integral of beta_r from top down
INTB[bnum]=0
FOR I1=bnum-1,1,-1 do begin

 INTB[I1]=INTB[bnum]+(beta_r[I1]+beta_r[I1-1])*(dz1000/2)
ENDFOR
plot,INTB,ht,xtitle='integrated beta_r top down', ytitle='km'

stop
;Part 2 Read data
  close,/all




  event=0
  ;RB=fltarr(16,30)  ; output file type
  ; dnm=''
  ;file_hd=''

 ; Read, dnm, PROMPT='Enter filename dnm as ja152233;'   ; Enter date+code
  ;month=strmid(dnm,0,2)

 ; READ,n1, n2, PROMPT='Intial and final records;eg.10,100 129: '
  n1=1;  fix(n1)
  n2=10; fix(n2)
  nx=n2-n1+1
   n5=nx/5
   sg=fltarr(n2-n1+1,bnum)
   sumsg=0
  X0=fltarr(n2-n1+1,bnum) ;average 5 PR2
  X=fltarr(n5,bnum); PR2
  V1=fltarr(nx,bnum)  ;  ¤À¤l¶µ upper term in Fernald
  beta_a=dblarr(n5,bnum)  ;backscattering coefficient of aerosol
  bratio=dblarr(n5,bnum)
  read,h1,h2,prompt='height region as 1, 6 km  '
  ; input data
   data_file=fltarr(n2-n1,bnum)
   cnt_sig=fltarr(bnum)
  Data_path1="F:\lidar_data\2016\1019\P6_m";\Lidar_systems\LidarPro\DePolar\";  2003\jn022058\jn022058.4M""   ; AUR or SPR
  Data_path2="F:\lidar_data\2016\1019\P6_d"
  yr='';   year\month
  yr=2016
  ;Read,yr,  prompt='Enter  Yearas 2009 '
   out_path='f:\lidar_data\output\'; lidarPro\output\yrmn"
  m_file=file_search(Data_path1+'\e*'); where data files are
  d_file=file_search(Data_path2+'\e*') ;

  ht=0.0075*findgen(5000)/2
  ;sig=fltarr(nx,20204)
;;;;;;;;;;;;;;;read 1st data;;;;;;;;;;;;;;;;;;;;


  fn0=m_file[0]; Data_path+yr+'\'+month+'\'+dnm+'.'+ni+'m'              ;+Dtype ;


     openr,1,fn0; for LICEL data_file in decimal


    sig0=read_binary(fn0,DATA_TYPE=2)

     close,1

    plot,sig0[10202:15201],ht
    stop
    nsig=10000  ;;take last 10000 data for photon counting signals, odd are 0's
    ;ncs=nsig[1]  ;;number of data
    m1=indgen(5000)  ;we take 5000 data points
    sig1=sig0[10202:20201] ;; number of elements of  half data starting 10102 to 20201
    sigc=sig1[2*m1]   ;;take non-zero elements
    oplot,sigc+1000,ht*2
  stop
;;;;;;; read more data


     sig2=fltarr(nx,5000)
     sig=fltarr(nx,5000)
  For J=0,nx-1  do begin  ;1st For ; automatically read as many files
     Jf=n1+J ;file index starting from n1
      ;multp=n2-n1+1/Mav
    ni=strcompress(Jf,/remove_all)

    fn1=m_file[J]; Data_path+yr+'\'+month+'\'+dnm+'.'+ni+'m'              ;+Dtype ;

   ;out_file=data_path+'\output\'+'_prf.'+'bmp'

     openr,1,fn1; for LICEL data_file in decimal

     ;Read data
     sigJ=read_binary(fn1,DATA_TYPE=2)

     sigJx=sigJ[10202:20201]  ;;;adjust these numbers

     sig2[J,0:4999]=sigJx[2*m1]


     close,1

    endfor; J
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  plot,sig2[0,*],ht*2
stop; 5
 ;;;;;;;;;;;;pick photon counting signals: the last second part of data
 cnt_sig=fltarr(nx,5000)
   FOR j2=0,nx-1 do begin
     cnt_sig[J2,*]=sig2[J2,*]  ; for photon counting signa;define 5000 elements
     bk=mean(cnt_sig[J2,4500:4999]);  treat background
     ;Analog=sig[0:4990]
     ;readf,1,cnt_sig  ; decimal data
   Endfor  ; j2
     ;cnt_sig=cnt[0:4999]
     plot,cnt_sig[0,*]-bk,ht*2,xtitle='Count/channel',color=2,background=-2
  stop;6

 For Jr=0, nx-1 do begin
     sg[Jr,*]=smooth(cnt_sig[Jr,*],10)-bk ;smooth signal
          ;maxsg=max(sg)
        ; sumsg=sumsg+sg
      z=ht*1000 ; in meter
      X0[jr,*]=sg[Jr,*]*(z^2);*Tm

    if (Jr eq 0) then begin
        plot,X0[jr,*],ht*2,color=2,background=-2,yrange=[h1,h2],title='PR2_m',xtitle= 'pr2_m',ytitle='km';file 1',color=2
    endif else begin
       oplot,X0[jr,*]+10*Jr,ht*2,color=2;
       ;xyouts,2000+Jr*100,15,'Files',color=2
       ;V1[jr,*]=X0[jr,*]*exp(-2*(Sa-Sr)*INTB)
     endelse
     endfor ;Jr
close,1
;plot,V1[0:10,*],ht
 stop  ; section 1
;;;;;
;average 5 profiles
 j2=0
FOR i=0 , nx-5, 5 do begin; average 5 profiles
  For iy=0,999 do begin
    X[J2,iy]=MEAN(X0[i:i+4,iy])

  endfor
j2=j2+1
endfor
stop
 lo_bin=h1/dz
 hi_bin=h2/dz



  sumratio=0
       For L=1,n5-1 do begin;  n2-n1 do begin
       bratio[L,0:hi_bin]=1+smooth(beta_a[L,0:hi_bin]/beta_r[0:hi_bin],10)
       oplot,bratio[L,0:hi_bin],ht,color=1  ;hi_bin-100
       ;stop
       sumratio=sumratio+bratio[L,0:hi_bin]
       endfor
     stop

     avratio=sumratio/(L+1)
     oplot,avratio,ht,color=4,linestyle=2,thick=5
     stop    ;Section III
      out_file2=out_path+dnm+'ratio_m.'+'bmp'
     ;write_bmp,out_file2,tvrd()
     stop
END





