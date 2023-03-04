Pro AUTO_ASC_contourplot
; AUTO contour plots for ASC files

;;**************;PART 1: search for data  ***************

CLOSE,/ALL
ERASE
bnum=8000; total bin number  6000x3.75=22.5 km
T=findgen(bnum)   ; define time
fq=40.0e6 ;  20 or 40 MHz
BT=1/fq ; bin width
v=3.0E8; speed of light
dz=v*BT/2  ;this derive height resolution  3.75m
ht=dz*T/1000.+0.0001   ;convert ht to km and remove 0 as base

 year=''

  read,year, prompt='year as 2003: ?  '
  yr=string(year,format='(I4.4)')
 PATH0='D:\LIDAR_DATA\'+YEAR+'\';

 FILES=''

 read,FILES,prompt='name of the list file: as FILES2004July.txt'
 FILNAME=FILES+'.TXT'
 PATH1='D:\LIDAR_DATA\DATA_LIST\'+FILNAME;
 LN1=''

 Read, N_all, prompt='Total number files here: '
 READ,N0,prompt='1st file to read, as 1,21:'
 READ,Nz, PROMPT='INPUT NUMBER OF FILES to plot AS 9 '
 ;NFLS=STRARR(Nz)
 ;Fik=strarr(2,20)
 fls=strarr(N_all)  ; data name
 YNM=INTARR(N_all)  ; number of data
  close,/all
   LN1=''
 OPENR,1,path1

 ;stop
 FOR ns=N0,N0+nz-1 do begin

     READF,1,LN1
      PRINT,LN1
      FLS[ns]=strmid(LN1,0,11);  +'ASC'  ;filename
      YNM[ns]=strmid(LN1,20,3) ;file number

 endfor ;Ns
   ;print,FLS,Ynm
 close,1
 STOP
 dz1000=dz/1000.0
h1=10.0; km
bn1=fix(h1*1000/dz);
h2=20.0  ; km
bn2=fix(h2*1000/dz);
;;$ PART 2 READ DATA ******************************
   datab=fltarr(2,bnum)
;read,n0,prompt='starting file as 9'
   HD='';
   FOR i1=N0,N0+Nz-1 DO BEGIN ; open file to read
      ;fx='D:\LIDAR_DATA\2022\'+FLS[i]+'\a*'
      F1=PATH0+FLS[i1]+'\a*'
     ; F2=strcompress(F1, /REMOVE_ALL)
      ;fNM=PATH0+FLS[NS]
       Px=file_search(F1)  ; FINDING how many data are there
       nx=n_elements(px);


     AS=FLTARR(NX,BNUM)
     PS=FLTARR(NX,BNUM)

     FOR j0=0,nx-1 do begin
      OPENR,1,Px[j0]
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

;STOP
 ;
   ;stop   ;check error
   ;;;;;;;;;;;;;;;;;;;separate two channel data;;;;;;;;;;;;;;;;;;;
    m=fix(NX/2)
    nbin=bn2-bn1+1
    PS1=fltarr(m,Nbin) ; parallel
    AS1=FLTARR(M,Nbin)
    PS2=fltarr(m,Nbin) ;perpendicular
    AS2=fltarr(m,Nbin)
    J=0;          count file
    for k=0,NX-2,2 do begin
     Ps1[J,*]=Ps[k,bn1:bn2]
     bk1=min(PS1[J,nbin-200:nbin-1])
     PS1[j,*]=PS1[j,*]-bk1
     ;PR2m[j,*]=PS1[j,*]*(ht*1000)^2;

     PS2[J,*]=Ps[k+1,bn1:bn2]
     bk2=min(PS2[j,Nbin-200:Nbin-1])
     PS2[j,*]=PS2[j,*]-bk2
     ;*******************************************88
     As1[J,*]=As[k,bn1:bn2]
     bk1=min(AS1[J,nbin-200:nbin-1])
     AS1[j,*]=AS1[j,*]-bk1
     ;PR2m[j,*]=PS1[j,*]*(ht*1000)^2;

     AS2[J,*]=As[k+1,bn1:bn2]
     bk2=min(AS2[j,Nbin-200:Nbin-1])
     AS2[j,*]=AS2[j,*]-bk2

     J=J+1
    endfor; k
;stop

;;;;************ contour plot *********************************
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
rgb = bytarr(3,256)
openr,2,'E:\RSI\hues.dat'
readf,2,rgb
close,2
free_lun,2
device, decomposed=0
 !p.background=255
 loadct,39
  window,1
r=bytarr(256)
g = r
b = r
r(0:255) = rgb(0,0:255)
g(0:255) = rgb(1,0:255)
b(0:255) = rgb(2,0:255)
tvlct,r,g,b
!P.BACKGROUND= 1 ; 0 = black, 1 = white
!P.COLOR=2 ;blue labels

  na=0
  x=indgen(m)
  y=dz*indgen(Nbin)/1000+h1
  ;
  CPPM1=PS1;[na:m2-1,*]  ;chan 1 PARALLEL
  CPPM2=PS2;[na:m2-1,*]  ;chan 2 PERPENDI

 ; CPPD=A[0:m-1,*] ; analog


  col = 240 ; don't change it
  cmin=0;min(AZ);10 is arbitrary set the 5th file
  cmax1=0.1*max(CPPM1[m/4,*]);for high altitude  ;cmax=1*max(CPPM[m/2,100:1000]); for low altitude
  cmax2=1*max(CPPM2[m/4,*]);
  ctest=[cmax1,cmax2]
  cmax=max(ctest)  ; select the largest one

  nlevs_max =20 ; choose what you think is right
  cint = (cmax-cmin)/nlevs_max
  CLEVS = CMIN + FINDGEN(NLEVS_MAX)*CINT  ;findgen(nlevs_max+1
 ;CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
  clevs0 = clevs ; for plot the color bar

  NLEVS = N_ELEMENTS(CLEVS)+1 ;actual number of countour levels

    ;print,i0,' cmin,cmax',cmin,cmax,cint,nlevs

    C_INDEX=(FINDGEN(NLEVS)+1)*col/(NLEVS)
    c_index(NLEVS-1) = 1 ; missing data = white
p0=[0.1,0.15,0.90,0.95]
; plot_position1 = [0.1,0.15,0.93,0.49]; plot_position=[0.1,0.15,0.95,0.45]
; plot_position2 = [0.1,0.6,0.93,0.95]; plot_position2=[0.1,0.6,0.95,0.95]
 ; BAR_POSITION1=[0.97,0.2,0.98,0.45]
 ; BAR_POSITION2=[0.97,0.5,0.98,0.95]
BAR_0=[0.94,0.2,0.96,0.9]
!p.multi=[0,1,2]

pA =[0.1,0.15,0.90,0.45]


pB = [0.1,0.6,0.90,0.90]
;;;;;;;;;;;;separate two channels;;;;;;;;;;;;;;;;;;;;
  ;Tword=''
; read,wordx,prompt='input spec for title: '

   contour,CPPM1,x,y,xtitle='Time interval (min)',ytitle='Height (km)',yrange=[h1,h2],$
   LEVELS = CLEVS, /FILL, C_COLORS = C_INDEX ,/FOLLOW,charsize=1.4, position=pA,$
   title=Tword

   ;xyouts,500,5,'fn',color=1,charsize=2
   ;C_INDEX=C_INDEX*2.5
   contour,CPPM2,x,y,ytitle='Height (km)',yrange=[h1,h2],LEVELS = CLEVS, /FILL,$
    C_COLORS = C_INDEX,/FOLLOW,charsize=1.4, position=pB,title= fls[i1]

  ; xyouts,500,5,'fn',color=1,charsize=2


 ; plot a color bar, use the same clevs as in the contour


    zb = fltarr(2,nlevs)

   for k = 0, nlevs-1 do zb(0:1,k) = cmin + cint*k
     xb = [0,1]
     yb = cmin + findgen(nlevs)*cint
     xname = [' ',' ',' ']
     CONTOUR, zb, xb(0:1), yb(0:nlevs-1),position=BAR_0,$
      xrange=[0,1],/xstyle,xtickv=findgen(2),$
      xticks=1,xtickname=xname,yrange =[cmin,cmax],/YSTYLE, $
      LEVELS = CLEVS0,C_COLOR = C_INDEX, /FILL, ycharsize=0.7, $
      xcharsize=0.8,/noerase,title='signal'

 ;stop

 dnm=fls[i1]
 ;read,wordx,prompt='labels: '
 outpath=path0+'FEB_cirrus\'
 outplot2=outpath+dnm+'_.png'
 write_png,outplot2,tvrd(/true)
;out2=outpath2+fx
;STOP


;WINDOW,1
 ;CONTOUR_MAKE,A12,XX,YY,FLS[i1]
 ;PLOT_OUT2=PATH0+FLS[I1]+'AS.PNG'
   ; write_png,PLOT_OUT2,tvrd(/true)


ENDFOR; I1
STOP
end