Pro Fernal_lidar_mk_test
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
   out_path='F:\lidar_data\temp\'; lidarPro\output\yrmn"
  yr=''
  year=2009;   year\month
  yr=string(year,format='(I4.4)')
 ; yr=strtrim(year,2);  remove white space

   sg1=fltarr(nx,bnum)
   ;sumsg1=0
  X0=fltarr(nx,bnum) ;average 5 PR2
  X=fltarr(n5,bnum); PR2

  bratio=dblarr(n5,bnum)
  read,h1,h2,prompt='height region as 1, 6 km  '
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
     endif else begin
    ; oplot,X0[jr,*]+10*Jr,ht,color=2;
     ;xyouts,2000+Jr*100,15,'Files',color=2
     ;V1[jr,*]=X0[jr,*]*exp(-2*(Sa-Sr)*INTB)
   endelse
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
     A[k-1]=+2*(Sa-Sr)*INTB[k-1];   *take positive values; (beta_r[k]+beta_r[k-1])*dz1000/2
     V[nj,k-1]=X[nj,k-1]*exp(+A[k-1])
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
  beta_a=V/BTM; ;-beta_r[lo_bin:hi_bin]


     ;;;;;;;;;;;;;;;;;;;;renormalize beta_a to remote negative values
     ;;;;;negative values are replace by beta_r
      ;beta_a and ave_beta_a
      READ,rmv,prompt='remove files'
      beta_a[rmv,*]=0
      m_beta_a=beta_a; redefine

       ;;;;;;plot,m_beta_a
       maxa=max(m_beta_a[n5/2,0:hi_bin-lo_bin-1])/5  ; 30 is arbitraryavm_beta_a=total(beta_a,1)/n5 ;average beta_a for m channel

       avm_beta_a=total(m_beta_a,1)/n5

       h=ht[lo_bin:hi_bin]
       plot,avm_beta_a,H,yrange=[h1,4],xrange=[0,0.00005], color=2,thick=2, background=-2 ,xtitle='beta_a',ytitle='km'

       for m2=0,n5-1 do begin
       ; m5_beta_a=(m_beta_a[m2,*]+m_beta_a[m2+1,*]+m_beta_a[m2+2,*]+m_beta_a[m2+3,*]+m_beta_a[m2+4,*])/5
       ; oplot,m5_beta_a+m2,ht,color=2;
        oplot,m_beta_a[m2,*]+m2*1e-6,h,color=20*m2
        ;wait,0.5
         endfor  ;m3

       stop
        out_file1=out_path+fnm+'mbeta_a.'+'bmp'
       write_bmp,out_file1,tvrd()

       ;xAOD=total(m_beta_a,2)*SA*7.5 ; this is the AOD of each set of profile
       ;AOD=total(xAOD,1)/n5
       AOD1=fltarr(n5)
       AOD1[0]=0

       read,hc1,hc2,prompt='cloud height region in km as 1,3 km'
       bc1=round(hc1/dz)
       bc2=round(hc2/dz)

       for ia=0,n5-1 do begin

       AOD1[ia]=total(m_beta_a(ia,bc1:bc2),2)*7.5*SA
       endfor
       plot,AOD1,psym=2,color=2,background=-2,ytitle='AOD',xtitle='time;#'
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

      bratio[0,0:hi_bin]=1+smooth(beta_a[0,0:hi_bin]/beta_r[0:hi_bin],10)
      plot,bratio[0,0:hi_bin],ht,color=100,xrange=[0,100],yrange=[0,h2],background=-2,title=dnm,xtitle='bacattering ratio',ytitle='km'

       for Lm=1,n5-1 do begin
       bratio[Lm,0:hi_bin]=1+smooth(beta_a[Lm,0:hi_bin]/beta_r[0:hi_bin],10)
       endfor


      avratio_m=total(bratio,1)/n5 ;sumratio/(L+1)
      ;bratio_m=max(avratio)  ; peak backscattering ratio for m
      oplot,avratio_m[0:hi_bin],ht,color=45,linestyle=2,thick=2

      xyouts,40,4,'1st and average backscattering ratio',color=2
      out_file2=out_path+fnm+'ratio_m.'+'bmp'
      write_bmp,out_file2,tvrd()
      stop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;|Perpendicular channel|;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    sg2=fltarr(n2-n1+1,bnum) ;signal for d channe;'
      For Jr=0,n5-1  do begin  ;1st For ; automatically read as many files
     jf=n1+jr ;file index starting from n1
      ;multp=n2-n1+1/Mav
    ni=strcompress(jf,/remove_all)

   ; fn=Data_path+yr+'\'+month+'\'+dnm+'.'+ni+'d'              ;+Dtype ;
     fn=Data_path+yr+'\'+month+'\'+dnm+'.'+ni+'d'              ;+Dtype ;

   ; out_file=data_path+'\output\'+'_prf.'+'bmp'
     openr,1,fn; data_file;
     readf,1,cnt_sig
     ;cnt_sig=read_binary(fn, DATA_TYPE=2)  ; cnt_sig  ;read binary file
    ; plot,cnt_sig
     close,1
    ; cnt_sig=cnt_sig(0:bnum-1)
     bk2=mean(cnt_sig[bnum-200:bnum-1]);  treat background
     sg2[Jr,*]=smooth(cnt_sig,10)-bk2 ;smooth signal



     X0[jr,*]=sg2[jr,*]*(z^2);*Tm

     if (Jr eq 0) then begin
        plot,X0[jr,*],ht,color=2,background=-2,xrange=[0,2e7],yrange=[0,h2],$
        title='PR2_d',xtitle= 'pr2_d',ytitle='km';file 1',color=2
     endif else begin

   endelse
   endfor  ;jr

   stop  ; section 1
                 ;;;;;
            ;average 5 profiles
     J3=0
     For i=0, n5-5, 5 do begin; average 5 profiles

     For iy=0,1999 do begin
         X[J3,iy]=MEAN(X0[i:i+4,iy])

     endfor  ;jy
          j3=j3+1
     endfor  ;i
;stop
;Part II Backscattering coefficient calculation  based on Fernald 1984
;5 files are averaged


 ;Izt= 840; bnum-            ;top beam at 20 km which is 840

 BTM=dblarr(n5,b2)  ; だダ  denumerator of Fernald eq. (5) and (6)
 BTM1=dblarr(n5)  ; first term in BTM
 BTM2=dblarr(n5,b2)  ;2nd term in BTM
 A=fltarr(b2) ;A term in Fernald
 V=fltarr(n5,b2)
 beta_a=fltarr(n5,b2)
 ;sumbtm2=fltarr(n5)


BTM2[*,b2-1]=0;
BTM[*,b2-1]=0;
beta_a(*,b2-1)=0;         10*beta_r(hi_bin-1)  ;initial condition at top  =beta_a


  ; stop
; evaluation of the second bottom term below
;b2=hi_bin
  For nj=0,n5-1  do begin  ;from starting file n1 to last file n2

    BTM1[nj]=X[nj,hi_bin]/(beta_r[hi_bin]+beta_a[nj,hi_bin])
    ;while (BTM1[nj] eq 0) do begin
     ; b2=b2-1
     ; BTM1[nj]=X[nj,b2]/(beta_r[b2]+beta_a[nj,b2])
    ;endwhile


   For k =hi_bin-1 ,1,-1 do begin   ;calculation start from hi_bin
     A[k-1]=-2*(Sa-Sr)*INTB[k-1]  ;(beta_r[k]+beta_r[k-1])*dz1000
     V[nj,k-1]=X[nj,k-1]*exp(A[k-1])
     BTM2[nj,k-1]=BTM2[nj,k]+Sa*(X[nj,k]+(X[nj,k]+X[nj,k-1])/2)*dz1000
     ;BTM2[nj,k-1]=BTM2[nj,k]+Sa*(X[nj,k]+X[nj,k -1]*exp(A[k]+A[k-1]))*dz1000
     BTM[nj,k-1]=BTM1[nj]+BTM2[nj,k-1]
     ;beta_a[nj,k]=(V[nj,k])/(BTM[nj,k])-(beta_r[k]);
   Endfor  ;k

   endfor   ;nj
    V=V[*,1:b2-1] ; throw away the edge terms
    TM=BTM[*,1:b2-1]
    beta_a=V/BTM; ;-beta_r[lo_bin:hi_bin]
    maxb=max(beta_a[0,*])
    plot,beta_a[0,0:hi_bin],ht,color=1,yrange=[0,4],xrange=[0,maxb],background=-2,xtitle='d_beta_a'

    ;;;;special treatment for the following channels for ja092139
  ;  beta_a[3,*]=beta_a[2,*] ;
   ; beta_a[10,*]=-beta_a[10,*]
  ;  beta_a[11,*]=-beta_a[11,*]
  ;  beta_a[37,*]=beta_a[36,*]
   ; beta_a[41,*]=beta_a[40,*]
   ; beta_a[62,*]=beta_a[61,*]
   ;  beta_a[63,*]=beta_a[61,*]
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;oplot,avd_beta_a,ht,color=2,thick=2
    xyouts,0.00002,4,color=2,'1st and average d channel beta_a'
    stop



      out_file3=out_path+fnm+'beta_d2.'+'bmp'
      write_bmp,out_file3,tvrd()
      d_beta_a=beta_a[*,lo_bin+1:hi_bin-1] ;redefine for d channel

   ;  For IS1=0,sz[1]-1 do begin
      ;  For IS2=0,sz[2]-1 do begin
     ;   if (d_beta_a[IS1,IS2] LE 0) then begin
       ;  d_beta_a[IS1,IS2]=beta_r[IS2]
;
      ;  endif
      ; endfor; IS2

      ; endfor   ;IS1

     maxb=max(d_beta_a[30,lo_bin+10:hi_bin-10])/5

       plot,d_beta_a[n5/2,*]/maxb,ht,xrange=[0,80],yrange=[h1,h2], color=50, background=-2 ,xtitle='dbeta_a',ytitle='km'

       for m3=50,n5-1 do begin
       ; d_beta_a=(d_beta_a[m3,*]+d_beta_a[m3+1,*]+d_beta_a[m3+2,*]+d_beta_a[m3+3,*]+m_beta_a[m3+4,*])/5
        oplot,d_beta_a[m3,*]/maxb+m3,ht,color=10*m3;
        endfor  ;m3

     stop
       OT2=out_path+fnm+'d_beta.txt'
       openw,2,OT2
       printf,2,d_beta_a
       close,2

       ;bratio=1+beta_a[1,100:hi_bin]/beta_r[100:hi_bin]

       bratio[0,0:gbin-1]=1+smooth(d_beta_a[0,0:gbin-1]/beta_r[0:gbin-1],10)
       plot,bratio[0,0:gbin],ht,color=120,background=-2,xrange=[0,10],yrange=[h1,h2],title=dnm,xtitle='Perpendicular bacattering ratio 0',ytitle='km'

       for Ld=1,n5-1 do begin
       bratio[Ld,0:gbin]=1+smooth(d_beta_a[Ld,0:gbin]/beta_r[0:gbin],10)
       endfor ;Ld

       avratio_d=total(bratio,1)/n5 ;sumratio/(L+1)



       oplot,avratio_d[0:gbin],ht,color=45,linestyle=2,thick=2
       xyouts,10,4,'1st and average d backscattering ratio ',color=2


     stop    ;Section III: depolarization ratio


     bk_factor=bk2/bk1  ; ratio of background signal to determine PMT response
     correction_factor=bk_factor/0.014  ;0.014 is the depolarization for air

      bratio_m=max(avratio_m)  ;maximum bratio_m
      bratio_d=max(avratio_d)   ;peak backscattering ratio
      pk_depol_ratio=(bratio_d/bratio_m)/correction_factor
      ;
    ;
     print,'factor= ',bk_factor,'peak depolarization ratio:',pk_depol_ratio
      dep_r=string(pk_depol_ratio)
      p_depr='depolariz ratio'+dep_r
      xyouts,10,h2-1,p_depr,color=2
       out_file4=out_path+fnm+'ratio_d2.'+'bmp'
     write_bmp,out_file4,tvrd()
     stop
      ;define xdprx as depolarization ratio
     ; xdpr0=(1/correction_factor)*d_beta_a[0,0:hi_bin]/(d_beta_a[0,0:hi_bin]+m_beta_a[0,0:hi_bin])
     ; plot,xdpr0,ht,color=2,thick=2,background=-2,xrange=[1,1],yrange=[0,h2],xtitle='depol,ratio',ytitle='km'

      av_d=(total(d_beta_a,1)/n5)/correction_factor  ;average d_beta_a
      av_m=total(m_beta_a,1)/n5  ; ave m_beta_a
      dep_ratio=av_d[0:gbin]/(av_d[0:gbin]+av_m[0:gbin])
      ;bkdp=mean(dep_ratio[hi_bin-100:hi_bin])
     ; dep_ratio=dep_ratio-bkdp;
      plot,dep_ratio,ht,color=3,thick=2,background=-2,xrange=[0,1],yrange=[h1,h2],xtitle='ave-depol,ratio',ytitle='km'

      stop
      out_file5=out_path+fnm+'depolar_ratio_all.'+'bmp'
      write_bmp,out_file5,tvrd()

      Read, ztop, PROMPT='Enter top height km to store data: '
      zbin=ztop/0.0075
      depolar=(d_beta_a[*,0:zbin]/(d_beta_a[*,0:zbin]+m_beta_a[*,0:zbin]))/correction_factor

      outfile6=out_path+fnm+'_depol.txt'
      openw,1,outfile6
      printf,1,depolar
      close,1
      stop

      stop
     end







