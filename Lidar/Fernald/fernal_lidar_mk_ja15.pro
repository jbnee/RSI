Pro Fernal_lidar_mk_JA15
; In the first part we will read data and plot;
; In the second part, we will process signal according to Fernald
; Part I Rayleigh calcution
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

     plot,beta_r,ht,color=2, background=-2,title='Rayleigh backscattering coefficient',ytitle='km',xtitle='beta -m'
     stop
    Sa=60; lidar ratio  ;for cirrus cloud
    Sr=8*!pi/3.; lidar ratio for air

     kext=Sr*beta_r   ;Rayleigh extinction

;;;;;;;;;;;;;;;;;;;;;;Rayleigh calculation;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 for j=1,bnum-1 do begin
    tau[j]=kext[j]*dz1000+tau[j-1]
    Tm[j]=exp(-2*tau[j])
endfor
plot,tau,ht,position=plot_position1,title='tau',ytitle='km';charsize=2.0
xyouts,0.02,15,'tau optical thickness'
stop
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
;;;;;;;;;;;;;;;;;;;;;Parallel channel;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   dz=0.0075;  bT*ns*c/2  ;increment in height is dz=24 m



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
  n5=nx/5  ;average 5 profiles
    ;Data_path="D:\lidar_files\Depolar\";\Lidar_systems\LidarPro\DePolar\";  2003\jn022058\jn022058.4M""   ; AUR or SPR
   ; out_path='D:\lidar_files\depolar\output2\'; lidarPro\output\yrmn"
   Data_path="F:\lidar_DATA\";\Lidar_systems\LidarPro\DePolar\";  2003\jn022058\jn022058.4M""   ; AUR or SPR
   out_path='F:\lidar_DATA\output2\'; lidarPro\output\yrmn"
  year=2009;   year\month
  yr=strtrim(year,2);  remove white space

  ;Read,yr,  prompt='Enter  Year as 2009 '

   sg1=fltarr(n2-n1+1,bnum)
   ;sumsg1=0
  X0=fltarr(n2-n1+1,bnum) ;average 5 PR2
  X=fltarr(n5,bnum); PR2
  V1=fltarr(nx,bnum)  ;  分子項 upper term in Fernald
  beta_a=dblarr(n5,bnum)  ;backscattering coefficient of aerosol
  bratio=dblarr(n5,bnum)
  read,h1,h2,prompt='height region as 1, 6 km  '
  lo_bin=floor(h1/dz)
  hi_bin=floor(h2/dz)
  tbin=hi_bin-lo_bin
  ht0=ht[lo_bin:hi_bin]


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;; input data  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   data_file=fltarr(n2-n1,bnum)
   cnt_sig=fltarr(bnum)

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

     bk1=mean(cnt_sig[bnum-200:bnum-1]);  treat background
     sg1[Jr,*]=smooth(cnt_sig,10)-bk1 ;smooth signal


     X0[jr,*]=sg1[jr,*]*(z^2);

     if (Jr eq 0) then begin
     plot,X0[jr,*],ht0,color=2,background=-2,yrange=[0,h2],title='PR2_m',xtitle= 'pr2_m',ytitle='km';,$ position=plt_pos1

     endif else begin
    ; oplot,X0[jr,*]+10*Jr,ht,color=2;
     ;xyouts,2000+Jr*100,15,'Files',color=2
     ;V1[jr,*]=X0[jr,*]*exp(-2*(Sa-Sr)*INTB)
   endelse
   endfor

    ;plot,V1[0:10,*],ht
  stop  ; section 1  Pr2_m
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;average 5 profiles ;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 j2=0
FOR i=0 , nx-5, 5 do begin; average 5 profiles
For iy=0,1999 do begin
X[J2,iy]=MEAN(X0[i:i+4,iy])

endfor
j2=j2+1
endfor
;stop
;Part II Backscattering coefficient calculation  based on Fernald 1984
;5 files are averaged

 ;Izt= 840; bnum-            ;top beam at 20 km which is 840

 BTM=dblarr(n5,bnum)  ; 分母  denumerator of Fernald eq. (5) and (6)
 BTM1=dblarr(n5)  ; first term in BTM
 BTM2=dblarr(n5,bnum)  ;2nd term in BTM
 A=fltarr(bnum) ;A term in Fernald
 V2=fltarr(n5,bnum)
 sumbtm2=fltarr(n5)
       ;Initial condition
    ;BTM1[*]=0; X[*,1250]/((beta_r[1250]+beta_a[*,1250]/1.E-6))
     BTM2[*,bnum-1]=0; Sa*(X[*,0]+X[*,0])*EXP(A[0])*dz
     BTM[*,bnum-1]=0; BTM1[*,0]+BTM2[*,0]

     beta_a(*,hi_bin)=beta_r(hi_bin)  ;initial condition at top  =beta_a


  ; stop
; evaluation of the second bottom term below
  For nj=0,n5-1  do begin  ;from starting file n1 to last file n2
   ;sumBTM2[nj]=0
   b2=hi_bin
   BTM1[nj]=X[nj,b2]/(beta_r[b2]+beta_a[nj,b2])
    while (BTM1[nj] eq 0) do begin
      b2=b2-1
      BTM1[nj]=X[nj,b2]/(beta_r[b2]+beta_a[nj,b2])
    endwhile


   For k =hi_bin-1 ,1,-1 do begin   ;calculation start from hi_bin
     A[k]=(Sa-Sr)*(beta_r[k]+beta_r[k-1])*dz1000
     V2[nj,k]=X[nj,k]*exp(+A[k])
     BTM2[nj,k]=Sa*(X[nj,k]+X[nj,k -1]*exp(A[k]+A[k-1]))*dz1000
     BTM[nj,k]=BTM1[nj]+BTM2[nj,k]
     beta_a[nj,k]=(V2[nj,k])/(BTM[nj,k])-(beta_r[k]);
   Endfor  ;k

   endfor   ;nj
    maxa=max(beta_a[0,*])
    plot,beta_a[0,0:hi_bin],ht0,color=1,yrange=[h1,h2],xrange=[0,3*maxa],background=-2,xtitle='PLL,beta_a';$position=plt_pos1

     stop; section IIA

    avm_beta_a=total(beta_a,1)/n5 ;average beta_a for m channel
    oplot,avm_beta_a,ht0,color=2,thick=2
    xyouts,0.00002,4,'1st and average backscattering coefficient',color=2
    ;For k=0,n5-1,10 do begin ; plot every 10 profiles
        ; oplot,beta_a[k,0:hi_bin],ht,color=2  ;ht[100:hi_bin-100]

    ;ENDFOR ;k
     xyouts,0.00001,8,'1st and average backscattering coefficient',color=2

     out_file1=out_path+fnm+'beta_m.'+'bmp'
     write_bmp,out_file1,tvrd()
     ;;;;;;;;;;;;;;;;;;;;renormalize beta_a to remote negative values
     ;;;;;negative values are replace by beta_r
     stop  ;beta_a and ave_beta_a
     m_beta_a=beta_a[*,0:hi_bin]; redefine
     sz=size(m_beta_a)
      For IS1=0,sz[1]-1 do begin
        For IS2=0,sz[2]-1 do begin
        if (m_beta_a[IS1,IS2] LE 0) then begin
        m_beta_a[IS1,IS2]=beta_r[IS2]

        endif
       endfor ;IS2
       endfor  ;IS1

       OT1=out_path+fnm+'betaM.txt'
       openw,2,OT1
       printf,2,m_beta_a
       close,2


       stop ;secion IIB
       ;bratio=1+beta_a[1,100:hi_bin]/beta_r[100:hi_bin]

      bratio[0,0:hi_bin]=1+smooth(beta_a[0,0:hi_bin]/beta_r[0:hi_bin],10)
      plot,bratio[0,0:hi_bin],ht0,color=1,xrange=[0,10],yrange=[h1,h2],background=-2,$
      title=dnm,xtitle='PLL bacattering ratio',ytitle='km';$ osition=plt_pos1

      FOR Lm=1,n5-1 do begin
       bratio[Lm,0:hi_bin]=1+smooth(beta_a[Lm,0:hi_bin]/beta_r[0:hi_bin],10)
      ENDFOR; LM


      avratio_m=total(bratio,1)/n5 ;sumratio/(L+1)
      ;bratio_m=max(avratio)  ; peak backscattering ratio for m
      oplot,avratio_m[0:hi_bin],ht0,color=4,linestyle=2,thick=2

      xyouts,10,4,'1st and average backscattering ratio',color=2
      out_file2=out_path+fnm+'ratio_m.'+'bmp'
      write_bmp,out_file2,tvrd()
      stop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;|Perpendicular channel|;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    sg2=fltarr(n2-n1+1,bnum) ;signal for d channe;'
      For Jr=0,nx-1  do begin  ;1st For ; automatically read as many files
     jf=n1+jr ;file index starting from n1
      ;multp=n2-n1+1/Mav
    ni=strcompress(jf,/remove_all)

   ; fn=Data_path+yr+'\'+month+'\'+dnm+'.'+ni+'d'              ;+Dtype ;
     fn=Data_path+yr+'\'+month+'\'+dnm+'.'+ni+'d'              ;+Dtype ;

   ; out_file=data_path+'\output\'+'_prf.'+'bmp'
     openr,1,fn; data_file;
     readf,1,cnt_sig
     ;cnt_sig=read_binary(fn, DATA_TYPE=2)  ; cnt_sig  ;read binary file

     close,1
    ; cnt_sig=cnt_sig(0:bnum-1)
     bk2=mean(cnt_sig[bnum-200:bnum-1]);  treat background
     sg2[Jr,*]=smooth(cnt_sig,10)-bk2 ;smooth signal



     X0[jr,*]=sg2[jr,*]*(z^2);*Tm

     if (Jr eq 0) then begin
        plot,X0[jr,*],ht0,color=2,background=-2,xrange=[0,2e7],yrange=[h1,h2],$
        title='PR2_d',xtitle= 'pr2_d',ytitle='km';$  position=plt_pos2
     endif else begin

   endelse
   endfor  ;jr

   stop  ; section 1
                 ;;;;;
            ;average 5 profiles
         J3=0
        for i=0, nx-5, 5 do begin; average 5 profiles
        For iy=0,1999 do begin
         X[J3,iy]=MEAN(X0[i:i+4,iy])

        endfor  ;jy
          j3=j3+1
         endfor  ;i
;stop
;Part II Backscattering coefficient calculation  based on Fernald 1984
;5 files are averaged


 ;Izt= 840; bnum-            ;top beam at 20 km which is 840

 BTM=dblarr(n5,bnum)  ; 分母  denumerator of Fernald eq. (5) and (6)
 BTM1=dblarr(n5)  ; first term in BTM
 BTM2=dblarr(n5,bnum)  ;2nd term in BTM
 A=fltarr(bnum) ;A term in Fernald
 V2=fltarr(n5,bnum)
 ;sumbtm2=fltarr(n5)
 ;Initial condition
    ;BTM1[*]=0; X[*,1250]/((beta_r[1250]+beta_a[*,1250]/1.E-6))
    BTM2[*,bnum-1]=0; Sa*(X[*,0]+X[*,0])*EXP(A[0])*dz
    BTM[*,bnum-1]=0; BTM1[*,0]+BTM2[*,0]

     beta_a(*,hi_bin)=0;         10*beta_r(hi_bin-1)  ;initial condition at top  =beta_a


  ; stop
; evaluation of the second bottom term below
  For nj=0,n5-1  do begin  ;from starting file n1 to last file n2
   sumBTM2[nj]=0
   b2=hi_bin
   BTM1[nj]=X[nj,b2]/(beta_r[b2]+beta_a[nj,b2])
    while (BTM1[nj] eq 0) do begin
      b2=b2-1
      BTM1[nj]=X[nj,b2]/(beta_r[b2]+beta_a[nj,b2])
    endwhile


   For k =hi_bin-1 ,1,-1 do begin   ;calculation start from hi_bin
     A[k]=(Sa-Sr)*(beta_r[k]+beta_r[k-1])*dz1000
     V2[nj,k]=X[nj,k]*exp(+A[k])
     BTM2[nj,k]=Sa*(X[nj,k]+X[nj,k -1]*exp(A[k]+A[k-1]))*dz1000
     BTM[nj,k]=BTM1[nj]+BTM2[nj,k]
     beta_a[nj,k]=(V2[nj,k])/(BTM[nj,k])-(beta_r[k]);
   Endfor  ;k

   endfor   ;nj

    maxb=max(beta_a[0,*])
    plot,beta_a[0,0:hi_bin],ht0,color=1,yrange=[h1,h2],xrange=[0,maxb],background=-2,xtitle='PPrD d_beta_a';,$position=plt_pos2

    stop; section IIA
    avd_beta_a=total(beta_a,1)/n5
    oplot,avd_beta_a,ht0,color=2,thick=2
    xyouts,0.000012,4,color=2,'1st and average d channel beta_a'


    stop
      out_file3=out_path+fnm+'beta_d.'+'bmp'
     write_bmp,out_file3,tvrd()
    d_beta_a=beta_a[*,0:hi_bin] ;redefine for d channel

     For IS1=0,sz[1]-1 do begin
        For IS2=0,sz[2]-1 do begin
         if (d_beta_a[IS1,IS2] LE 0) then begin
         d_beta_a[IS1,IS2]=beta_r[IS2]

        endif
       endfor; IS2

       endfor   ;IS1
       OT2=out_path+fnm+'betaD.txt'
       openw,2,OT2
       printf,2,d_beta_a
       close,2

       ;bratio=1+beta_a[1,100:hi_bin]/beta_r[100:hi_bin]

       bratio[0,0:hi_bin-1]=1+smooth(beta_a[0,0:hi_bin-1]/beta_r[0:hi_bin-1],10)
       plot,bratio[0,0:hi_bin],ht0,color=1,background=-2,xrange=[0,5],yrange=[h1,h2],title=dnm,xtitle='PPrD bacattering ratio 0',ytitle='km'; ,$
       ;position=plt_pos2

       FOR Ld=1,n5-1 do begin
       bratio[Ld,0:hi_bin]=1+smooth(beta_a[Ld,0:hi_bin]/beta_r[0:hi_bin],10)
       ENDFOR ;Ld

       avratio_d=total(bratio,1)/n5 ;sumratio/(L+1)



       oplot,avratio_d[0:hi_bin],ht0,color=4,linestyle=2,thick=2
      xyouts,1,4,'1st and average d backscattering ratio ',color=2


     stop    ;Section III
      !P.multi=[0,2,1]
       plt_pos1 =[0.1,0.15,0.45,0.95]
       plt_pos2 = [0.55,0.15,0.90,0.95]
      plot,avm_beta_a,ht0,color=1,yrange=[h1,h2],xrange=[0,5*maxb],background=-2,xtitle='PLL beta_a',$
       position=plt_pos1,xticks=2
      stop
      plot,avd_beta_a,ht0,color=1,yrange=[h1,h2],xrange=[0,5*maxb],background=-2,xtitle='PPrD d_beta_a',$
       position=plt_pos2,xticks=2
      stop
      out_file5=out_path+fnm+'AV_BETA'+'.bmp'
      write_bmp,out_file5,tvrd(/true)
      !P.multi=[0,1,1]
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
      xyouts,10,h2-3,p_depr,color=2
       out_file4=out_path+fnm+'ratio_d2.'+'bmp'
     write_bmp,out_file4,tvrd()
     stop
      ;define xdprx as depolarization ratio
     ; xdpr0=(1/correction_factor)*d_beta_a[0,0:hi_bin]/(d_beta_a[0,0:hi_bin]+m_beta_a[0,0:hi_bin])
     ; plot,xdpr0,ht,color=2,thick=2,background=-2,xrange=[1,1],yrange=[0,h2],xtitle='depol,ratio',ytitle='km'
      bins=hi_bin-lo_bin

      av_d=(total(d_beta_a,1)/n5)/correction_factor  ;average d_beta_a
      av_m=total(m_beta_a,1)/n5  ; ave m_beta_a
      dep_ratio=smooth((d_beta_a/(d_beta_a+m_beta_a)),20)
      ;dep_ratio=av_d[0:bins]/(av_d[0:bins]+av_m[0:bins])
      Avdep=total(dep_ratio,1)/n5
      bkdp=mean(Avdep[tbin-50:tbin])/n5
      dep_ratio=dep_ratio-bkdp;
      plot,Avdep,ht0,color=3,thick=2,background=-2,xrange=[0,2],yrange=[1,4],xtitle='ave-depol,ratio',ytitle='km'

      FOR JP=0,sz[1]-1,5 do begin
      oplot,dep_ratio[JP,*]+0.05*JP,ht0,color=2
      endfor ;JP
      stop
      out_file5=out_path+fnm+'depolar_ratio_all.'+'bmp'
      write_bmp,out_file5,tvrd()

      Read, ztop, PROMPT='Enter top height km to store data: '
      zbin=ztop/0.0075


      outfile6=out_path+fnm+'_depol.txt'
      openw,1,outfile6
      printf,1,dep_ratio
      close,1
      stop

      stop
     end







