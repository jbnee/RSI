Pro Fernal_lidar_mk
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

    bn=fltarr(bnum+1); bin array of 1250 for 1250*0.024=30km

  beta_r=fltarr(bnum+1) ;Rayleigh backscattering coefficient
  kext=fltarr(bnum+1)

  beta_r=dblarr(bnum+1) ;backscattering coefficient of air

      ;density=fltarr(bnum+1);air density
      ;density= 1.E25*(2.4498-0.22114*ht+0.00701*ht^2-7.75225E-5*ht^3)  ;ht in km; in molec/m3
     N0=density(ht) ;
     beta_r=5.45E-32*(550./532.)^4*N0 ;density(ht)  ;Rayleigh backscattering coefficient

     plot,beta_r,ht,color=60, background=-2,title='Rayleigh backscattering coefficient',ytitle='km',xtitle='beta-r'
     stop
     Sa=50; lidar ratio  ;for cirrus cloud
     Sr=8*!pi/3; lidar ratio for air

     kext=(8*3.1416/3.)*beta_r   ;Rayleigh extinction

;;;;;;;;;;;;;;;;;;;;;;Rayleigh calculation;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;Part 2 Read data
  close,/all
;;;;;;;;;;;;;;;;;;;;;Parallel channel;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;


  ;event=0
  ;RB=fltarr(16,30)  ; output file type
  dnm=''
  Read, dnm, PROMPT='Enter filename dnm as ja152233;'   ; Enter date+code
  month=strmid(dnm,0,2)
  fnm=strmid(dnm,0,4)
  READ,n1, n2, PROMPT='Intial and final records;eg.10,225: '
  n1=fix(n1)
  n2=fix(n2)
  nx=n2-n1+1
  n5=round(nx/5.0)  ;average 5 profiles
  ;Data_path="D:\lidar_files\Depolar\";\Lidar_systems\LidarPro\DePolar\";  2003\jn022058\jn022058.4M""   ; AUR or SPR
   Data_path="F:\lidar_data\"   ;\Lidar_systems\LidarPro\DePolar\";  2003\jn022058\jn022058.4M""   ; AUR or SPR
   out_path='F:\lidar_data\Fernald\'
  year=2009;   year\month
  yr=string(year,format='(I4.4)')
 ; yr=strtrim(year,2);  remove white space

   sg1=fltarr(nx,bnum)
   ;sumsg1=0
  X0=fltarr(nx,bnum) ;average 5 PR2
  X1=fltarr(n5,bnum); PR2
  bk1=fltarr(nx)
  bratio=dblarr(n5,bnum)
  h1=0
  read,h1, h2,prompt='h1,h2 height regi on as  0, 6 km  '
  b1=floor(h1/dz)
  b2=floor(h2/dz)
  ; input data
   data_file=fltarr(n2-n1,bnum)
   cnt_sig=fltarr(bnum)

;;;;;input data
  For Jr=0,nx-1  do begin  ;1st For ; automatically read as many files
     jf=n1+jr ;file index starting from n1
      ;multp=n2-n1+1/Mav
    ni=strcompress(jf,/remove_all)

    ;fn=Data_path+yr+'\'+month+'\'+dnm+'.'+ni+'m'              ;+Dtype ;
    fn=Data_path+yr+'\'+month+'\'+ dnm+'.'+ni+'m'
   ; out_file=data_path+'\output\'+'_prf.'+'bmp'
     openr,1,fn; data_file;
     readf,1,cnt_sig
     ;cnt_sig=read_binary(fn, DATA_TYPE=2)  ; cnt_sig  ;read binary file
    ; plot,cnt_sig
     close,1

      ; treat background
     sg1[Jr,*]=smooth(cnt_sig,10) ;smooth signal
     bk1[Jr]=min(sg1[jr,bnum-200:bnum-1]);
     X0[jr,*]=(sg1[jr,*]-bk1[jr])*(z^2);

     if (Jr eq 0) then begin
     plot,X0[jr,*],ht,color=2,background=-2,yrange=[0,h2],title='PR2_m',xtitle= 'X0:pr2_m',ytitle='km';file 1',color=2
     endif; else begin
    ; oplot,X0[jr,*]+10*Jr,ht,color=2;
     ;xyouts,2000+Jr*100,15,'Files',color=2
     ;V1[jr,*]=X0[jr,*]*exp(-2*(Sa-Sr)*INTB)
   ;
   endfor  ;Jr
  bkm=mean(bk1)

 stop  ; section 1  Pr2_m
;;;;;end data input ;;;;;;;;;;;;;;

;X2=fltarr(n5,bnum);
;average 5 profiles
 j2=0
FOR i=0 , nx-5, 5 do begin; average 5 profiles
For iy=0,999 do begin
X1[J2,iy]=MEAN(X0[i:i+4,iy])
;x2[J2,IY]=(X0[i,iy]+x0[i+1,iy]+X0[i+2,iy]+X0[i+3,iy]+X0[i+4,iy])/5
endfor

X1[J2,*]=smooth(X1[J2,*],20)
oplot,X1[J2,*],ht,color=iy*3
j2=j2+1
endfor
stop
For ix=0,n5-1 do begin

endfor

;Part II Backscattering coefficient calculation  based on Fernald 1984
;5 files are averaged


 gbin=b2-b1
 ;Izt= 840;            ;top beam at 20 km which is 840

 BTM=dblarr(n5,b2)  ; だダ  denumerator of Fernald eq. (5) and (6)
 BTMb=dblarr(n5,b2)
 BTM1=dblarr(n5)  ; first term in BTM
 BTM2=dblarr(n5,b2)  ;2nd term in BTM
;SBTM2=fltarr(n5)  ;2nd term in BTM
 A=fltarr(b2) ;A term in Fernald
 V=fltarr(n5,b2)
 beta_a=fltarr(n5,b2)
 beta_a[*,b2-1]=0;  beta_r(b2-1)  ;initial condition at top  =beta_a

  ; stop
; evaluation of the second bottom term below
   ;;;;; INTB[I1]=INTB[I1+1]+(beta_r[I1]+beta_r[I1-1])*(dz1000/2)
  A[b2-1]=(Sa-Sr)*beta_r[b2-1]
 For nj=0,n5-1  do begin  ;from starting file n1 to last file n2
     BTM1[nj]=X1[nj,b2-1]/(beta_r[b2-1]+beta_a[nj,b2-1])
     BTM2[nj,b2-1]=0
   For k =b2-1 ,1,-1 do begin   ;calculation start from b2
     A[k-1]=2*(Sa-Sr)*(beta_r[k-1]+beta_r[k]);INTB[k-1];   *take positive values; (beta_r[k]+beta_r[k-1])*dz1000/2
     V[nj,k-1]=X1[nj,k-1]*exp(A[k-1])
     ;BTM1[nj,k-1]=X1[nj,k-1]/(beta_r[k-1]+beta_a[nj,k-1])

      BTM2[nj,k-1]= BTM2[nj,k]+SA*(V[nj,k]+V[nj,k-1])*dz1000

      BTM[nj,k-1]=BTM1[nj]+BTM2[nj,k-1]

   Endfor  ;k
   endfor   ;nj

   beta_a=V/BTM

     ;;;;;;;;;;;;;;;;;;;;renormalize beta_a to remote negative values
     ;;;;;negative values are replace by beta_r
      ;beta_a and ave_beta_a
     ;READ,rmv,prompt='remove files'
       h0=50
       h=ht[50:b2-1]
      m_beta_a=beta_a[*,h0:b2-1]; redefine

       ;;;;;;plot,m_beta_a
      ; maxa=max(m_beta_a[n5/2,0:b2-b1-1])/5  ; 30 is arbitraryavm_beta_a=total(beta_a,1)/n5 ;average beta_a for m channel
         ; maxa=max(m_beta_a[n5/2,50:b2-b1-52])/5
       avm=total(m_beta_a,1)/n5

      ; h=ht[b1:b2]
       h=ht[h0:b2]
       plot,avm,H,xrange=[0,0.00001], color=2,thick=2, background=-2 ,xtitle='beta_a',ytitle='km'

       for m2=0,n5-1 do begin
       ; m5_beta_a=(m_beta_a[m2,*]+m_beta_a[m2+1,*]+m_beta_a[m2+2,*]+m_beta_a[m2+3,*]+m_beta_a[m2+4,*])/5
       ; oplot,m5_beta_a+m2,ht,color=2;
        oplot,m_beta_a[m2,*],h,color=20*m2
        ;wait,0.5
         endfor  ;m2

       stop
        out_file1=out_path+fnm+'mbeta_a.'+'bmp'
       write_bmp,out_file1,tvrd()

       ;xAOD=total(m_beta_a,2)*SA*7.5 ; this is the AOD of each set of profile
       ;AOD=total(xAOD,1)/n5
       AOD1=fltarr(n5)
       AOD1[0]=0

       read,hc1,hc2,prompt='cloud height region in km as 1,3 km'
       bc1=0;round(hc1/dz)
       bc2=round(hc2/dz)

       FOR ia=0,n5-1 do begin

       AOD1[ia]=total(m_beta_a(ia,bc1:bc2),2)*7.5*SA
       ENDFOR

       plot,AOD1,psym=4,color=5,background=-2,ytitle='AOD',xtitle='time;#'

       oplot,AOD1,color=2

       AOD=mean(AOD1)
       print,'AOD:  ',AOD

       stop
       out_file2=out_path+fnm+'AOD2.'+'bmp'
       write_bmp,out_file2,tvrd()
       OT1=out_path+fnm+'m_betaA.txt'
       openw,2,OT1
       printf,2,m_beta_a
       close,2

       stop ;secion IIB


      bratio[0,0:b2-h0]=1+smooth(beta_a[0,0:b2-h0]/beta_r[0:b2-h0],10)
      plot,bratio[0,0:b2-h0],ht,color=100,xrange=[0,10],background=-2,title=dnm,xtitle='bacattering ratio',ytitle='km'

       for Lm=1,n5-1 do begin
       bratio[Lm,0:b2-h0]=1+smooth(beta_a[Lm,0:b2-h0]/beta_r[0:b2-h0],10)
       endfor


      avratio_m=total(bratio,1)/n5 ;sumratio/(L+1)
      ;bratio_m=max(avratio)  ; peak backscattering ratio for m
      oplot,avratio_m[0:b2-h0],ht,color=45,linestyle=2,thick=2

      xyouts,40,4,'1st and average backscattering ratio',color=2
      out_file2=out_path+fnm+'ratio_m.'+'bmp'
      write_bmp,out_file2,tvrd()
      stop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;|Perpendicular channel|;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
X2=fltarr(n5,bnum); PR2
bk2=fltarr(nx)

For Jr=0,nx-1  do begin  ;1st For ; automatically read as many files
     jf=n1+jr ;file index starting from n1
      ;multp=n2-n1+1/Mav
    ni=strcompress(jf,/remove_all)

    ;  ;
    fn2=Data_path+yr+'\'+month+'\'+ dnm+'.'+ni+'d'

     openr,1,fn2; data_file;
     readf,1,cnt_sig
     ;cnt_sig=read_binary(fn, DATA_TYPE=2)  ; cnt_sig  ;read binary file
    ; plot,cnt_sig
     close,1

      ; treat background
     sg1[Jr,*]=smooth(cnt_sig,20) ;smooth signal
     bk2[jr]=min(sg1[jr,bnum-200:bnum-1]);
     X0[jr,*]=smooth((sg1[jr,*]-bk2[jr]),20)*(z^2);
   endfor  ;Jr

  plot,X0[0,*],h,color=2,background=-2,title='PR2_d',xtitle= 'X0:pr2_d',ytitle='km';file 1',color=2
  bkd=mean(bk2)

;;;;;end data input ;;;;;;;;;;;;;;
 bk_factor=(bkd/bkm)/0.014  ; background correction if air has a depolari 0.014

;average 5 profiles
 j2=0
FOR i=0 , nx-5, 5 do begin; average 5 profiles
For iy=0,999 do begin
X2[J2,iy]=MEAN(X0[i:i+4,iy]);/bk_factor
endfor
X2[J2,*]=smooth(X2[J2,*],20)
oplot,X2[j2,*],h,color=4*i
j2=j2+1
endfor
;For ix=0,n5-1 do begin
;X2[ix,*]=smooth(X2[ix,*],10)
;endfor
X2=X2/bk_factor

 stop  ; section 1  Pr2_m


;Part II Backscattering coefficient calculation  based on Fernald 1984
;5 files are averaged



 BTM=dblarr(n5,b2)  ; だダ  denumerator of Fernald eq. (5) and (6)

 BTM1=dblarr(n5)  ; first term in BTM
 BTM2=dblarr(n5,b2)  ;2nd term in BTM

 A2=fltarr(b2) ;A term in Fernald
 V2=fltarr(n5,b2)
 beta_b=fltarr(n5,b2)

       ;Initial condition
    ;BTM1[*,b2]=0         ; X[*,1250]/((beta_r[1250]+beta_a[*,1250]/1.E-6))
     BTM2[*,b2-1]=0;     Sa*(X[*,0]+X[*,0])*EXP(A2[0])*dz
     BTM[*,b2-1]=0;    BTM1[*,0]+BTM2[*,0]

     beta_b[*,b2-1]=0;  beta_r(b2-1)  ;initial condition at top  =beta_a


 For mj=0,n5-1  do begin  ;from starting file n1 to last file n2
    BTM1[mj]=X2[mj,b2-1]/(beta_r[b2-1]+beta_a[mj,b2-2])
    BTM2[mj,b2-1]=0

   For k =b2-1 ,1,-1 do begin   ;calculation start from b2
     A2[k-1]=2*(Sa-Sr)*(beta_r[k-1]+beta_r[k]);   *take positive values; (beta_r[k]+beta_r[k-1])*dz1000/2
     V2[mj,k-1]=X2[mj,k-1]*exp(A2[k-1])
     ;BTM1[mj,k-1]=X2[mj,k-1]/(beta_r[k-1]+beta_b[mj,k-1])

     BTM2[mj,k-1]=BTM2[mj,k]+SA*(V2[mj,k]+V2[mj,k-1])*dz1000

     BTM[mj,k-1]=BTM1[mj]+BTM2[mj,k-1]

     Endfor  ;k

   endfor   ;mj
    beta_b=V2/BTM; ;-beta_r[b1:b2]

    D_beta_B=beta_B[*,h0:b2-1]; redefine
    b3=b2-h0
       ;;;;;;plot,m_beta_a
      ; maxa=max(m_beta_a[n5/2,0:b2-b1-1])/5  ; 30 is arbitraryavm_beta_a=total(beta_a,1)/n5 ;average beta_a for m channel
      ;  maxb=max(d_beta_b[n5/2,50:b2-b1-52])/5
       AVd=total(D_beta_B,1)/n5

     ;;;;;;;;;;;;;;;;;;;;renormalize beta_b to remote negative values

      plot,beta_b[0,*],h,color=2,background=-2

      FOR m3=0,n5-1,5 do begin

        oplot,beta_b[m3,*],h,color=20*m3
        ;wait,0.5
      ENDFOR  ;m3

       stop

        out_file2=out_path+fnm+' betaB.txt.'
        openw,2,out_file2
        printf,2,beta_b

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;depolarization ratio;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


      ; avdepx=(AVd/AVm)
      depx=fltarr(n5,b3)  ;b3=b2-h0
     ; AVdepolar=total(depx,1)/n5
    ;  plot,AVdepx,h,color=3,thick=2,yrange=[0,4],background=-2,xtitle='ave-depol,ratio',ytitle='km'
      y0=indgen(750)+1
      y0=y0/y0
      plot,y0,h,xrange=[0,1],color=2,background=-2
      for jp=0,n5-1 do begin
        ;depx[jp,*]=D_beta_b[jp,*]/(m_beta_a[jp,*]+D_beta_b[jp,*])
         depx[jp,0:b3-1]=smooth(x2[jp,0:b3-1]/x1[jp,0:b3-1],10)
       oplot,depx[jp,*],h,color=2*jp,thick=2;,background=-2,xtitle='ave-depol,ratio',ytitle='km'
      endfor

      STOP
        avdepolar=total(depx,1)/n5
       plot,AVdepolar,h,color=3,thick=2,xrange=[0,1],yrange=[0,4],background=-2,xtitle='ave-depol,ratio',ytitle='km'
       for k1=0,n5-5,5 do begin
       oplot,depx[k1,*]+k1*.2,h,color=k1*4
       endfor


      out_file5=out_path+fnm+'depolar_ratio_all.'+'bmp'
      write_bmp,out_file5,tvrd()
      close,1


stop
end