Pro Fernal_lidar_mk_depolar
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

     plot,beta_r,ht, background=-2,color=2,title='Rayleigh backscattering coefficient',ytitle='km',xtitle='beta -m'
     stop
  Sa=60; lidar ratio  ;for cirrus cloud
  Sr=8*!pi/3; lidar ratio for air

   kext=(8*3.1416/3.)*beta_r   ;Rayleigh extinction
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
   dz=0.0075;  bT*ns*c/2  ;increment in height

  Data_path="F:\lidar_data\";\Lidar_systems\LidarPro\DePolar\";  2003\jn022058\jn022058.4M""   ; AUR or SPR

  year=2009;   year\month
  yr=strtrim(year,2);  remove white space

  ;Read,yr,  prompt='Enter  Year as 2009 '
   out_path='F:\lidar_data\output\'; lidarPro\output\yrmn"

  event=0
  ;RB=fltarr(16,30)  ; output file type
  dnm=''
  ;file_hd=''

  Read, dnm, PROMPT='Enter filename dnm as ja162136;'   ; Enter date+code
  month=strmid(dnm,0,2)

  READ,n1, n2, PROMPT='Intial and final records;eg.10,100 129: '
  n1=fix(n1)
  n2=fix(n2)
  nx=n2-n1+1
  n5=nx/5

   sg=fltarr(n2-n1+1,bnum)
   sumsg=0
  X0=fltarr(n2-n1+1,bnum) ;average 5 PR2
  X=fltarr(n5,bnum); PR2
  V1=fltarr(nx,bnum)  ;  分子項 upper term in Fernald
  beta_a=dblarr(n5,bnum)  ;backscattering coefficient of aerosol
  bratio=dblarr(n5,bnum)
  read,h1,h2,prompt='height region as 1, 6 km  '
   dz=0.075
   lo_bin=h1/dz
   hi_bin=h2/dz
  ; input data
   data_file=fltarr(n2-n1,bnum)
   cnt_sig1=fltarr(bnum)
  For Jr=0,nx-1  do begin  ;1st For ; automatically read as many files
     jf=n1+jr ;file index starting from n1
      ;multp=n2-n1+1/Mav
    ni=strcompress(jf,/remove_all)

    fn=Data_path+yr+'\'+month+'\'+dnm+'.'+ni+'m'              ;+Dtype ;

   ; out_file=data_path+'\output\'+'_prf.'+'bmp'
     openr,1,fn; data_file;
     readf,1,cnt_sig1
     ;cnt_sig=read_binary(fn, DATA_TYPE=2)  ; cnt_sig  ;read binary file
    ; plot,cnt_sig
     close,1

     bk1=mean(cnt_sig1[bnum-200:bnum-1]);  treat background
     sg1[Jr,*]=smooth(cnt_sig1,10)-bk ;smooth signal
          ;maxsg=max(sg)
        ; sumsg=sumsg+sg


     X0m[jr,*]=sg1[jr,*]*(z^2);*Tm

     if (Jr eq 0) then begin
        plot,X0m[jr,*],ht,color=2,background=-2,yrange=[h1,h2],title='PR2_m',xtitle= 'pr2_m',ytitle='km';file 1',color=2
     endif else begin

     endelse
     endfor


 stop  ; section 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;average 5 profiles
 j2=0
FOR i=0 , nx-5, 5 do begin; average 5 profiles
For iy=0,999 do begin
 Xm[J2,iy]=MEAN(X0m[i:i+4,iy])

endfor
j2=j2+1
endfor
;stop
;Part II Backscattering coefficient calculation  based on Fernald 1984
;5 files are averaged

 ;Izt= 840; bnum-            ;top beam at 20 km which is 840

   BTM1=dblarr(n5,bnum)  ; 分母  denumerator of Fernald eq. (5) and (6)
   BTM1_1=dblarr(n5)  ; first term in BTM
   BTM1_2=dblarr(n5,bnum)  ;2nd term in BTM
    A1=fltarr(bnum) ;A term in Fernald
    V_m=fltarr(n5,bnum)
 sumbtm2=fltarr(n5)
 ;Initial condition
    ;BTM1[*]=0; X[*,1250]/((beta_r[1250]+beta_a[*,1250]/1.E-6))
    BTM2[*,bnum-1]=0; Sa*(X[*,0]+X[*,0])*EXP(A[0])*dz
    BTM[*,bnum-1]=0; BTM1[*,0]+BTM2[*,0]

     beta_a(*,hi_bin)=0;10*beta_r(hi_bin-1)  ;initial condition at top  =beta_a


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
     V_m[nj,k]=X[nj,k]*exp(+A[k])
     BTM2[nj,k]=Sa*(X[nj,k]+X[nj,k -1]*exp(A[k]+A[k-1]))*dz1000
     BTM[nj,k]=BTM1[nj]+BTM2[nj,k]
     beta_a[nj,k]=(V_m[nj,k])/(BTM[nj,k])-(beta_r[k]);
   Endfor  ;k

   endfor   ;nj
    maxa=max(beta_a[0,*])
    plot,beta_a[0,0:hi_bin],ht,yrange=[h1,h2],xrange=[0,2*maxa],background=-2,color=1,xtitle='beta_a'

      stop; section IIA

    For k=0,n5-1 do begin
         oplot,beta_a[k,0:hi_bin],ht,color=2  ;ht[100:hi_bin-100]

    ENDFOR ;k
      out_file1=data_path+dnm+'beta_m.'+'bmp'
     write_bmp,out_file1,tvrd()
       stop ;secion IIB
       ;bratio=1+beta_a[1,100:hi_bin]/beta_r[100:hi_bin]

    bratio[0,0:hi_bin]=1+smooth(beta_a[0,0:hi_bin]/beta_r[0:hi_bin],10)
     plot,bratio[0,0:hi_bin],ht,xrange=[0,10],yrange=[h1,h2],background=-2,color=1,title=dnm,xtitle='bacattering ratio 0',ytitle='km'

      ;bbratio=bratio
      stop  ;IIC
      sumratio=0
       For L=1,n5-1 do begin;  n2-n1 do begin
       bratio[L,0:hi_bin]=1+smooth(beta_a[L,0:hi_bin]/beta_r[0:hi_bin],10)
       oplot,bratio[L,0:hi_bin],ht,color=1  ;hi_bin-100
       ;stop
       sumratio=sumratio+bratio[L,0:hi_bin]
       endfor
     stop

     avratio=sumratio/(L+1)
     plot,avratio,ht,color=4,background=-2,linestyle=2,thick=5,xtitle='ave m backscatt ratio',ytitle='km'
     stop    ;Section III
      out_file2=out_path+dnm+'ratio_m.'+'bmp'
     write_bmp,out_file2,tvrd()
     stop
     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;|-------------------------------------|;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;|;;;;;;;perpendicular channel;;;;;;;;;|;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;|;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;|;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;|-------------------------------------|;;;;;;;;;;;;;;;;;;;;;;

      For Jr=0,nx-1  do begin  ;1st For ; automatically read as many files
     jf=n1+jr ;file index starting from n1
      ;multp=n2-n1+1/Mav
    ni=strcompress(jf,/remove_all)

    fn=Data_path+yr+'\'+month+'\'+dnm+'.'+ni+'d'              ;+Dtype ;

   ; out_file=data_path+'\output\'+'_prf.'+'bmp'
     openr,1,fn; data_file;
     readf,1,cnt_sig
     ;cnt_sig=read_binary(fn, DATA_TYPE=2)  ; cnt_sig  ;read binary file
    ; plot,cnt_sig
     close,1
    ; cnt_sig=cnt_sig(0:bnum-1)
     bk=mean(cnt_sig[bnum-200:bnum-1]);  treat background
     sg[Jr,*]=smooth(cnt_sig,10)-bk ;smooth signal
          ;maxsg=max(sg)
        ; sumsg=sumsg+sg


     X0[jr,*]=sg[jr,*]*(z^2);*Tm

     if (Jr eq 0) then begin
        plot,X0[jr,*],ht,color=2,background=-2,yrange=[h1,h2],title='PR2_d',xtitle= 'pr2_d',ytitle='km';file 1',color=2
     endif else begin
    ; oplot,X0[jr,*]+10*Jr,ht,color=2;
     ;xyouts,2000+Jr*100,15,'Files',color=2
     ;V1[jr,*]=X0[jr,*]*exp(-2*(Sa-Sr)*INTB)
   endelse
   endfor

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
;stop
;Part II Backscattering coefficient calculation  based on Fernald 1984
;5 files are averaged
 lo_bin=h1/dz
 hi_bin=h2/dz
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

     beta_a(*,hi_bin)=0;10*beta_r(hi_bin-1)  ;initial condition at top  =beta_a


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
     V_d[nj,k]=X[nj,k]*exp(+A[k])
     BTM2[nj,k]=Sa*(X[nj,k]+X[nj,k -1]*exp(A[k]+A[k-1]))*dz1000
     BTM[nj,k]=BTM1[nj]+BTM2[nj,k]
     beta_a[nj,k]=(V2[nj,k])/(BTM[nj,k])-(beta_r[k]);
   Endfor  ;k

   endfor   ;nj
    maxa=max(beta_a[0,*])
    plot,beta_a[0,0:hi_bin],ht,yrange=[h1,h2],xrange=[0,2*maxa],background=-2,color=1,xtitle='beta_a'

      stop; section IIA

    For k=0,n5-1 do begin
         oplot,beta_a[k,0:hi_bin],ht,color=2  ;ht[100:hi_bin-100]

    ENDFOR ;k
      out_file1=data_path+dnm+'beta_d.'+'bmp'
     write_bmp,out_file1,tvrd()
       stop ;secion IIB
       ;bratio=1+beta_a[1,100:hi_bin]/beta_r[100:hi_bin]

    bratio[0,0:hi_bin]=1+smooth(beta_a[0,0:hi_bin]/beta_r[0:hi_bin],10)
     plot,bratio[0,0:hi_bin],ht,xrange=[0,100],yrange=[h1,h2],background=-2,color=1,title=dnm,xtitle='bacattering ratio 0',ytitle='km'

      ;bbratio=bratio
      stop  ;IIC
      sumratio=0
       For L=1,n5-1 do begin;  n2-n1 do begin
       bratio[L,0:hi_bin]=1+smooth(beta_a[L,0:hi_bin]/beta_r[0:hi_bin],10)
       oplot,bratio[L,0:hi_bin],ht,color=1  ;hi_bin-100
       ;stop
       sumratio=sumratio+bratio[L,0:hi_bin]
       endfor
     stop

     avratio=sumratio/(L+1)
     plot,avratio,ht,color=4,background=-2,linestyle=2,thick=5,xtitle='ave d backscatt ratio',ytitle='km'
     stop    ;Section III
      out_file2=out_path+dnm+'ratio_d.'+'bmp'
     write_bmp,out_file2,tvrd()
     stop
     end






