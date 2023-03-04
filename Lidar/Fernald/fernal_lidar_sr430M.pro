Pro Fernal_lidar_SR430M
; In the first part we will read data and plot;
; In the second part, we will process signal according to Fernald
;Part I Rayleigh calcution
 ; read,bnum, prompt='Enter total number bins (eg.4096)  '
   ;constants  for the program
   bT=160     ;160 ns for SR430 bin width

   ns=1.0E-9   ;nanosecond
   c=3.0E8     ;speed of light
    bnum= 1000  ;24 km
   dz= bT*ns*(c/2)/1000  ;increment in height is dz=24 m
   ht=findgen(bnum)*dz  ; height in km
   dz1000=dz*1000 ;in meter
   z=ht*1000 ; in meter
   z[0]=1; remove 0
  ;treat Rayleigh scattering

    bn=fltarr(1000); bin array of 1250 for 1250*0.024=30km
  ;ITz1=fltarr(bnum)
  ;ITz2=fltarr(bnum)
  beta_r=fltarr(1000) ;Rayleigh backscattering coefficient
  kext=fltarr(1000)

  beta_r=dblarr(bnum+1) ;backscattering coefficient of air
   TAU=fltarr(bnum+1); Rayleigh optical thickness
   TM=fltarr(bnum+1)  ;  Rayleigh transmission
      densityX=fltarr(bnum+1);air density
      densityX= 1.E25*(2.4498-0.22114*ht+0.00701*ht^2-7.75225E-5*ht^3)  ;ht in km; in molec/m3
     beta_r=5.45E-32*(550./532.)^4*densityX;  (ht)  ;Rayleigh backscattering coefficient

     plot,beta_r,ht[0:999], background=-2,color=2,title='Rayleigh backscattering coefficient',ytitle='km',xtitle='beta -m'
     stop
  Sa=60; lidar ratio  ;for cirrus cloud
  Sr=8*!pi/3; lidar ratio for air
   tau[0]=0  ;;;;;
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


  Data_path="F:\lidar_data\";\Lidar_systems\LidarPro\DePolar\";  2003\jn022058\jn022058.4M""   ; AUR or SPR
  YEAR=''
  READ,YEAR,PROMPT='YEAR? AS 2004  '
   ;   year\month
  yr=strtrim(year,2);  remove white space

  ;Read,yr,  prompt='Enter  Year as 2009 '
   out_path='f:\lidar_data\testM\'; lidarPro\output\yrmn"

  event=0
  ;RB=fltarr(16,30)  ; output file type
  dnm=''
  ;file_hd=''

  Read, dnm, PROMPT='Enter filename dnm as ja162136;'   ; Enter date+code
  month=strmid(dnm,0,2)

  READ,n1, n2, PROMPT='Intial and final records;eg.10,100 129: '
  n1=fix(n1)
  n2=fix(n2)
  nx=n2-n1
  read,na,prompt=' number files to average,as 5: '
  n5=round(nx/na)

   sg=fltarr(n2-n1+1,bnum)
   sumsg=0
  X0=fltarr(n2-n1+1,bnum) ;average 5 PR2
  X=fltarr(n5,bnum); PR2
  V1=fltarr(nx,bnum)  ;  分子項 upper term in Fernald

  read,h1,h2,prompt='height region as 1, 6 km  '
   lo_bin=round(h1/dz)
   hi_bin=round(h2/dz)

  ; input data
   data_file=fltarr(n2-n1,bnum)
   cnt_sig=fltarr(bnum)
  For Jr=0,nx-1  do begin  ;1st For ; automatically read as many files
     jf=n1+jr ;file index starting from n1
      ;multp=n2-n1+1/Mav
    ni=strcompress(jf,/remove_all)

    fn=Data_path+yr+'\'+month+'\'+dnm+'.'+ni+'m'              ;+Dtype ;

   ; out_file=data_path+'\output\'+'_prf.'+'bmp'
     ;openr,1,fn; data_file;
     ;readf,1,cnt_sig
     cnt_sig=read_binary(fn, DATA_TYPE=2)  ; cnt_sig  ;read binary file
    ; plot,cnt_sig
     close,1
    ; cnt_sig=cnt_sig(0:bnum-1)
     bk=MIN(cnt_sig[bnum-200:bnum-1]);  treat background
     sg[Jr,*]=smooth(cnt_sig[0:999],10)-bk ;smooth signal
          ;maxsg=max(sg)
        ; sumsg=sumsg+sg


     X0[jr,*]=sg[jr,*]*(z^2);*Tm

     FOR IA=0,hi_bin do begin

        if (X0[jr,Ia] eq 0) then X0[jr,Ia]=X0[jr,Ia-1]
     endfor



     if (Jr eq 0) then begin
        plot,X0[jr,*],ht,color=2,background=-2,yrange=[h1,h2],title='SR430_PR2_m',xtitle= 'pr2_m',ytitle='km';file 1',color=2
     endif else begin
     oplot,X0[jr,*]+10*Jr,ht,color=2;
     ;xyouts,2000+Jr*100,15,'Files',color=2
     ;V1[jr,*]=X0[jr,*]*exp(-2*(Sa-Sr)*INTB)
   endelse
   endfor

;plot,V1[0:10,*],ht
 stop  ; section 1
;;;;;
;average 5 profiles
For J2=0,n5-1 do begin
FOR i=0 , nx-na+1,na do begin; average n5 profiles

For iy=0,999 do begin
X[J2,iy]=TOTAL(X0[i:i+na-1,iy],1)/nA
;print,J2,i,iy,x[j2,iy]
endfor;iy

endfor; i
endfor ;J2
;stop
;Part II Backscattering coefficient calculation  based on Fernald 1984
;5 files are averaged
 lo_bin=h1/dz
 hi_bin=h2/dz

 ;Izt= 840; bnum-            ;top beam at 20 km which is 840

 BTM=dblarr(n5,hi_bin+1);bnum)  ; 分母  denumerator of Fernald eq. (5) and (6)
 BTM1=dblarr(n5)  ; first term in BTM
 BTM2=dblarr(n5,hi_bin+1); bnum)  ;2nd term in BTM
 A=fltarr(hi_bin+1); bnum) ;A term in Fernald
 V2=fltarr(n5,hi_bin+1);bnum)
 beta_a=dblarr(n5,hi_bin+1);  bnum)  ;backscattering coefficient of aerosol
  bratio=dblarr(n5,hi_bin+1);  bnum)

 sumbtm2=fltarr(n5)
 ;Initial condition
    ;BTM1[*]=0; X[*,1250]/((beta_r[1250]+beta_a[*,1250]/1.E-6))
    BTM2[*,hi_bin]=0;   Sa*(X[*,0]+X[*,0])*EXP(A[0])*dz
    BTM[*,hi_bin]=0;    BTM1[*,0]+BTM2[*,0]

     beta_a(*,hi_bin)=0  ;10*beta_r(hi_bin-1)  ;initial condition at top  =beta_a
  ; stop
; evaluation of the second bottom term below

b2=hi_bin-1

  For nj=0,n5-1  do begin  ;from starting file n1 to last file n2
   sumBTM2[nj]=0

   BTM1[nj]=X[nj,b2]/(beta_r[b2]+beta_a[nj,b2])
    ;while (BTM1[nj] eq 0) do begin
      b2=b2-1
     ; BTM1[nj]=X[nj,b2]/(beta_r[b2]+beta_a[nj,b2])
    ;endwhile


   For k =hi_bin ,1,-1 do begin   ;calculation start from hi_bin
     A[k]=(Sa-Sr)*(beta_r[k]+beta_r[k-1])*dz1000
     V2[nj,k]=X[nj,k]*exp(+A[k])
     BTM2[nj,k]=Sa*(X[nj,k]+X[nj,k -1]*exp(A[k]+A[k-1]))*dz1000
     BTM[nj,k]=BTM1[nj]+BTM2[nj,k]
     beta_a[nj,k]=(V2[nj,k])/(BTM[nj,k])-(beta_r[k]);
   Endfor  ;k

   endfor   ;nj
   beta_a=1.e6*beta_a  ; convert to Mega_meter
    maxa=max(beta_a[1,*])
    plot,beta_a[0,0:hi_bin-1],ht,yrange=[h1,h2],xrange=[0,5*maxa],background=-2,color=1,$
    xtitle='beta_a M',  title='back scattering coeff03- au312138 1-76 AV2'
     beta0=max(beta_a[0,0:hi_bin])
      stop; section IIA

    For k=0,n5-1 do begin
         oplot,beta_a[k,0:hi_bin]+k*maxa/8,ht,color=2  ;ht[100:hi_bin-100]
         wait,1
    ENDFOR ;k
    stop
   beta_a=beta_a/1.e6
   ; wait,1
    stop
     BETAM=beta_a[*,0:hi_bin] ;
      out_filx=OUT_path+dnm+'beta_M.txt'
      openw,1,out_filx
      printf,1,betaM

      out_file1=OUT_path+dnm+'M_beta.bmp'
     write_bmp,out_file1,tvrd()
       stop ;secion IIB
       ;bratio=1+beta_a[1,100:hi_bin]/beta_r[100:hi_bin]
stop
    bratio[0,0:hi_bin]=1+smooth(beta_a[0,0:hi_bin]/1000000./beta_r[0:hi_bin],10)
     plot,bratio[0,0:hi_bin],ht,xrange=[0,50],yrange=[0,h2],background=-2,color=1,title=dnm,xtitle='bacattering ratio370',ytitle='km'
      br0=max(bratio[0,0:hi_bin])
      ;bbratio=bratio
      stop  ;IIC
      sumratio=0
       For L=1,n5-1 do begin;  n2-n1 do begin
       bratio[L,0:hi_bin]=1+smooth(beta_a[L,0:hi_bin]/beta_r[0:hi_bin],10)
       oplot,bratio[L,0:hi_bin]+L/5,ht,color=1  ;hi_bin-100
       ;
       sumratio=sumratio+bratio[L,0:hi_bin]
       endfor
     stop

     avratio=sumratio/(L+1)
     oplot,avratio,ht,color=4;,background=-2,linestyle=2,thick=5,xtitle='ave m backscatt ratio',ytitle='km'
     stop    ;Section III
      out_file2=out_path+dnm+'BK_M_ratio.'+'bmp'
     write_bmp,out_file2,tvrd()
     stop
     end



