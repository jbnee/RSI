Pro Fernal_lidar_ASC
close,/all

; In the first part Rayleigh scattering is calculate for the air molecules
 ;In the 2nd part, we will read data and plot;
; In the third part, we will process signal according to Fernald and backscatterign coefficient is obtained
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Part I Rayleigh calcution
 ; read,bnum, prompt='Enter total number bins (eg.4096)  '
   bnum= 4000  ;30 km
   ;constants  for the program
   bT=25     ;160 ns for SR430 bin width

   ns=1.0E-9   ;nanosecond
   c=3.0E8     ;speed of light

   dz= bT*ns*(c/2)/1000  ;increment in height is dz=24 m
   ht=findgen(bnum)*dz  ; height in km
   dz1000=dz*1000 ;in meter
   z=ht*1000 ; in meter
  ;treat Rayleigh scattering


  ;ITz1=fltarr(bnum)
  ;ITz2=fltarr(bnum)
  beta_r=fltarr(bnum+1) ;Rayleigh backscattering coefficient
  kext=fltarr(bnum+1)

  beta_r=dblarr(bnum+1) ;backscattering coefficient of air
   TAU=fltarr(bnum+1); Rayleigh optical thickness
   TM=fltarr(bnum+1)  ;  Rayleigh transmission
      density=fltarr(bnum+1);air density
      density= 1.E25*(2.4498-0.22114*ht+0.00701*ht^2-7.75225E-5*ht^3)  ;ht in km; in molec/m3
     beta_r=5.45E-32*(550./532.)^4*density  ;Rayleigh backscattering coefficient

     plot,beta_r,ht, background=-2,color=2,title='Rayleigh backscattering coefficient',ytitle='km',xtitle='beta -m'
     stop
  Sa=45; lidar ratio  ;for cirrus cloud
  Sr=8*!pi/3; lidar ratio for air

   kext=Sr*beta_r   ;Rayleigh extinction
  tau[bnum-1]=0
 for j=bnum-2,0,-1 do begin
    tau[j]=tau[j+1]+(kext[j]+kext[j+1])*dz1000/2
    Tm[j]=exp(-2*tau[j])
 endfor
plot,tau,ht,xtitle='opt,thick and transmission',xrange=[0,1]
xyouts,0.1,15, 'optical thickness'
oplot,Tm,ht; ,position=plot_position2,xrange=[0.75,1],ytitle='km',xtitle='opt,thickness';
xyouts,0.5,10,'atmospheric transmission'

  year='2020'  ;   year\month
  yr=strtrim(year,2);  remove white space

stop
;Part 2 Read data
  close,/all
  da=''
  ;Read, da, PROMPT='Enter date dnm as 0415;'
  ;da='0806 PM '
  da='0805 '
  month=strmid(da,1,2)
 ; da='0415ASC'
 dnm=da
  datax=dnm+'ASC'
  ;RB=fltarr(16,30)  ; output file type
  ; dnm='0806'

   bpath='E:\LiDAR_DATA\'+year+'\ASC\'+datax;
    ;bpath=path+FNMD;  bpath='G:\0425B\'
   fx=bpath+'\a*'  ;file path
   fls=file_search(fx)
   Sf=size(fls)
    PRINT,'NUM OF TOTAL FILES IN THIS DIRECTORY: ',SF
  ; STOP

  ; SEARCH files of the day, starting with 0
  JF=0


  ;fnm=strmid(dnm,0,4)

  ;Read, dnm, PROMPT='Enter filename dnm as ja162136;'   ; Enter date+code
 ; month=strmid(dnm,0,2)

  READ,n1, n2, PROMPT='Intial and final records;eg.10,100 129: '
;n1=150
;n2=750
  n1=fix(n1)
  n2=fix(n2)
  m=n2-n1+1
  m0=5; average files to average; default is 5
  n5=m/m0; number of  averaged data files
  F1=strtrim(fix(n1),2)
  F2=strtrim(fix(n2),2)
  FS='                         file:'+F1+'_'+F2;used to print title
  Ftitle=yr+dnm
  ;stop
  ;define arrays
  DATAB=FLTARR(2,bnum)
  AS0=fltarr(m,bnum) ;original As  Analog signal
  AS=fltarr(m,bnum); treated AS signal
  AS1=fltarr(m/2,bnum) ;PS1=fltarr(m/2,Nbin) ; parallel
  AS2=fltarr(m/2,bnum) ; perpendicular

  sg=fltarr(m/2,bnum)
  cnt_sig=fltarr(bnum)
  PR2M=fltarr(m/2,bnum) ;average 5 PR2
  X=fltarr(m/2,bnum); PR2
  h1=0
  h2=4
  ;read,h1,h2,prompt='height region as 1, 6 km  '
  ; input data

  b1=round(h1/dz)
  b2=round(h2/dz)

 ;;;;;;;;;;;;;;;;;;;; reading data below

  hd=''
  nc=0  ;file count
  read,a_p,prompt='analog (0) or photon (1) channel?'

  FOR I=0,n2-n1-1 DO BEGIN ; open file to read
        Ix=I+n1
       OPENR,1,fls[Ix]

        FOR h=0,5 do begin ;;;read licel first 5 head lines
          readf,1,hd
          ;print,hd
        endfor   ;h

       READF,1, DATAB


      AS[nc,*]=DATAB[a_p,*];  Take analog data
       ; PS[j,*]=DATAB[1,*]; photon counting data
      close,1

      nc=nc+1

  ENDFOR; I

      close,1

   AS1=fltarr(m/2,bnum) ;PS1=fltarr(m/2,Nbin) ; parallel
   AS2=fltarr(m/2,bnum) ; perpendicular

    J=0;          count file Separate parall and perpendicular channels
    for k=0,m-2,2 do begin
     AS1[J,*]=AS[k,*]
     AS2[J,*]=AS[k+1,*]


     J=J+1
    endfor; k

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;INVERSION PROCESSES;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


 stop; 3
     AS3=AS1;+AS2;
      ;AS3=AS2 for perpendicular channel
     JR=0

     FOR JR=0,m/2-1 do begin


      bk=min(AS3[Jr,bnum-200:bnum-1]);  treat background
      ;sg[Jr,*]=smooth(AS1[,10)-bk ;smooth signal
      AS3[jr,*]=AS3[jr,*]-bk;
      PR2M[jr,*]=AS3[jr,*]*(z^2)

        if (Jr eq 0) then begin
        plot,PR2M[jr,*],ht,color=2,background=-2,yrange=[h1,h2],title='PR2_m',xtitle= 'pr2_m',ytitle='km';file 1',color=2
        endif
       endfor;   jr


    stop  ; section 1

;;;;;AVERAGE 5 here

    j2=0
   FOR i=0 , m/2-m0, m0 do begin; average 5 profiles
     For iy=0,bnum-1 do begin
       X[J2,iy]=MEAN(PR2M[i:i+m0-1,iy])

     ENDFOR  ;i
   j2=j2+1

   ENDFOR; iy
  xm0=max(X[10,0:b2])
 plot,X[0,0:b2],ht,color=2,xrange=[0,10*xm0],background=-2,title='mean X=PR2',ytitle='km',xtitle='X'
 For i2=1,m/2-m0,10 do begin ;
         oplot,X[i2,0:b2],ht,color=2*i2  ;ht[100:b2-100]
      ;wait,1
    ENDFOR ;Nk

 stop
;Part II Backscattering coefficient calculation  based on Fernald 1984
;5 files are averaged



 ;define arrays for inversion
 m5=m/2/m0
 BTM=dblarr(m5,bnum)  ; ¤À¥À  denumerator of Fernald eq. (5) and (6)
 BTM1=dblarr(m5)  ; first term in BTM
 BTM2=dblarr(m5,bnum)  ;2nd term in BTM
 A=fltarr(bnum) ;A term in Fernald
 V1=fltarr(m5,bnum)

 beta_a=dblarr(m5,bnum)  ;backscattering coefficient of aerosol
  bratio=dblarr(m5,bnum)
 ;Initial condition

; evaluation of the second bottom term below
  For nj=0,m5-1  do begin  ;from starting file n1 to last file n2
   ;
   beta_a(nj,b2)=beta_r[b2];
   BTM1[nj]=X[nj,b2]/(beta_r[b2]+beta_a[nj,b2])
    ;while (BTM1[nj] eq 0) and (b2 GT 1) do begin
     ;
      ;BTM1[nj]=X[nj,b2]/(beta_r[b2]+beta_a[nj,b2])
    ; endwhile

    ; A[b2]=0
     ;BTM2[nj,b2]=0
   For k =b2-1 ,1,-1 do begin   ;calculation start from b2
     A[k]=(Sa-Sr)*(beta_r[k]+beta_r[k-1])*dz1000
     V1[nj,k]=X[nj,k]*exp(A[k])

     BTM2[nj,k]=Sa*(X[nj,k]+X[nj,k -1]*exp(A[k]))*dz1000

     BTM[nj,k]=BTM1[nj]+BTM2[nj,k]
     beta_a[nj,k]=(V1[nj,k])/(BTM[nj,k])-(beta_r[k]);
   Endfor  ;k

   endfor   ;nj
    maxa=max(beta_a[10,*])
    mina=min(beta_a[0,*])  ;
    beta_a=beta_a-mina     ;correction for negative beta
    plot,beta_a[20,0:b2],ht,color=2,background=-2,yrange=[h1,h2],xrange=[0,1e-3],$
     xtitle='beta_a',ytitle='km',TITLE=FTITLE+FS
    oplot,beta_r,ht,color=150
      stop; section IIA

    For Nk=10,m5-1,5 do begin ;
         oplot,beta_a[Nk,0:b2]+Nk*maxa/5,ht,color=2  ;ht[100:b2-100]
      ;wait,1
    ENDFOR ;Nk
    stop
    DATA_path='E:\Lidar_data\2020\OUTPUTS\'
     ;out_path=data_Path+'\Aerosol_plots\'; lidarPro\output\yrmn"
     out_file=DATA_path+dnm+'_Dbeta.png'

    ; write_png,out_file,tvrd()
  stop
  B=beta_a[*,0:999]; store 60x1000 data
    outdata1=data_path+dnm+'1_beta.txt'
      hd=''
      hd1=size(B)

      openw,2,outdata1
      hdA='size'+string(hd1[1])+string(hd1[2])

      format1='(E16.4)'
      printf,2,hdA
     ; printf,2,hdB
      printf,2,B,format=format1
      close,2
      stop

;;; calculate AOD
  AOD=fltarr(m5)

   ;F3=long(N3)
   ;F4=long(N4)
  ;FS='                         file:'+F3+'_'+F4;used to print title


  AOD=total(B,2)*dz1000*3*8/3.14



  plot,AOD,color=2,background=-2,title='AOD'
    stop
      ;out_path='f:\rsi\lidar\Fernald\test\'; lidarPro\output\yrmn"
      out_file1=data_path+da+'AOD.png'
      write_png,out_file1,tvrd()

      out2=data_path+da+'AOD.txt'
      openw,2,out2
      printf,2,AOD,format=format1
      close,2


       ;stop ;secion IIB
      ;bratio=1+beta_a[1,100:b2]/beta_r[100:b2]


      ;bratio[0,0:b2]=1+beta_a[19,0:b2]/((8*!pi/3)*beta_r[0:b2])
      ; plot,bratio[20,0:b2],ht,xrange=[0,100],yrange=[h1,h2],background=-2,color=1,title=FTITLE+FS,xtitle='bacattering ratio 0',ytitle='km'

      ;bbratio=bratio
     ; stop  ;IIC
      ;sumratio=0

      ; For L=1,m5-1,5 do begin;  n2-n1 do begin
      ;    bratio[L,0:b2]=1+beta_a[L,0:b2]/((8*!pi/3)*beta_r[0:b2])

        ;  oplot,bratio[L,0:b2],ht,color=1  ;b2-100

      ; endfor
     stop

     abratio=total(bratio,1,/nan)/m5
   ;

   end





