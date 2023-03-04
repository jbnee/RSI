Pro Fernal_lidar_2020
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
  Sa=30; lidar ratio  ;for cirrus cloud
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

 ; year='2020'  ;   year\month
  ;yr=strtrim(year,2);  remove white space
 ; month='08'
stop
;Part 2 Read data
  close,/all

  fnm='';  file name
  year=''
  read,year,prompt='Input year of data as 2019:'
  read,fnm,PROMPT='NAME OF THE FILE AS 0415ASC: '
  read,h1,h2,prompt='Initial and final height as ,1,5: '

  da=strmid(fnm,0,4)

  ;RB=fltarr(16,30)  ; output file type
   ;dnm='0806'

   path0='D:\LiDAR_DATA\'+year+'\';
   bpath=path0+fnm;
    ;bpath=path+FNMD;  bpath='G:\0425B\'
   fx=bpath+'\a*'  ;file path
   fls=file_search(fx)
   Sf=size(fls)
    PRINT,'NUM OF TOTAL FILES IN THIS DIRECTORY: ',SF
   STOP

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
  n5=long(NF/m0); number of  averaged data files
  F1=strtrim(fix(n1),2)
  F2=strtrim(fix(n2),2)
  FS=fnm+'                         file:'+F1+'_'+F2;used to print title
  ;Ftitle=fnm
  ;stop
  ;define arrays
  DATAB=FLTARR(2,bnum)
  AS0=fltarr(NF,bnum) ;original As  Analog signal
  AS=fltarr(NF,bnum); treated AS signal
  AS1=fltarr(NF/2,bnum) ;PS1=fltarr(m/2,Nbin) ; parallel
  AS2=fltarr(NF/2,bnum) ; perpendicular
  AS12=fltarr(NF/2,bnum);
  sg=fltarr(NF/2,bnum)
  cnt_sig=fltarr(bnum)
  PR2M=fltarr(NF/2,bnum) ;average 5 PR2
  X=fltarr(NF/2,bnum); PR2

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
          print,hd
        endfor   ;h

       READF,1, DATAB


       AS[nc,*]=DATAB[0,*];  Take analog data
       ;PS[j,*]=DATAB[1,*]; photon counting data
      close,1

      nc=nc+1

  ENDFOR; I

      close,1


   AS3=fltarr(NF/(2*m0),bnum)
    J=0;          count file Separate parall and perpendicular channels
    for k=0,NF-2,2 do begin; alternative PLL/PPD
     AS1[J,*]=AS[k,*]
     AS2[J,*]=AS[k+1,*]


     J=J+1
    endfor; k
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;INVERSION PROCESSES;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; average process

     AS12=AS1+AS2;
    j2=0

    ;
   FOR i=0 , NF/2-1, m0 do begin; average 5 profiles

     For jy=0,bnum-1 do begin ;sum 5

      ; AS3[J2,jy]=MEAN(AS3[i:i+m0-1,jy])
      AS3[j2,jy]=(AS12[i,jy]+AS12[i+1,jy]+AS12[i+2,jy]+AS12[i+3,jy]+AS12[i+4,jy])/5

     ENDFOR  ;jy
   j2=j2+1

    print,i,J2
   ENDFOR; i

!p.multi=[0,1,1]
stop;check AS3;

      bk=fltarr(NF/(2*m0));

      FOR J1=0,NF/(2*m0)-1 do begin
      ;bk=min(AS3[Jr,*]);  treat background
       bk(J1)=min(AS3[J1,bnum-200:bnum-1]);
      ;endfor; J1

      ;FOR J2=0,nf/(2*M0)-1 DO BEGIN  ;fit bk
      ; Y=poly_fit(n,bk,2);
      ; B=poly(n,Y);
       ;AS3[J2,*]=(AS3[j2,*]-B[j2]); *(z^2)
       pr2M[J1,*]=(AS3[j1,*]-bk[j1])*(z^2)
        if (J1 eq 0) then begin
        plot,PR2M[J1,*],ht,color=2,background=-2,yrange=[h1,h2],title='PR2_m',xtitle= 'pr2_m',ytitle='km';file 1',color=2
        endif
        oplot,PR2M[J1,*],ht,color=40
       endfor;   j2


    stop
   X=smooth(Pr2m,20);


 ;
;Part II Backscattering coefficient calculation  bASed on Fernald 1984
;5 files are averaged

 b1=round(h1/dz)
 b2=round(h2/dz)

 ;define arrays for inversion
 m5=long(NF/2.0/m0)
 BTM=dblarr(m5,bnum)  ; ¤À¥À  denumerator of Fernald eq. (5) and (6)
 BTM1=dblarr(m5)  ; first term in BTM
 BTM2=dblarr(m5,bnum)  ;2nd term in BTM
 A=fltarr(bnum) ;A term in Fernald
 V1=fltarr(m5,bnum)

 beta_a=FLTARR(m5,bnum)  ;backscattering coefficient of aerosol

 ;Initial condition
;BTM1(n0)=(mean(Pr2(n0,b2-20:b2)))/(Br(b2)+B(b2));    %X1 the 1st term in the denominator

; evaluation of the second bottom term below
  For nj=0,m5-1  do begin  ;from starting file n1 to lASt file n2
   ;
   ;beta_a(nj,b2)=beta_r[b2];
   BTM1[nj]=(total(X[nj,b2-20:b2-1]/20))/(beta_r[b2]+beta_a[nj,b2])
    ;while (BTM1[nj] eq 0) and (b2 GT 1) do begin
     ;
      ;BTM1[nj]=X[nj,b2]/(beta_r[b2]+beta_a[nj,b2])
    ; endwhile

    ; A[b2]=0
     ;BTM2[nj,b2]=0
   For k =b2-1,1,-1 do begin   ;calculation start from b2
     A[k]=(Sa-Sr)*(beta_r[k]+beta_r[k-1])*dz1000
     V1[nj,k]=X[nj,k]*exp(A[k])

     BTM2[nj,k]=Sa*(X[nj,k]+X[nj,k -1]*exp(A[k]))*dz1000

     BTM[nj,k]=BTM1[nj]+BTM2[nj,k]
     beta_a[nj,k]=(V1[nj,k])/(BTM[nj,k])-(beta_r[k]);
   Endfor  ;k

   ENDFOR   ;nj
   stop
   plot,smooth(beta_a[1,*],20),ht[b1:b2],color=2,background=-2,xtitle='beta',title='beta, find max ht for beta '
   for i2=0,nf/(2*m0)-1,2 do begin
    oplot,smooth(beta_a[i2,*],30),ht,color=i2*10
   endfor
  stop

 DATA_path='D:\Lidar_data\2020\OUTPUTS\'
 outdata1=data_path+da+'beta_1.txt'
      hd=''
      hd1=size(beta_a)

      openw,2,outdata1

      hdA='total file  ,  '+ strmid(NF,3)
      ;hdB=[NF/2,b2]
      printf,2,hdA
     ; printf,2,hdB
      FORMAT1='(E16)';
      ;format4='( 40(E18))'
      printf,2,beta_a[*,0:b2];format=FORMAT1
      close,2
      stop


   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;;;;;;;;;;;;;CONTOUR BETA;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 ;Rbeta=beta_a[*,0:b2];/beta_r[0:b2]
 ;H=ht[ 0:b2]

;Read,R1, prompt=('max level from PR2 plot for cmax:')

;plot, beta_a[*,R1],color=2,background=-2,title='max beta values'
;maxR=max(Rbeta[*,R1]);
;stop
  rgb = bytarr(3,256)
openr,2,'E:\RSI\hues.dat'
readf,2,rgb
close,2
free_lun,2
device, decomposed=0
 !p.background=255
 loadct,39

r=bytarr(256)
g = r
b = r
r(0:255) = rgb(0,0:255)
g(0:255) = rgb(1,0:255)
b(0:255) = rgb(2,0:255)
tvlct,r,g,b
!P.BACKGROUND= 1 ; 0 = black, 1 = white
!P.COLOR=2 ;blue labels
p0=[0.1,0.15,0.90,0.90]
; plot_position1 = [0.1,0.15,0.93,0.49]; plot_position=[0.1,0.15,0.95,0.45]
; plot_position2 = [0.1,0.6,0.93,0.95]; plot_position2=[0.1,0.6,0.95,0.95]
 ; BAR_POSITION1=[0.97,0.2,0.98,0.45]
 ; BAR_POSITION2=[0.97,0.5,0.98,0.95]
BAR_0=[0.93,0.2,0.95,0.9]
!p.multi=[0,1,1]

pA =[0.1,0.15,0.90,0.45]

pB =[0.1,0.6,0.90,0.90]

  S=size(beta_a)
  xx=indgen(S[1])
  m2=long(m5/2);
  col = 240 ; don't change it
  ;cmin=0;*min(BR[NF/3,b1:b2]);10 is arbitrary set the 5th file
  cmax=1.5*max(beta_a[m2,*]);/10;
  cmin=cmax/20.0
  nlevs_max = 20 ; choose what you think is right
  cint =(cmax-cmin)/nlevs_max;  round((cmax-cmin)/nlevs_max)
  CLEVS = CMIN + FINDGEN(NLEVS_MAX+1)*cint
 ;CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
  clevs0 = clevs ; for plot the color bar

  NLEVS = N_ELEMENTS(CLEVS)+1 ;actual number of countour levels

    ;print,i0,' cmin,cmax',cmin,cmax,cint,nlevs

    col = 240 ; don't change it
    C_INDEX=(FINDGEN(NLEVS)+1)*col/(NLEVS)
    c_index(NLEVS-1) = 1 ; missing data = white

   contour,beta_a,xx,Ht,xtitle='time',ytitle='km',LEVELS = CLEVS, /FILL,yrange=[h1,h2],position=p0,$
    C_COLORS = C_INDEX, charsize=1.4, title=da+'-beta (1.e-5) 1/cm-sr'
  ; contour,zz2,xx,yy,xtitle='time',ytitle='km',xrange=[0,XA],yrange=[0,YA],LEVELS = CLEVS, /FILL,$
  ;  C_COLORS = C_INDEX, color=2,/FOLLOW,charsize=1.4, position=pA,title=da+'Channel 1'  ;xyouts,500,5,'fn',color=1,charsize=2
  ;nlevs=nleves_max

    zb=fltarr(2,nlevs);

     for k=0,nlevs-1 do zb(0:1,k)=cmin+cint*k

     xb = [0,1]
     yb = cmin + findgen(nlevs)*(cint+1)
     xname = [' ',' ',' ']
     CONTOUR, zb, xb, yb,position=BAR_0, xrange=[0,1],/xstyle,xtickv=findgen(2),$
      LEVELS =CLEVS0,C_COLOR = C_INDEX,/fill,$
      xticks=1,xtickname=xname,yrange =[cmin,cmax],/YSTYLE, $
       ycharsize=0.7, charsize=1,/noerASe,title='cc'

stop


     ;out_path=data_Path+'\Aerosol_plots\'; lidarPro\output\yrmn"

   print,'select correct range of beta here:'
 Tbeta=total(beta_a[m5/2:m5-1,*],1)/m5
 plot,Tbeta,ht,yrange=[h1,h2],color=2,background=-2,title='total beta',ytitle='km',xtitle='beta'
stop
     end





