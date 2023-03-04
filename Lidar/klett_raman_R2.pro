Pro Klett_Raman_R2
; In the first part we will read data and plot;
; In the second part, we will process signal according to Fernald
;Part I Rayleigh calcution
 ; read,bnum, prompt='Enter total number bins (eg.4096)  '
   ;constants  for the program
   ;bpath='d:\lidar_files\RamanData\Raman0809\MCA_N2\2008\'
  ;opath="d:\lidar_files\Ramandata\Raman0809\output\"
   yr='';   year\month
   year=2008
   yr=strtrim(year,2)

    bpath='f:\lidar_data\2008_09_Raman\MCA_H2O\'+yr+'\'
    opath="F:\lidar_data\2008_09_Raman\output\"

   bT=40     ;160 ns for SR430 bin width

   ns=1.0E-9   ;nanosecond
   c=3.0E8     ;speed of light
    bnum= 2000  ;30 km
    bx=4000
   dz=bT*ns*c/2  ;increment in height is dz=24 m
    z=dz*findgen(bnum+1);   Height in m
   ht=z/1000.  ; height in km
  ;treat Rayleigh scattering
  ; h1=ht[100]; lower height
  ; h2=ht[850] ;upper height
  bn=fltarr(bnum+1); bin array of 1250 for 1250*0.024=30km

  beta_r=fltarr(bnum+1) ;Rayleigh backscattering coefficient
  kext=fltarr(bnum+1)
  density=fltarr(bnum+1);air density
  beta_r=dblarr(bnum+1) ;backscattering coefficient of air
   TAU=fltarr(bnum+1); Rayleigh optical thickness
   TM=fltarr(bnum+1)  ;  Rayleigh transmission

     density= 1.E25*(2.4498-0.22114*ht+0.00701*ht^2-7.75225E-5*ht^3)  ;ht in km; in molec/m3
     beta_r=5.45E-32*(550./532.)^4*density  ;Rayleigh backscattering coefficient

     plot,beta_r,ht, background=-2,color=2
     stop
  ;Sa=32; lidar ratio  ;for cirrus cloud
    Sr=8*!pi/3; lidar ratio for air

   kext=Sr*beta_r   ;Rayleigh extinction
 for j=1,bnum do begin
    tau[j]=kext[j]*24+tau[j-1]
    Tm[j]=exp(-2*tau[j])
 endfor; j
plot,tau,ht,position=plot_position1,title='tau',ytitle='km';charsize=2.0
xyouts,0.02,15,'tau optical thickness'
plot,tm,ht,position=plot_position2,xrange=[0.75,1],ytitle='km',xtitle='opt,thickness';
xyouts,0.85,15,'transmission atmosphere'
stop
INTB=fltarr(bnum+1); integral of beta_r from top down
INTB[bnum]=0
FOR I1=bnum-1,1,-1 do begin

 INTB[I1]=INTB[bnum]+(beta_r[I1]+beta_r[I1-1])*(dz/2)
ENDFOR;I1


plot,INTB,ht,xtitle='integrated beta_r top down', ytitle='km'

stop
;Part 2 Read data
  close,/all
   ;bpath="F:\Lidar data\Rayleigh\";  2003\jn022058\jn022058.4M""   ; AUR or SPR
    ;bpath='f:\lidar_data\2008_09_Raman\MCA_N2\2009\'

 ; Data_path="D:\Lidar systems\Depolar\"
  yr='';   year\month
   year=2009
    yr=strtrim(year,2)
  ;Read,yrmn, prompt='Enter director Year, month as 2003\JN:  '
   ;dirnm=data_path+yrmn
   ;opath="F:\lidar data\output\"
   SA=Sr   ;for Raman
  event=0
  ;RB=fltarr(16,30)  ; output file type
  filecode=''
  ;file_hd=''
  dnm=''
  Read, dnm, PROMPT='Enter filename dnm as ja162136;'   ; Enter date+code
  month=strmid(dnm,0,2)
  fnm=strmid(dnm,0,4); Enter date+code

  READ,n1, n2, PROMPT='Intial and final records;eg.10,100 129: '
  n1=fix(n1)
  n2=fix(n2)
  nx=n2-n1

  READ,y1,y2,PROMPT='height region from y1(1km) to y2(20 km):  '
  izt=round(y2/0.006);2000
   sg=fltarr(nx+1,bnum+1)
   sumsg=0
  X=fltarr(nx+1,bnum+1) ;PR2
  V1=fltarr(nx+1,bnum+1)
  EX_A=fltarr(nx+1,bnum+1) ;  ??? upper term in Fernald
  B1=fltarr(nx+1,bnum+1)
  B=fltarr(nx+1)  ;background data
  beta_a=dblarr(nx+1,izt)  ;backscattering coefficient of aerosol
  ;bratio=dblarr(nx+1,bnum+1)
    ; izt is the top height

  For Jr=0,nx  do begin  ;1st For ; automatically read as many files
     jf=n1+jr ;file index starting from n1
      ;multp=n2-n1+1/Mav
    ni=strcompress(jf,/remove_all)

     fn=bpath+month+'\'+ dnm+'.'+ni+'m'
    ;out_file=data_path+'output'+ni+'.'+'bmp'
     ;openr,1,data_file;

     cnt_sig=read_binary(fn, DATA_TYPE=2)  ; cnt_sig  ;read binary file
     close,1
    ; stop
     cnt_sig=smooth(cnt_sig,20)
     B[jr]=min(cnt_sig[bx-100:bx]);  treat background
     ;B[jr]=bk  ; collect all background
     csig=cnt_sig[0:bnum]  ;take signal betwen h1 and h2
     sg[Jr,*]=smooth(csig,10);-bk ;smooth signal
       EX_A[Jr,*]=sg[Jr,*]-B[jr]

     ; for k=1,bnum do begin
       ; EX_A[Jr,k]=sg[Jr,k]-B[jr]
       ; if (EX_A[Jr,k] LE 0) then EX_A[Jr,k]=EX_A[Jr,k-1]
        ;endif
       ; endfor  ;k



     ;qu=where(EX_A[Jr,*] LT 0)  ; check for positive
     ;EX_A[Jr,qu]=EX+A[Jr,qu-1]; set it to previous value
     endfor ;jr

     ;if (Jr eq 0) then begin
    ;BG=min(B)  ;lowest bg is the background
      X[0,*]=Alog(EX_A[0,*]*(z^2))
     plot,X[0,*],ht,color=2,background=-2,yrange=[y1,y2],xrange=[10,50];'file 1',color=2

    for js=0,nx do begin

      ;X[js,*]=Alog((sg[js,*]-BG)*(z^2));
       X[js,*]=Alog(EX_A[js,*]*(z^2));
    ; endif else begin
     oplot,X[js,*]+1*js,ht,color=2;
     ;xyouts,2000+js*100,15,'Files',color=2
     ;endelse
     wait,1
      B1[js,izt]=beta_r[izt];5.0e-7;
     For k =izt-1 ,1,-1 do begin   ;calculation start from Izt
       V1[js,k+1]=exp(X[js,k]-X[js,izt]); Numerator Klett top
       B1[js,k]=B1[js,k-1]+(1/SA)*(V1[js,k]+V1[js,k+1])*(dz/2);B1 is the integral of V1 from zm to z

     ENDFOR;k
    endfor  ;js
    stop

    plot,B1[0,*],ht,yrange=[y1,y2],xrange=[0,.2]
    stop
    for jb=0,nx-1 do begin
      oplot,B1[jb,*],ht
    endfor
    stop

 ;stop  ; section 1
;Part II Backscattering coefficient calculation  based on Klett1981
  ;Izt= round(y2/(dz/1000.));           ;top beam at 20 km which is 840

 ;Initial condition

   ; beta_a(*,IZT)=0  ;5*beta_r(Izt-1)  ;initial condition at 30 km =beta_a
    B10=0.0001*beta_r(Izt)


; evaluation of the second bottom term below
  For nj=0,nx  do begin  ;from starting file n1 to last file n2
     For k =izt-1 ,1,-1 do begin   ;calculation start from Izt
      beta_a[nj,k]=V1[nj,k]/(x[nj,izt]/B10+B1[nj,k]);
     Endfor  ;k
  ENDFOR   ;nj
    maxa=max(beta_a[0,*])
    ;plot,beta_a[0,100:izt-1],ht+100/24.0,yrange=[10,20], background=-2,color=1,xtitle='beta_a'
     plot,beta_a[0,0:izt-1],ht,background=-2,color=1,xtitle='beta_a'
      stop; section IIA
      Av_beta=total(beta_a,1);/10
      plot,AV_beta,ht,color=2,background=-2,thick=2,yrange=[y1,y2]
      stop
    For k=0,nx-1,5 do begin
         ;oplot,beta_a[k,100:izt-1],ht+100/24.0,color=2  ;ht[100:izt-100]
          oplot,beta_a[k,0:izt-1],ht,color=2
    ENDFOR ;k
    stop ;secion IIB
     cross_Sec=3*2.5e-30/SA
    R2=dblarr(bnum)
    R2=av_beta/cross_sec
    ;N2=smooth(N2,50)
    plot,R2,ht,color=2,background=-2,yrange=[y1,y2]

    qq=where(finite(R2))  ;remove NaN
    stop
   ; q0=size(qq)
   ;for Iq=1,q0[1]-1 do begin
     ;N2(qq(Iq))=N2(qq(Iq)-1)
    ;endfor
    R2x=R2(qq)*1e6  ;N2x is the data remove NaN,change to m3 unit
    oplot,R2x/1e6,ht,color=2,thick=2


    stop
    plot,R2x/density,ht,color=2,background=-2,yrange=[y1,y2],xtitle='ratio=N2X/density',ytitle='km',title='Klett_Raman'
     file2=opath+yr+dnm+'_H2O.bmp'
    write_bmp,file2,tvrd()

     fnm=strmid(dnm,0,4)
     OT2=opath+fnm+'H2O_beta.txt'
       openw,2,OT2
       printf,2,R2x
       close,2
       STOP


    end