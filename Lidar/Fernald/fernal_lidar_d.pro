Pro Fernal_lidar_d
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
     Sa=45; lidar ratio  ;for cirrus cloud
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
   out_path='F:\lidar_data\out_2018\';Fernald\'
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
     bk2[jr]=mean(sg1[jr,bnum-200:bnum-1]);
     X0[jr,*]=(sg1[jr,*]-bk2[jr])*(z^2);
   endfor  ;Jr

  plot,X0[0,*],ht,color=2,background=-2,yrange=[0,h2],title='PR2_d',xtitle= 'X0:pr2_d',ytitle='km';file 1',color=2
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



 BTM=dblarr(n5,b2)  ; ¤À¥À  denumerator of Fernald eq. (5) and (6)

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

      plot,beta_b[0,*],h,color=2,background=-2,yrange=[0,h2]

      FOR m3=0,n5-1,5 do begin

        oplot,beta_b[m3,*],h,color=20*m3
        ;wait,0.5
      ENDFOR  ;m3

       stop

        out_file2=out_path+fnm+' betaB.txt.'
        openw,2,out_file2
        printf,2,beta_b

      TAOD=fltarr(n5)

       TAOD[0]=0

      FOR Ib=0,n5-1 do begin
       Tbeta=m_beta_a(Ib,bc1:bc2)+d_beta_b[Ib,bc1:bc2]
       TAOD[Ib]=total(Tbeta,2)*7.5*SA
      ENDFOR; Ib
       plot,TAOD,psym=4,color=5,background=-2,ytitle='AOD',xtitle='time;#'

      oplot,TAOD,color=2
      oplot,AOD1,color=120
        AOD_t=mean(TAOD)
        print,AOD_t
     out_file3=out_path+fnm+'TAOD.'+'bmp'
       write_bmp,out_file3,tvrd()
      ntime=indgen(n5)
      SAOD=fltarr(2,n5)
      OT3=out_path+fnm+'AOD_summk.txt'
      SAOD[0,*]=ntime
      SAOD[1,*]=TAOD
      ;openw,1,OT3
      ; printf,1,SAOD
       close,1


stop
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;depolarization ratio;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 depolar=dblarr(n5,bnum)
 adep_ratio=fltarr(bnum)
 R0=beta_b[0,0:b2-h0]/(beta_a[0,0:b2-h0]+beta_b[0,0:b2-h0])
 depolar[0,0:b2-h0]=smooth(R0,10)
      plot,depolar[0,0:b2-h0],ht,color=100,xrange=[0,2],background=-2,title=dnm,xtitle='depolariz_ratio',ytitle='km'

      FOR Ld=1,n5-1 do begin
      Rn=beta_b[Ld,0:b2-h0]/(beta_a[Ld,0:b2-h0]+beta_b[Ld,0:b2-h0])
      depolar[Ld,0:b2-h0]=smooth(Rn,10)
       oplot,depolar[Ld,0:b2-h0],ht, color=5*Lm
       ENDFOR; Ld


      avdep_ratio=total(depolar,1)/n5 ;sumratio/(L+1)

      oplot,avdep_ratio[0:b2-h0],ht,color=45,linestyle=2,thick=2

      ;xyouts,40,4,'1st and average backscattering ratio',color=2
      out_file4=out_path+fnm+'dePolar_ratio_d.'+'bmp'
      write_bmp,out_file4,tvrd()
      stop
      read,h3,prompt='peak height km for depolarization ratio: as 1.5 '
      bin3=h3/dz
      depolarX=depolar[0:n5-1,bin3]
      plot,depolarX,color=2,background=-2, xtitle='time',ytitle='depolar ratio',charsize=1.2
      out_file5=out_path+fnm+'depolar '+'bmp'
       write_bmp,out_file5,tvrd()
       OT5=out_path+fnm+'depolar_Xkm.txt'
       ntime=indgen(n5-1)
       openw,1,OT5
       printf,1,depolarX
       close,1
         stop
      end