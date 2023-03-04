Pro Fernal_lidar_mk_1
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
  ;ITz1=fltarr(bnum)
  ;ITz2=fltarr(bnum)
  beta_r=fltarr(bnum+1) ;Rayleigh backscattering coefficient
  kext=fltarr(bnum+1)

  beta_r=dblarr(bnum+1) ;backscattering coefficient of air
   tau=fltarr(bnum+1); Rayleigh optical thickness
   TM=fltarr(bnum+1)  ;  Rayleigh transmission
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
 tau[bnum-1]=kext[bnum-1]*dz1000
 for j=bnum-2,1,-1 do begin
    tau[j]=kext[j]*dz1000+tau[j+1]
    Tm[j]=exp(-2*tau[j])
endfor
plot,tau,ht,position=plot_position1,title='tau',ytitle='km';charsize=2.0
xyouts,0.02,15,'tau optical thickness'
stop
plot,Tm,ht,position=plot_position2,xrange=[0.75,1],ytitle='km',xtitle='opt,thickness';
xyouts,0.85,15,'laser atmospheric transmission'
stop
INTB=fltarr(bnum+1); integral of beta_r from top down
INTB[bnum]=beta_r[bnum]*dz1000

FOR I1=bnum-1,0,-1 do begin

 INTB[I1]=INTB[I1+1]+(beta_r[I1]+beta_r[I1+1])*(dz1000/2)
 ENDFOR

plot,INTB,ht,xtitle='integrated beta_r top down', ytitle='km'

stop

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
   Data_path="F:\lidar_data\"   ;\Lidar_systems\LidarPro\DePolar\";  2003\jn022058\jn022058.4M""   ; AUR or SPR
   out_path='F:\lidar_data\Fernald\'
  year=2009;   year\month
  yr=string(year,format='(I4.4)')
 ; yr=strtrim(year,2);  remove white space

   sg1=fltarr(nx,bnum)
   ;sumsg1=0
  X0=fltarr(nx,bnum) ;average 5 PR2
  X=fltarr(n5,bnum); PR2

  bratio=dblarr(n5,bnum)
  h1=0
  read,h1, h2,prompt='h1,h2 height region as0, 6 km  '
  lo_bin=floor(h1/dz)
  hi_bin=floor(h2/dz)
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
     bk1=mean(sg1[jr,bnum-200:bnum-1]);
     X0[jr,*]=(sg1[jr,*]-bk1)*(z^2);

     if (Jr eq 0) then begin
     plot,X0[jr,*],ht,color=2,background=-2,yrange=[0,h2],title='PR2_m',xtitle= 'X0:pr2_m',ytitle='km';file 1',color=2
     endif; else begin
    ; oplot,X0[jr,*]+10*Jr,ht,color=2;
     ;xyouts,2000+Jr*100,15,'Files',color=2
     ;V1[jr,*]=X0[jr,*]*exp(-2*(Sa-Sr)*INTB)
   ;
   endfor  ;Jr


 stop  ; section 1  Pr2_m
;;;;;end data input ;;;;;;;;;;;;;;


;average 5 profiles
 j2=0
FOR i=0 , nx-5, 5 do begin; average 5 profiles
For iy=0,999 do begin
X[J2,iy]=MEAN(X0[i:i+4,iy])

endfor
j2=j2+1
endfor
For ix=0,n5-1 do begin
X[ix,*]=smooth(X[ix,*],10)
endfor

;Part II Backscattering coefficient calculation  based on Fernald 1984
;5 files are averaged

 b2=hi_bin+2
 gbin=hi_bin-lo_bin
 ;Izt= 840;            ;top beam at 20 km which is 840

 BTM=dblarr(n5,b2)  ; だダ  denumerator of Fernald eq. (5) and (6)
 BTMb=dblarr(n5,b2)
 BTM1=dblarr(n5,b2)  ; first term in BTM
 BTM2=dblarr(n5,b2)  ;2nd term in BTM
;SBTM2=fltarr(n5)  ;2nd term in BTM
 A=fltarr(b2) ;A term in Fernald
 V=fltarr(n5,b2)
 beta_a=fltarr(n5,b2)
 ;beta_2=fltarr(n5,b2)
 ;sumbtm2=fltarr(n5)
       ;Initial condition
    ;BTM1[*,b2]=0         ; X[*,1250]/((beta_r[1250]+beta_a[*,1250]/1.E-6))
     BTM2[*,b2-1]=0;     Sa*(X[*,0]+X[*,0])*EXP(A[0])*dz
     BTM[*,b2-1]=0;    BTM1[*,0]+BTM2[*,0]

     beta_a[*,b2-1]=0;  beta_r(hi_bin-1)  ;initial condition at top  =beta_a

  ; stop
; evaluation of the second bottom term below
   ;;;;; INTB[I1]=INTB[I1+1]+(beta_r[I1]+beta_r[I1-1])*(dz1000/2)

 For nj=0,n5-1  do begin  ;from starting file n1 to last file n2
   For k =b2-1 ,1,-1 do begin   ;calculation start from hi_bin
     A[k-1]=2*(Sa-Sr)*INTB[k-1];   *take positive values; (beta_r[k]+beta_r[k-1])*dz1000/2
     V[nj,k-1]=X[nj,k-1]*exp(A[k-1])
     BTM1[nj,k-1]=X[nj,k-1]/(beta_r[k-1]+beta_a[nj,k-1])
      ;BTM2[nj,k]=BTM2[njk+1]+Sa*(X[nj,k+1]+(V[nj,k]+X[nj,k+1])/2)*dz1000
      BTM2[nj,k-1]=BTM2[nj,k]+Sa*(X[nj,k]+(X[nj,k]+X[nj,k-1])/2)*dz1000

      BTM[nj,k-1]=BTM1[nj,k-1]+BTM2[nj,k-1]

     ; beta_a[nj,k]=(V[nj,k])/(BTM[nj,k])-(beta_r[k]);
     ; Beta_2[nj,k]=(V[nj,k])/(BTMb[nj,k])-(beta_r[k]);
   Endfor  ;k

   endfor   ;nj
  V=V[*,1:b2-1] ; throw away the edge terms
  BTM=BTM[*,1:b2-1]
  h0=50 ; ignore 50 bins below
  Vv=V[*,h0:hi_bin];
  BBTM=BTM[*,h0:hi_bin]
  beta_a=Vv/BBTM; ;-beta_r[lo_bin:hi_bin]


     ;;;;;;;;;;;;;;;;;;;;renormalize beta_a to remote negative values
     ;;;;;negative values are replace by beta_r
      ;beta_a and ave_beta_a
     ;READ,rmv,prompt='remove files'
   ;  beta_a[rmv,*]=0
      m_beta_a=beta_a; redefine

       ;;;;;;plot,m_beta_a
      ; maxa=max(m_beta_a[n5/2,0:hi_bin-lo_bin-1])/5  ; 30 is arbitraryavm_beta_a=total(beta_a,1)/n5 ;average beta_a for m channel
          maxa=max(m_beta_a[n5/2,50:hi_bin-lo_bin-51])/5
       avm_beta_a=total(m_beta_a,1)/n5

      ; h=ht[lo_bin:hi_bin]
       h=ht[h0:hi_bin]
       plot,avm_beta_a,H,yrange=[h1,4],xrange=[0,0.00005], color=2,thick=2, background=-2 ,xtitle='beta_a',ytitle='km'

       for m2=0,n5-1 do begin
       ; m5_beta_a=(m_beta_a[m2,*]+m_beta_a[m2+1,*]+m_beta_a[m2+2,*]+m_beta_a[m2+3,*]+m_beta_a[m2+4,*])/5
       ; oplot,m5_beta_a+m2,ht,color=2;
        oplot,m_beta_a[m2,*]+m2*1e-6,h,color=20*m2
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

       for ia=0,n5-1 do begin

       AOD1[ia]=total(m_beta_a(ia,bc1:bc2),2)*7.5*SA
       endfor
       plot,AOD1,psym=4,color=2,background=-2,ytitle='AOD',xtitle='time;#'

       oplot,AOD1,color=120
       stop
       AOD=mean(AOD1)
       print,'AOD:  ',AOD

      ; plot,m_beta_a[n5/2,*]/maxa,ht,xrange=[0,6],yrange=[h1,h2], color=2, background=-2 ,xtitle='beta_a',ytitle='km'


        stop
       out_file1=out_path+fnm+'beta_m.'+'bmp'
       write_bmp,out_file1,tvrd()
       OT1=out_path+fnm+'m_beta.txt'
       openw,2,OT1
       printf,2,m_beta_a
       close,2


       stop ;secion IIB


       ;bratio=1+beta_a[1,100:hi_bin]/beta_r[100:hi_bin]

      bratio[0,0:hi_bin-h0]=1+smooth(beta_a[0,0:hi_bin-h0]/beta_r[0:hi_bin-h0],10)
      plot,bratio[0,0:hi_bin-h0],ht,color=100,xrange=[0,100],yrange=[0,h2],background=-2,title=dnm,xtitle='bacattering ratio',ytitle='km'

       for Lm=1,n5-1 do begin
       bratio[Lm,0:hi_bin-h0]=1+smooth(beta_a[Lm,0:hi_bin-h0]/beta_r[0:hi_bin-h0],10)
       endfor


      avratio_m=total(bratio,1)/n5 ;sumratio/(L+1)
      ;bratio_m=max(avratio)  ; peak backscattering ratio for m
      oplot,avratio_m[0:hi_bin-h0],ht,color=45,linestyle=2,thick=2

      xyouts,40,4,'1st and average backscattering ratio',color=2
      out_file2=out_path+fnm+'ratio_m.'+'bmp'
      write_bmp,out_file2,tvrd()
      stop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;|Perpendicular channel|;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
X2=fltarr(n5,bnum); PR2


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
     sg1[Jr,*]=smooth(cnt_sig,10) ;smooth signal
     bk2=mean(sg1[jr,bnum-200:bnum-1]);
     X0[jr,*]=(sg1[jr,*]-bk2)*(z^2);

     if (Jr eq 0) then begin
     plot,X0[jr,*],ht,color=2,background=-2,yrange=[0,h2],title='PR2_d',xtitle= 'X0:pr2_d',ytitle='km';file 1',color=2
     endif; else begin

   endfor  ;Jr


 stop  ; section 1  Pr2_m
;;;;;end data input ;;;;;;;;;;;;;;


;average 5 profiles
 j2=0
FOR i=0 , nx-5, 5 do begin; average 5 profiles
For iy=0,999 do begin
X2[J2,iy]=MEAN(X0[i:i+4,iy])

endfor
j2=j2+1
endfor
For ix=0,n5-1 do begin
X2[ix,*]=smooth(X[ix,*],10)
endfor

;Part II Backscattering coefficient calculation  based on Fernald 1984
;5 files are averaged



 BTM=dblarr(n5,b2)  ; だダ  denumerator of Fernald eq. (5) and (6)
 BTMb=dblarr(n5,b2)
 BTM1=dblarr(n5,b2)  ; first term in BTM
 BTM2=dblarr(n5,b2)  ;2nd term in BTM
;SBTM2=fltarr(n5)  ;2nd term in BTM
 A2=fltarr(b2) ;A term in Fernald
 V2=fltarr(n5,b2)
 beta_b=fltarr(n5,b2)

       ;Initial condition
    ;BTM1[*,b2]=0         ; X[*,1250]/((beta_r[1250]+beta_a[*,1250]/1.E-6))
     BTM2[*,b2-1]=0;     Sa*(X[*,0]+X[*,0])*EXP(A2[0])*dz
     BTM[*,b2-1]=0;    BTM1[*,0]+BTM2[*,0]

     beta_b[*,b2-1]=0;  beta_r(hi_bin-1)  ;initial condition at top  =beta_a

  ; stop
; evaluation of the second bottom term below
   ;;;;; INTB[I1]=INTB[I1+1]+(beta_r[I1]+beta_r[I1-1])*(dz1000/2)

 For mj=0,n5-1  do begin  ;from starting file n1 to last file n2
   For k =b2-1 ,1,-1 do begin   ;calculation start from hi_bin
     A2[k-1]=2*(Sa-Sr)*INTB[k-1];   *take positive values; (beta_r[k]+beta_r[k-1])*dz1000/2
     V2[mj,k-1]=X2[mj,k-1]*exp(A2[k-1])
     BTM1[mj,k-1]=X2[mj,k-1]/(beta_r[k-1]+beta_b[mj,k-1])

      BTM2[mj,k-1]=BTM2[mj,k]+Sa*(X2[mj,k]+(X2[mj,k]+X2[mj,k-1])/2)*dz1000

      BTM[mj,k-1]=BTM1[mj,k-1]+BTM2[mj,k-1]

     ; beta_a[mj,k]=(V2[mj,k])/(BTM[mj,k])-(beta_r[k]);
     ; Beta_2[mj,k]=(V2[mj,k])/(BTMb[mj,k])-(beta_r[k]);
   Endfor  ;k

   endfor   ;mj
  V2=V2[*,1:b2-1] ; throw away the edge terms
  BTM=BTM[*,1:b2-1]
  h0=50 ; ignore 50 bins below
  V2v=V2[*,h0:hi_bin];
  BBTM=BTM[*,h0:hi_bin]
  beta_b=V2v/BBTM; ;-beta_r[lo_bin:hi_bin]


     ;;;;;;;;;;;;;;;;;;;;renormalize beta_b to remote negative values
     ;;;;;negative values are replace by beta_r
      ;beta_b and ave_beta_b
     ;READ,rmv,prompt='remove files'
   ;  beta_b[rmv,*]=0
     ;d_beta_b=beta_b; redefine

       ;;;;;;plot,d_beta_b
      ; maxba=max(beta_b[n5/2,0:hi_bin-lo_bin-1])/5  ; 30 is arbitraryavbeta_b=total(beta_b,1)/n5 ;average beta_b for m channel
          maxb=max(beta_b[n5/2,50:hi_bin-lo_bin-51])/5
        av_beta_d=total(beta_b,1)/n5

      ; h=ht[lo_bin:hi_bin]
       h=ht[h0:hi_bin]

      plot,(av_beta_d)/maxb,H,yrange=[h1,4],color=2,thick=2,background=-2,xtitle='beta_b',ytitle='km'

       for m3=0,n5-1 do begin

        oplot,beta_b[m3,*]/maxb+m3*1e-6,h,color=20*m3
        ;wait,0.5
         endfor  ;m3

       stop

        out_file2=out_path+fnm+' beta_b.txt.'
        openw,2,out_file2
        printf,2,beta_b

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;depolarization ratio;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      bk_factor=bk2/bk1  ; ratio of background signal to determine PMT response
      correction_factor=bk_factor/0.014  ;0.014 is the depolarization for air

     ; bratio_m=max(avratio_m)  ;maximum bratio_m
     ; bratio_d=max(avratio_d)   ;peak backscattering ratio
       ;depol_ratio=(beta_b/m_beta_a)
    ;
   ;  print,'factor= ',bk_factor;'peak depolarization ratio:',pk_depol_ratio
   ;   dep_r=string(pk_depol_ratio)
    ;  p_depr='depolariz ratio'+dep_r
    ;  xyouts,10,h2-1,p_depr,color=2
    ;   out_file4=out_path+fnm+'ratio_d2.'+'bmp'
   ;  write_bmp,out_file4,tvrd()
   ; stop
      ;define xdprx as depolarization ratio
     ; xdpr0=(1/correction_factor)*d_beta_a[0,0:hi_bin]/(d_beta_a[0,0:hi_bin]+m_beta_a[0,0:hi_bin])
     ; plot,xdpr0,ht,color=2,thick=2,background=-2,xrange=[1,1],yrange=[0,h2],xtitle='depol,ratio',ytitle='km'

      av_d=(total(beta_b,1)/n5)/correction_factor  ;average d_beta_a
      av_m=total(m_beta_a,1)/n5  ; ave m_beta_a

       ;dep_ratio=av_d[0:gbin-h0]/(av_d[0:gbin-h0]+av_m[0:gbin-h0])


      ;dep_ratio=av_d[0:gbin]/(av_d[0:gbin]+av_m[0:gbin])
      ;bkdp=mean(dep_ratio[hi_bin-100:hi_bin])
     ; dep_ratio=dep_ratio-bkdp;
       ;plot,dep_ratio[0:300],h,color=3,thick=2,background=-2,xrange=[0,1],yrange=[h1,h2],xtitle='ave-depol,ratio',ytitle='km'

      stop


     ;Read, ztop, PROMPT='Enter top height km to store data: '
      zbin=gbin-h0
      depx=(beta_b[*,0:zbin]/(beta_b[*,0:zbin]+m_beta_a[*,0:zbin]))/correction_factor
      depolar=total(depx,1)/n5
      plot,depolar[0:300],h,color=3,thick=2,background=-2,xtitle='ave-depol,ratio',ytitle='km'
      out_file5=out_path+fnm+'depolar_ratio_all.'+'bmp'
      write_bmp,out_file5,tvrd()
      close,1


stop
end