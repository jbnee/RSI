Pro Licel_AS_Channel
close,/all

; In the first part Rayleigh scattering is calculate for the air molecules
 ;In the 2nd part, we will read data and plot;
; In the third part, we will process signal according to Fernald and backscatterign coefficient is obtained
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Part I Rayleigh calcution
 ; read,bnum, prompt='Enter total number bins (eg.4096)  '
   ;bnum= 6000  ;4km km
   ;constants  for the program
   bT=25     ;160 ns for SR430 bin width

   ns=1.0E-9   ;nanosecond
   c=3.0E8     ;speed of light

   dz= bT*ns*(c/2)/1000  ;increment in height is dz=24 m

   dz1000=dz*1000 ;in meter

  ;treat Rayleigh scattering


  ;ITz1=fltarr(bnum)
  ;ITz2=fltarr(bnum)

;Part 2 Read data
  close,/all

  fnm='';  file name
  year=''
  read,year,prompt='Input year of data as 2019:'
  read,fnm,PROMPT='NAME OF THE FILE AS 0415ASC: '
  read,h1,h2,prompt='Initial and final height in km as ,1,5: '
  b1=h1/dz;
  b2=h2/dz
  bnum=b2-b1;
  ht=findgen(bnum)*dz  ; height in km
   z=ht*1000 ; in meter
  da=strmid(fnm,0,4)

  ;RB=fltarr(16,30)  ; output file type
   ;dnm='0806'

   bpath='E:\LiDAR_DATA\'+year+'\ASC\'+fnm;
    ;bpath=path+FNMD;  bpath='G:\0425B\'
   fx=bpath+'\a*'  ;file path
   fls=file_search(fx)
   Sf=size(fls)
    PRINT,'NUM OF TOTAL FILES IN THIS DIRECTORY: ',SF
  ; STOP

  ; SEARCH files of the day, starting with 0



  ;fnm=strmid(dnm,0,4)

  ;Read, dnm, PROMPT='Enter filename dnm as ja162136;'   ; Enter date+code
 ; month=strmid(dnm,0,2)

  READ,n1, n2, PROMPT='Intial and final records;eg.10,100 : '
  read,m0,prompt='Number of files to average (eg 5) :'
  n1=fix(n1)
  n2=fix(n2)
  NF=n2-n1+1
  ;m0=1; average files to average; default is 5
  n5=NF/m0; number of  averaged data files
  F1=strtrim(fix(n1),2)
  F2=strtrim(fix(n2),2)
  FS=fnm+'                         file:'+F1+'_'+F2;used to print title
  ;Ftitle=fnm
  ;stop
  ;define arrays
  b0=8000
  DATAB=FLTARR(2,b0)
  AS0=fltarr(NF,bnum) ;original As  Analog signal
  AS=fltarr(NF,bnum); treated AS signal
  AS1=fltarr(NF/2,bnum) ;PS1=fltarr(m/2,Nbin) ; parallel
  AS2=fltarr(NF/2,bnum) ; perpendicular

  sg=fltarr(NF/2,bnum)
  cnt_sig=fltarr(bnum)

  ;read,h1,h2,prompt='height region as 1, 6 km  '
  ; input data



 ;;;;;;;;;;;;;;;;;;;; reading data below

  hd=''
  nc=0  ;file count

  FOR I=0,n2-n1-1 DO BEGIN ; open file to read
        Ix=I+n1
       OPENR,1,fls[Ix]

        FOR h=0,5 do begin ;;;read licel first 5 head lines
          readf,1,hd
          ;print,hd
        endfor   ;h

       READF,1, DATAB


      AS[nc,*]=DATAB[0,0:bnum-1];  Take analog data
      ;PS[j,*]=DATAB[1,]; photon counting data
      close,1

      nc=nc+1

  ENDFOR; I

      close,1
  ;b2=6000
   AS1=fltarr(NF/2,bnum) ;PS1=fltarr(m/2,Nbin) ; parallel
   AS2=fltarr(NF/2,bnum) ; perpendicular
   BK1=fltarr(NF/2)
   BK2=fltarr(NF/2)
   AP1=fltarr(NF/(2*m0),bnum)
   AP2=fltarr(NF/(2*m0),bnum)
    J=0;          count file Separate parall and perpendicular channels
    for k=0,NF-2,2 do begin; alternative PLL/PPD
     AS1[J,*]=AS[k,*]
     AS2[J,*]=AS[k+1,*]
     BK1[J]=mean(AS1[J,bnum-200:bnum-1])
     BK2[J]=mean(AS2[J,bnum-200:bnum-1])


     J=J+1
    endfor; k
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;Depolarization ratio;<1000 bins;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
J2=0
 FOR i=0 , NF/2-1, m0 do begin; average 5 profiles

     For jy=0,b2-1 do begin ;sum 5

       AP1[J2,jy]=MEAN(AS1[i:i+m0-1,jy])-BK1[J2]
       AP2[J2,jy]=MEAN(AS2[i:i+m0-1,jy])-BK2[J2]
      ;AS3[j2,jy]=(AS12[i,jy]+AS12[i+1,jy]+AS12[i+2,jy]+AS12[i+3,jy]+AS12[i+4,jy])/5

     ENDFOR  ;jy
     J2=J2+1
 ENDFOR; I
stop
 ;   DP=fltarr(NF/(2*m0),bnum)

 ;   DP=AP2/AP1 ;
    ;DP=smooth(DP,20);

 ;  plot,Dp[0,*],ht,color=2,background=-2,xrange=[0,1]
    ;
 ;  FOR i=30 , NF/(2*m0) -1, 2 do begin; average 5 profiles
  ;  oplot,dp[i,*],ht,color=20*i

 ;  ENDFOR; i

;stop

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;;;;;;;;;;;;;CONTOUR plot;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


     ;out_path=bPath+'\Aerosol_plots\'; lidarPro\output\yrmn"
     ;out_file=bpath+da+'_depolar.png'

    ; write_png,out_file,tvrd(/true)

  stop

   end





