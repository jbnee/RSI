Pro Fernal_lidar_aod_licel
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
   Data_path="D:\lidar_data\"   ;\Lidar_systems\LidarPro\DePolar\";  2003\jn022058\jn022058.4M""   ; AUR or SPR
   out_path='D:\lidar_data\out2018\';Fernald\'
  year=2009;   year\month
  yr=string(year,format='(I4.4)')
 ; yr=strtrim(year,2);  remove white space

   sg1=fltarr(nx,bnum)
   ;sumsg1=0
  X0=fltarr(nx,bnum) ;average 5 PR2
  X1=fltarr(n5,bnum); PR2
  bk1=fltarr(nx)
  bratio_m=fltarr(n5,bnum)
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
     readf,1,cnt_sig    ; for LICEL
    ; cnt_sig=read_binary(fn, DATA_TYPE=2)  ; cnt_sig  ;SR430 read binary file
    ; plot,cnt_sig
     close,1

      ; treat background
     sg1[Jr,*]=smooth(cnt_sig,10) ;smooth signal
     bk1[Jr]=min(sg1[jr,bnum-200:bnum-1]);
     X0[jr,*]=(sg1[jr,*]-bk1[jr])*(z^2);


    ; oplot,X0[jr,*]+10*Jr,ht,color=2;
     ;xyouts,2000+Jr*100,15,'Files',color=2
     ;V1[jr,*]=X0[jr,*]*exp(-2*(Sa-Sr)*INTB)
   ;
   endfor  ;Jr
     mxa=max(X0)
     plot,X0[0,*],ht,color=2,background=-2,xrange=[0,mxa],yrange=[0,h2],title='PR2_m',xtitle= 'X0:pr2_m',ytitle='km';file 1',color=2

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
X1[14,*]=(X1[12,*]+X1[12,*]+X1[13,*])/3.0
X1[15,*]=(X1[16,*]+X1[17,*])/2.
X1[J2,*]=smooth(X1[J2,*],20);/10
oplot,X1[J2,*],ht,color=iy*3
;print,j2
;wait,1
j2=j2+1
endfor
stop
;For ix=0,n5-1 do begin

; endfor
;stop
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
       h=ht[h0:b2-1]
       m_beta_a=beta_a[*,h0:b2-1]; redefine
       Mbeta=fltarr(n5+1,b2-h0)

       for i5=0,n5-1 do begin
       Mbeta[0,*]=h
       Mbeta[i5+1,*]=m_beta_a[i5,*]
       endfor;i5


       OT1=out_path+fnm+'Mbeta_3.txt'
      openw,2,OT1
       printf,2,Mbeta
       close,2


       stop ;secion IIB

       ;;;;;;plot,m_beta_a
      ; maxa=max(m_beta_a[n5/2,0:b2-b1-1])/5  ; 30 is arbitraryavm_beta_a=total(beta_a,1)/n5 ;average beta_a for m channel
         ; maxa=max(m_beta_a[n5/2,50:b2-b1-52])/5
       avm=total(m_beta_a,1)/n5

       xavm=max(avm)
       h=ht[h0:b2]
       plot,avm,H,xrange=[0,2*xavm], color=2,thick=2, background=-2 ,xtitle='beta_a',ytitle='km'

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
       ENDFOR;ia

       plot,AOD1,psym=4,color=5,background=-2,ytitle='AOD',xtitle='time;#'

       oplot,AOD1,color=2
        AOD=mean(AOD1)
        print,AOD
       ;AOD(IAOD)=mean(AOD1)
       ;print,'IAOD, SA'  ,IAOD,SA,'  AOD: = ',AOD(IAOD)
       ; endfor; IAOD
       stop
       out_file2=out_path+fnm+'AOD.'+'bmp'
       write_bmp,out_file2,tvrd()

       stop ;secion IIB


      bratio_m[0,0:b2-h0]=1+smooth(beta_a[0,0:b2-h0]/beta_r[0:b2-h0],10)
      plot,bratio_m[0,0:b2-h0],ht,color=100,xrange=[0,20],background=-2,title=dnm,xtitle='bacattering ratio',ytitle='km'

      FOR Lm=1,n5-1 do begin
      R=1+smooth(beta_a[Lm,0:b2-h0]/beta_r[0:b2-h0],10)
       bratio_m[Lm,0:b2-h0]=1+smooth(R,10)
       oplot,bratio_m[LM,0:b2-h0],ht, color=5*Lm
       ENDFOR; Lm


      avratio_m=total(bratio_m,1)/n5 ;sumratio/(L+1)
      ;bratio_m=max(avratio)  ; peak backscattering ratio for m
      oplot,avratio_m[0:b2-h0],ht,color=45,linestyle=2,thick=2

      read,ht_ratio,prompt='height for backscattering ratio: as 1.5 km '
      bin_r=ht_ratio/dz

      plot,bratio_m[*,bin_r],color=100,background=-2,title=dnm,xtitle='pk bacattering ratio',ytitle='km'
      meanratio=mean(bratio_m[*,bin_r-5:bin_r+5])
      print,meanratio
      xyouts,10,meanratio*2,'ave backscattering ratio',color=2
      xyouts,10,meanratio*3,meanratio,color=2
      out_file2=out_path+fnm+'ratio_m.'+'bmp'
      write_bmp,out_file2,tvrd()
      stop
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;|Perpendicular channel|;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
bk2=fltarr(nx)
X0d=fltarr(nx,bnum)
X2=fltarr(n5,bnum); PR2

sg2=fltarr(nx,bnum)
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
   sg2[Jr,*]=smooth(cnt_sig,20);smooth signal
   bk2[jr]=mean(sg2[jr,bnum-200:bnum-1]);
   X0d[jr,*]=smooth((sg2[jr,*]-bk2[jr]),20)*(z^2);
   endfor  ;Jr

 bkd=mean(bk2);
 bg_factor=(bkd/bkm)/0.014  ; background correction if air has a depolari 0.014
 xda=max(x0d)
 plot,X0d[0,*],ht,color=2,background=-2,xrange=[0,xda],yrange=[0,h2],title='PR2_d',xtitle= 'X0:pr2_d',ytitle='km';file 1',color=2

;;;;;end data input ;;;;;;;;;;;;;;

;average 5 profiles
 j2=0
FOR i=0 , nx-5, 5 do begin; average 5 profiles
For iy=0,999 do begin
X2[J2,iy]=MEAN(X0d[i:i+4,iy]);/bg_factor
endfor
X2[14,*]=(X2[13,*]+X2[12,*])/2.0
X2[15,*]=(X2[16,*]+X2[17,*])/2.0
X2[J2,*]=smooth(X2[J2,*],20);
oplot,X2[j2,*],h,color=4*i
j2=j2+1
endfor
;For ix=0,n5-1 do begin
;X2[ix,*]=smooth(X2[ix,*],10)
;endfor

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
    b3=b2-h0
    D_beta_B=beta_b[*,h0:b2-1]; redefine
    h=ht[h0:b2-1]

       Dbeta=fltarr(n5+1,b2-h0)
       ;Dbeta[0,*]=h

       for i6=0,n5-1 do begin
       Dbeta[0,*]=h
       Dbeta[i6+1,*]=d_beta_b[i6,*]
       endfor

       OT3=out_path+fnm+'Dbeta.txt'
       openw,2,OT3
       printf,2,Dbeta
       close,2
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

      ;  out_file2=out_path+fnm+' betaB.txt.'
       ; openw,2,out_file2
       ; printf,2,beta_b

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
      OT3=out_path+fnm+'TAODmk.txt'
      SAOD[0,*]=ntime
      SAOD[1,*]=TAOD
      openw,1,OT3
       printf,1,SAOD
       close,1


stop
;;;;
;;;;
     bratio_d=fltarr(n5,bnum)
     bratio_d[0,0:b2-h0]=1+smooth(beta_b[0,0:b2-h0]/beta_r[0:b2-h0],10)
      plot,bratio_d[0,0:b2-h0],ht,color=100,xrange=[0,120],background=-2,title=dnm,xtitle='bacattering ratio',ytitle='km'

      FOR Ld=1,n5-1,10 do begin
        R2=1+beta_b[Ld,0:b2-h0]/beta_r[0:b2-h0]
       bratio_d[Ld,0:b2-h0]=1+smooth(R2,10)
       oplot,bratio_d[Ld,0:b2-h0],ht, color=5*Ld

       ENDFOR; Ld


      ;avratio_d=total(bratio_d,1)/n5 ;sumratio/(L+1)
      ;bratio_m=max(avratio)  ; peak backscattering ratio for m
      ; oplot,avratio_d[0:b2-h0],ht,color=45,linestyle=2,thick=2

      ;xyouts,40,4,'1st and average d backscattering ratio',color=2
      out_file3=out_path+fnm+'bratio_d.'+'bmp'
      write_bmp,out_file3,tvrd()
      stop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;depolarization ratio;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 depolar=dblarr(nx,b2-h0+1)
 adep_ratio=fltarr(bnum)
 R0= Sg2[0,0:b2-h0]/sg1[0,0:b2-h0]
;R0=beta_b[0,0:b2-h0]/(beta_a[0,0:b2-h0]+beta_b[0,0:b2-h0])

 depolar[0,0:b2-h0]=smooth(R0,10)/bg_factor
 plot,depolar[0,0:b2-h0],ht,color=100,xrange=[0,2],background=-2,title=dnm,xtitle='depolariz_ratio',ytitle='km'

      FOR Ld=1,nx-1 do begin; n5-1 do begin
     ; Rn=beta_b[Ld,0:b2-h0]/(beta_a[Ld,0:b2-h0]+beta_b[Ld,0:b2-h0])
       Rn=sg2[Ld,0:b2-h0]/sg1[Ld,0:b2-h0]; ,h, color=5*Lm
       depolar[Ld,0:b2-h0]=smooth(Rn,20)/bg_factor
       ENDFOR; Ld

      av_dep_ratio=total(depolar,1)/nx
     ;avdep_ratio=total(depolar,1)/n5 ;sumratio/(L+1)
      oplot,av_dep_ratio,h,color=40,linestyle=2,thick=2
     ; oplot,avdep_ratio[0:b2-h0],ht,color=45,linestyle=2,thick=2

      ;xyouts,40,4,'1st and average backscattering ratio',color=2
      out_file4=out_path+fnm+'dePolar_ratio_d.'+'bmp'
     ; write_bmp,out_file4,tvrd()
      stop
      read,h3,prompt='peak height km for depolarization ratio: as 1.5 '
      bin3=h3/dz
      depolarX=depolar[0:n5-1,bin3]
      plot,depolarX,color=2,background=-2, xtitle='time',ytitle='depolar ratio',charsize=1.2

     stop
       out_5=out_path+fnm+'depolar '+'bmp'
      ;write_bmp,out_5,tvrd()
       OTx5=out_path+fnm+'depolar_Xkm.txt'
       ADp=fltarr(2,n5)
       ADp[0,*]=ntime
       ADp[1,*]=depolarX
       ntime=indgen(n5)
       openw,1,OTx5
       printf,1,ADp
      close,1
         stop
      end