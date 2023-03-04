Pro contour_ASc_test
close,/all
fnm=''
 Read,fnm,prompt='enter filename as 0102ASC: '
 PATH1='D:\LIDAR_DATA\2020\'+FNM;
 LN1=''
 dfile=path1+'\a*';
 fxc=file_search(dfile)
; READ,N0,prompt='Starting file number, as 1:'
; READ,Nz, PROMPT='INPUT NUMBER OF FILES AS 9 '
 ;NFLS=STRARR(Nz)
 ;Fik=strarr(2,20)
; fls=strarr(Nz)  ; data name
; YNM=INTARR(nz)  ; number of data
 nx=n_elements(fxc)
 print,nx
 stop
 ;OPENR,1,path1
  ;LN1=''
dz=3.75
bnum=8000;
HT=FINDGEN(BNUM)*DZ/1000.
h1=500.0
bn1=fix(h1/dz);
h2=5000.0
bn2=fix(h2/dz);
;;$ PART 2 READ DATA ******************************
   datab=fltarr(2,bnum)


     AS=FLTARR(NX,BNUM)
     PS=FLTARR(NX,BNUM)
     hd=''
     FOR j0=0,nx-1 do begin
      OPENR,1,fxc[j0,*]
         FOR h=0,5 do begin ;;;read licel first 5 head lines
         readf,1,hd
        ;print,hd
         endfor   ;h
       ;;;;;;;;;;;;;;;;;;;; reading data below
      READF,1, DATAB
      AS[J0,*]=datab[1,*];*(ht*1000)^2; PR2
      PS[J0,*]=datab[0,*];*(ht*1000)^2

      close,1
     ENDFOR; J0


 ;
   ;stop   ;check error
   ;;;;;;;;;;;;;;;;;;;separate two channel data;;;;;;;;;;;;;;;;;;;
    m=fix(NX/2)
    nbin=bn2-bn1+1
    PS1=fltarr(m,Nbin) ; parallel
    PS2=fltarr(m,Nbin) ;perpendicular

    AS1=fltarr(m,Nbin) ; parallel
    AS2=fltarr(m,Nbin) ;perpendicular
    J=0;          count file
    for k=0,NX-2,2 do begin
     Ps1[J,*]=Ps[k,bn1:bn2]
     bk1=min(PS1[J,nbin-200:nbin-1])
     PS1[j,*]=PS1[j,*]-bk1
     ;PR2m[j,*]=PS1[j,*]*(ht*1000)^2;

     PS2[J,*]=Ps[k+1,bn1:bn2]
     bk2=min(PS2[j,Nbin-200:Nbin-1])
     PS2[j,*]=PS2[j,*]-bk2
;;*********************************************
     As1[J,*]=As[k,bn1:bn2]
     bk1=min(AS1[J,nbin-200:nbin-1])
     AS1[j,*]=AS1[j,*]-bk1
     ;PR2m[j,*]=PS1[j,*]*(ht*1000)^2;

     AS2[J,*]=As[k+1,bn1:bn2]
     bk2=min(AS2[j,Nbin-200:Nbin-1])
     AS2[j,*]=AS2[j,*]-bk2



     J=J+1
    endfor; k

PS12=Ps1+Ps2;  combined files
AS12=AS1+AS2

 xx=indgen(m)
 yy=ht(bn1:bn2)
 STOP
 contour_make,PS12,xx,yy,FNM
 stop
 window,1
 contour_make,AS12,xx,yy,FNM
 stop
 end