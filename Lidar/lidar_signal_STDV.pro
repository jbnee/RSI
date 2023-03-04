Pro lidar_signal_STDV
 bT=160      ;160 ns for SR430 bin width

   ns=1.0E-9   ;nanosecond
   c=3.0E8     ;speed of light
    bnum= 1000  ;24 km
   dz= bT*ns*(c/2)/1000  ;increment in height is dz=24 m
   ht=findgen(bnum)*dz  ; height in km
   dz1000=dz*1000 ;in meter
   z=ht*1000 ; in meter
  ;treat Rayleigh scattering

    bn=fltarr(bnum+1); bin array of 1250 for 1250*0.024=30km
  ;ITz1=fltarr(bnum)
  ;ITz2=fltarr(bnum)
  beta_r=fltarr(bnum+1) ;Rayleigh backscattering coefficient
  kext=fltarr(bnum+1)

  beta_r=dblarr(bnum+1) ;backscattering coefficient of air

;Part 1 Read data
  close,/all

  Data_path="F:\lidar_data\";\Lidar_systems\LidarPro\DePolar\";  2003\jn022058\jn022058.4M""   ; AUR or SPR

  year=''
  Read,year,  prompt='Enter  Year as 2003: '

  yr=strtrim(year,2);  remove white space


  event=0
  ;RB=fltarr(16,30)  ; output file type
  dnm=''

  Read, dnm, PROMPT='Enter filename dnm as ja162136;'   ; Enter date+code
  month=strmid(dnm,0,2)

  READ,n1, n2, PROMPT='Intial and final records;eg.10,100 129: '
  n1=fix(n1)
  n2=fix(n2)
  nx=n2-n1+1
  m0=10  ;average number usually 5
  n5=nx/m0
  F1=strtrim(fix(n1),2)
  F2=strtrim(fix(n2),2)
  FS='                                       file:'+F1+'_'+F2;used to print title
  Ftitle=yr+dnm


   sg=fltarr(n2-n1+1,bnum)
   sumsg=0
  PR2M=fltarr(n2-n1+1,bnum) ;average 5 PR2
  X=fltarr(n5,bnum); PR2
  ;V1=fltarr(nx,bnum)  ;  ¤À¤l¶µ upper term in Fernald
  beta_a=dblarr(n5,bnum)  ;backscattering coefficient of aerosol
  bratio=dblarr(n5,bnum)
  read,h1,h2,prompt='height region as 0, 6 km  '
  lobin=round(h1/dz)
  hibin=round(h2/dz)

  ; input data
   data_file=fltarr(n2-n1,bnum)
   cnt_sig=fltarr(bnum)
  For Jr=0,nx-1  do begin  ;1st For ; automatically read as many files
     jf=n1+jr ;file index starting from n1
      ;multp=n2-n1+1/Mav
    ni=strcompress(jf,/remove_all)

    fn=Data_path+yr+'\'+month+'\'+dnm+'.'+ni+'m'              ;+Dtype ;

   ; out_file=data_path+'\output\'+'_prf.'+'bmp'
    ; openr,1,fn; data_file;
    ; readf,1,cnt_sig
     cnt_sig=read_binary(fn, DATA_TYPE=2)  ; cnt_sig  ;read binary file
    ; plot,cnt_sig
     close,1
      cnt_sig=cnt_sig(0:bnum-1)
     bk=mean(cnt_sig[bnum-200:bnum-1]);  treat background
     sg[Jr,*]=smooth(cnt_sig,5)-bk ;smooth signal
          ;maxsg=max(sg)
        ; sumsg=sumsg+sg
     ;for mr=0:bnum-1 ; to remove negative
      if min(sg[jr,*]) le 0 then sg[jr,*]=sg[jr,*]-min(sg[jr,*])

     ;endfor;mr

      PR2M[jr,*]=sg[jr,*]*(z^2);*Tm

       ; if (Jr eq 0) then begin
       ; plot,PR2M[jr,*],ht,color=2,background=-2,yrange=[h1,h2],title='PR2_m',xtitle= 'pr2_m',ytitle='km';file 1',color=2
       ; endif else begin
        ; oplot,pr2m[jr,*],ht,color=2
       ;  endelse
      ENDFOR; Jr

  ; stop
     M=round(nx/m0)
   PR2M_m=fltarr(M,bnum)
    STD=fltarr(bnum)
    P_STD=FLTARR(bnum)

     for J0=0,M-1 do begin

      FOR i=0,nx-m0,m0 do begin; average m0 profiles



       For iy=0,bnum-1 do begin
         PR2m_m[J0,iy]=MEAN(PR2M[i:i+m0-1,iy])

        ; P_STD[J0]=MEANABSDEV(Pr2m_M[J0,iy])/mean(Pr2m[*,iy])
       endfor; iy
       if (J0 eq 0) then begin
        plot,PR2M_M[J0,*],ht,color=2,background=-2,yrange=[h1,h2],title='PR2_m',xtitle= 'pr2_m',ytitle='km';file 1',color=2
       endif else begin
         oplot,pr2m_M[J0,*]+J0*1000000,ht,color=2
         ;meanPr2m_m[J0,iy])

       endelse
       ;wait,1

    ENDFOR;   i
   endfor ; J0
     stop
    ; window,1
    TPR2M_M=total(PR2M_M,1)/M
    plot,TPR2M_M,ht,color=2,background=-2,yrange=[h1,h2],title='total PR2_m',xtitle= 'pr2_m',ytitle='km'
    stop
      for k=0,hibin-1 do begin
       err[k]=MEANABSDEV(Pr2m[*,k])/mean(Pr2m[*,k])  ;
      endfor; k
     ; plot,P_std,ht,color=2,background=-2
  stop  ; section 1
   errplot,TPR2m_m-err/2,TPR2M_m+err/2,ht,color=2


 end