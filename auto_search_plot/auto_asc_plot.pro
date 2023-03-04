Pro AUTO_ASC_plot
; AUTO contour plot for several  ascii txt files

;;**************;PART 1: search for data  ***************
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
;;******************
pos1 = [0.05,0.1,0.2,0.9];
pos2 = [0.25,0.1,0.45,0.9];
pos3=[0.5,0.1,0.70,0.9]
pos4=[0.75,0.1,0.95,0.9]
;***********************
pA =[0.1,0.15,0.90,0.45]

pB = [0.1,0.6,0.90,0.90]
;;*****************************************

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
 PATH1='D:\LIDAR_DATA\DATA_LIST\'+FILEs+'.txt';
 LN1=''

 read,NAT,prompt='total data in this file 32:'

 fileX=strarr(NAT)
 OPENR,1,path1
 readf,1,FILEX
 print,FILEX
 ;READ,N0,prompt='Starting file number, as 0:'

 READ,Nz, PROMPT=' NUMBER OF FILES to plot: '

  ;LN1=''

 fls=strarr(NAT)  ; data name
 YNM=INTARR(NAT)  ; number of data
 for ns=0,NZ-1 DO BEGIN;  NaT-1 do begin

    ; READF,1,LN1
     ; PRINT,LN1
       FLS[ns]=strmid(FILEX[ns],0,11);  +'ASC'  ;filename
       YNM[ns]=strmid(FILEX[ns],20,3) ;file number


;
     endfor ;Ns
   print,FLS,Ynm
 close,1
 STOP
 read,n0,prompt='starting file: as 8 '
dz1000=dz/1000.0
h1=10.;
bn1=fix(h1/dz1000);
h2=20.0
bn2=fix(h2/dz1000);
READ,a_p,prompt='analog (0) or photon (1) :'
;;$ PART 2 READ DATA ******************************
   datab=fltarr(2,bnum)
;read,n0,prompt='starting file as 9'
   HD='';
   FOR i1=N0,NZ-1 DO BEGIN ; open file to read
      ;fx='D:\LIDAR_DATA\2022\'+FLS[i]+'\a*'
      F2=PATH0+FLS[i1]+'\a*'
      ;fNM=PATH0+FLS[NS]
       Px=file_search(F2)  ; FINDING how many data are there
       nx=n_elements(px);


     ;AS=FLTARR(NX,BNUM)
     XS=FLTARR(NX,BNUM)

      ;
     FOR j0=0,nx-1 do begin
      OPENR,1,Px[j0]
         FOR h=0,5 do begin ;;;read licel first 5 head lines
         readf,1,hd
        ;print,hd
         endfor   ;h
       ;;;;;;;;;;;;;;;;;;;; reading data below **********************

      READF,1, DATAB
     ; AS[J0,*]=datab[1,*];*(ht*1000)^2; PR2
      XS[J0,*]=datab[a_p,*];*(ht*1000)^2

      close,1
     ENDFOR; J0


 ;
   stop   ;check error
   ;;;;;;;;;;;;;;;;;;;separate two channel data;;;;;;;;;;;;;;;;;;;
    m=fix(NX/2)
    nbin=bn2-bn1+1
    XS1=fltarr(m/2,Nbin) ; parallel

    XS2=fltarr(m/2,Nbin) ;perpendicular
    J=0;          count file
    for k=0,m-2,2 do begin
     XS1[J,*]=XS[k,bn1:bn2]
     bk1=min(XS1[J,nbin-200:nbin-1])
     XS1[j,*]=XS1[j,*]-bk1
     ;PR2m[j,*]=XS1[j,*]*(ht*1000)^2;

     XS2[J,*]=XS[k+1,bn1:bn2]
     bk2=min(XS2[j,Nbin-200:Nbin-1])
     XS2[j,*]=XS2[j,*]-bk2

     J=J+1
    endfor; k

XS12=XS1+XS2
Total_XS=total(XS12,1)
;stop
;z=ht(bn1:bn2)
;z1=h1/1000.
;z2=h2/1000.
;loadct=5
;!p.multi=[0,1,1]
!p.multi=[0,4,1]

plot,smooth(Total_XS,50),ht,color=2,background=-2,yrange=[h1,h2],$
title=fls[i1],position=pos1
;oplot,smooth(total_XS1,40),z,color=90

m2=fix(m/2)
Im=[m2/4,m2-m2/2,m2-2]
; plot four part of data in total signals PS1+Ps2
;for j2=0,2 do begin
  XST1=total(XS1[0:im[0],*],1)+total(XS2[0:im[0],*],1)
  XST2=total(XS1[im[0]:im[1],*],1)+total(XS2[im[0]:im[1],*],1)
  XST3=total(XS1[im[1]:im[2],*],1)+total(XS2[im[1]:im[2],*],1)



z=ht[bn1:bn2]
 plot,smooth(XST1,20),ht,color=2,yrange=[h1,h2],background=-2,$
 title='file'+im[0],position=pos2
 ;oplot,smooth(PS2T1[im[0],*],20),ht,color=-60

plot,smooth(XST2,20),ht,yrange=[h1,h2],color=2,background=-2,$
 title='file'+im[1],position=pos3
 ;oplot,smooth(PS2T2,20),ht,color=-60

plot,smooth(XST3,20),ht,yrange=[h1,h2],color=2,background=-2,$
 title='file'+im[2],position=pos4
 ;oplot,smooth(PS2T3,20),ht,color=-60

DATA_path='D:\Lidar_data\2022\OUTPUTS_FEB10km\'
     ;out_path=data_Path+'\Aerosol_plots\'; lidarPro\output\yrmn"
     out_file=DATA_path+fls[i1]+'.png'

    ;write_png,out_file,tvrd(/true)
wait,2
;
; xx=indgen(m2)
;text1=fls(i1)
;window,1
;contour_make,XS12,xx,z,text1
;out_contour=DATA_path+fls[i1]+'contourX.png'

;write_png,out_contour,tvrd(/true)


;endfor;I1
   ;;;;;;;;;;;;;;;;;plot contour;;;;;;;;;;;;;;;s1
 na=0
  x=indgen(m/2-na)
  y=dz*indgen(Nbin)/1000+h1
  ;
  CPPM1=XS1[na:m2-1,*]  ;chan 1 PARALLEL
  CPPM2=XS2[na:m2-1,*]  ;chan 2 PERPENDI

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

!p.multi=[0,1,2]

;;;;;;;;;;;;separate two channels;;;;;;;;;;;;;;;;;;;;
  ;Tword=''
; read,wordx,prompt='input spec for title: '

   contour,CPPM1,x,y,xtitle='Time interval (min)',ytitle='Height (km)',yrange=[h1,h2],$
   LEVELS = CLEVS, /FILL, C_COLORS = C_INDEX ,/FOLLOW,charsize=1.4, position=pA,$
   title=Tword

   ;xyouts,500,5,'fn',color=1,charsize=2
   ;C_INDEX=C_INDEX*2.5
   contour,CPPM2,x,y,ytitle='Height (km)',yrange=[h1,h2],LEVELS = CLEVS, /FILL,$
    C_COLORS = C_INDEX,/FOLLOW,charsize=1.4, position=pB,title=dnm

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

 stop
 wordx='am/pm'
 read,wordx,prompt='labels: '
 outpath=path0+'test\'
 outplot2=outpath+dnm+word+'_.png'
 ;write_png,outplot2,tvrd(/true)
;out2=outpath2+fx
window,2
erase
CPPM=CPPM1+CPPM2
outplot3=outpath+dnm+'contour2_.png'
label=dnm+wordx
contour_make,CPPM,X,Y,label
;WRITE_png,OUTplot3,TVRD(/true)


endfor;I1
stop
;;contour_plot
end