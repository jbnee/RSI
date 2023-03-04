Pro Depolar_lidar_2020
close,/all

; In the first part Rayleigh scattering is calculate for the air molecules
 ;In the 2nd part, we will read data and plot;
; In the third part, we will process signal according to Fernald and backscatterign coefficient is obtained
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Part I Rayleigh calcution
 ; read,bnum, prompt='Enter total number bins (eg.4096)  '
   bnum= 6000  ;4km km
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

;Part 2 Read data
  close,/all

  fnm='';  file name
  year=''
  read,year,prompt='Input year of data as 2019:'
  read,fnm,PROMPT='NAME OF THE FILE AS 0415ASC: '
  read,h1,h2,prompt='Initial and final height in km as ,1,5: '
  b1=h1/dz;
  b2=h2/dz
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
  m2=long(NF/(2*m0))  ;=1; average files to average; default is 5
  n5=NF/m0; number of  averaged data files
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


      AS[nc,*]=DATAB[0,*];  Take analog data
      ;PS[j,*]=DATAB[1,*]; photon counting data
      close,1

      nc=nc+1

  ENDFOR; I

      close,1
  b2=6000
   AS1=fltarr(NF/2,bnum) ;PS1=fltarr(m/2,Nbin) ; parallel
   AS2=fltarr(NF/2,bnum) ; perpendicular
   BK1=fltarr(NF/2)
   BK2=fltarr(NF/2)
   AP1=fltarr(NF/(2*m0),b2)
   AP2=fltarr(NF/(2*m0),b2)
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

    DP=fltarr(m2,bnum)


    ;DP=smooth(DP,20);
stop

   ;plot,Dp[0,*],ht,color=2,background=-2,xrange=[0,1]
    ;
   S1=total(AP1[40:49,*],1)/10.
   ;S1=S1[0:999]
   S2=total(AP2[40:49,*],1)/10.
   ;S2=S2[0:999]



    R1= LEEFILT(S1 , 20 , 5)
    R2= LEEFILT(S2 , 20 , 5)




    plot,R2[0:999],ht,color=2,background=-2,xtitle='signal',ytitle='Height (km)',charsize=1.3,title='0805,400-500, av5'

    oplot,R1[0:999],ht,color=90

    p1=where(R1 eq max(R1[1:200]))
    p2=where(R2 eq max(R2[0:200]))
    DP1=R1(p1)/R2(p2)
    print,'pk depolar ratio: ',dp1
   stop
    m2=long(NF/(2*m0))
    FOR i=0 , m2-10, 10 do begin; average 5 profiles
     S1=total(AP1[i:i+9,*],1)/10.
     S2=total(AP2[i:i+9,*],1)/10.

    oplot,s2+i*20,ht,color=2
    oplot,s1+i*20,ht,color=20*i

   ENDFOR; i

stop



 opath='E:\RSI\lidar\output\'
 out_file=opath+da+'_S1_S2.png'
 ;write_png,out_file,tvrd(/true)

 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;;;;;;;;;;;;;CONTOUR plot;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 window,1
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

S=size(DP)
xx=findgen(S[1])

  col = 240 ; don't change it
  cmin=0;*min(BR[NF/3,b1:b2]);10 is arbitrary set the 5th file
  cmax=max(DP[10,*]) ;max(Rbeta[10,*]))/10;

  nlevs_max = 20 ; choose what you think is right
  cint =(cmax-cmin)/nlevs_max;  round((cmax-cmin)/nlevs_max)
  CLEVS = CMIN + FINDGEN(NLEVS_MAX+1)*cint
 ;CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
  clevs0 = clevs ; for plot the color bar

  NLEVS = N_ELEMENTS(CLEVS)+1 ;actual number of countour levels

    ;print,i0,' cmin,cmax',cmin,cmax,cint,nlevs

    col = 240 ; don't change it
    ;C_INDEX=(FINDGEN(NLEVS)+1)*col/(NLEVS)
    c_index=cint*(indgen(Nlevs));
    c_index(NLEVS-1) = 1 ; missing data = white

   contour,AP1+AP2,xx,Ht(0:b2-1),xtitle='time',ytitle='km',LEVELS = CLEVS, /FILL,yrange=[h1,h2],position=p0,$
    C_COLORS = C_INDEX, charsize=1.4, title=da+'Depolarization ratio'
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
       ycharsize=0.7, charsize=1,/noerase,title='cc'

stop

             ;CONTOUR, zb, xb, yb,position=BAR_0, xrange=[0,1],/xstyle,xtickv=findgen(2),yrange=[cmin,cmax], LEVELS =CLEVS0,C_COLOR = C_INDEX,/fill
     ; xticks=1,xtickname=xname,yrange =[cmin,cmax],/YSTYLE, $
     ; LEVELS = CLEVS0,C_COLOR = C_INDEX, ycharsize=0.7, charsize=1,/noerase,title='cc'


     ;out_path=data_Path+'\Aerosol_plots\'; lidarPro\output\yrmn"
     out_file=bpath+da+'_depolar.png'

     ;write_png,out_file,tvrd(/true)

  stop

   end





