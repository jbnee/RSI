Pro Contour_aerosol_ASC
; this is for ascii txt files converted from original lidar data
;;;two channel data with even and odd number separately for one of 2 channels
;;;;can be expand to 5 channels
CLOSE,/ALL
ERASE
bnum=8000; total bin number  6000x3.75=22.5 km
T=findgen(bnum)   ; define time
fq=40.0e6 ;  20 or 40 MHz
BT=1/fq ; bin width
v=3.0E8; speed of light

dz=v*BT/2  ;this derive height resolution  3.75m

dz=3.75
ht=dz*T/1000.+0.0001   ;convert ht to km and remove 0 as base

year=''
 READ,year, prompt='year ????: '

FNMD=''
;FNMD='0211ASC';  file name
read,FnmD,PROMPT='NAME OF THE FILE AS 0314ASC: '
read,h1,h2,prompt='Initial and final height as ,1,5 km:'
dnm=strmid(fnmd,0,8)


 path0='D:\LiDAR_DATA\'+year+'\'
 bpath=path0+FNMD;  bpath='G:\0425B\'
  fx=bpath+'\a*'  ;file path
  fls=file_search(fx)
  Sf=size(fls)
    PRINT,'NUM OF TOTAL FILES IN THIS DIRECTORY: ',SF
  Fno=Sf[1]
 ;T0=strmid(fls[0],36,5)
 ;9=strmid(fls[Fno-1],36,5)
 print,'1st file: ', fls[0]
 print,'Last file: ', fls[fno-1]
 ;stop
  ; SEARCH files of the day, starting with 0
  JF=0

 T0=strmid(fls[0],41,5)

print,dnm,'hr',T0  ;starting time of the day of data


    nx=Sf[1]


    bn1=round(h1*1000./dz)  ;define range of interest bn1 is the lower bin number
    bn2=round(h2*1000./dz)  ;upper bin
    Nbin=bn2-bn1+1
   ;s1=strtrim(fix(ni),2)   ; starting file number
   ;s2=strtrim(fix(nf),2)   ;ending file number
   ;Sw ='      file:'+s1+'_'+s2;used to print title

     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    hd=''


   ; NF=sf[1]   ; number of files
    read,nf1,nf2,prompt='1st and last files to read as 1,300:'

   ; nf1=1         ;LICEL data format inital file number is 5 ignore first 5 data
   ; nf2=NF
   READ,a_p,prompt='analog (0) or photon (1) ;'

   stop
     nx=nf2-nf1+1  ;m is the number of total files for example 200 with 100 parallel 100 perpendicular
     m=fix(nx/2);
    DATAB=FLTARR(2,bnum); FLTARR(2,Nbin)
    Ps=fltarr(Nx,bnum); fltarr(Nx,Nbin) ;Ps ANALOG OR photon counting signal

    ;As=fltarr(m,Nbin) ;As  Analog signal

    close,/all

   J1=0
   FOR I=nf1,nf2-1 DO BEGIN ; open file to read

      OPENR,1,fls[I]

      FOR h=0,5 do begin ;;;read licel first 5 head lines
        readf,1,hd
        ;print,hd
      endfor   ;h
;;;;;;;;;;;;;;;;;;;; reading data below
      READF,1, DATAB
      ;AS[J,*]=datab[1,*];*(ht*1000)^2; PR2

      close,1

    PS[J1,*]=datab[a_p,*];*(ht*1000)^2
    J1=J1+1
   ;while (J1 lt m-1) do  J1=J1+1
   ENDFOR; I
   stop   ;check error
   ;;;;;;;;;;;;;;;;;;;separate two channel data;;;;;;;;;;;;;;;;;;;
    PS1=fltarr(m,bnum) ; parallel

    PS2=fltarr(m,bnum) ;perpendicular
    J=0;          count file
    for k=0,Nx-2,2 do begin
     Ps1[J,*]=Ps[k,*]
     bk1=min(PS1[j,bnum-200:bnum-1])
     PS1[j,*]=PS1[j,*]-bk1
     ;PR2m[j,*]=PS1[j,*]*(ht*1000)^2;

     PS2[J,*]=Ps[k+1,*]
     bk2=min(PS2[j,bnum-200:bnum-1])
     PS2[j,*]=PS2[j,*]-bk2
     ;PR2D[j,*]=PS2[j,*]*(ht*1000)^2;

     ;As1[k,*]=As[k,*]
     ;As2[k,*]=As[k+1,*]
     J=J+1
    endfor; k
np=size(ps1);
ns=np[1]
;;;;;;;;;;;;;;;;;;;;;;line plots;;;;;;;;;;;;;;;;;;;;;;;
;ht=ht[bn1:bn2]
!p.multi=[0,1,1]
plot,total(Ps1,1),color=2,background=-2
oplot,total(PS2,1),color=100


m2=floor(m/2)
meanPs1=total(Ps1,1)/m2;
bk1=mean(meanPS1[bnum-500:bnum-100])
meanPs2=total(Ps2,1)/m2
bk2=mean(meanPS1[bnum-500:bnum-100])
maxp=max(meanPs1)
!p.multi=[0,1,2]

plot,smooth(meanPs1-bk1,20),color=2, background=-2;,xrange=[bn1,bn2],xtitle='bin #',ytitle='PS1',$
 ;  title=dnm+'_PS1',charsize=1.2
plot,smooth(meanPs2-bk2,20),color=2, background=-2;,xrange=[bn1,bn2],ytitle='PS2',title='PS2'

stop
!p.multi=[0,3,1]

IC=[1,m2-m2/2,m2-m2/4,m2-2]
;z=ht[bn1:bn2]
for jc=0,2 do begin
  plot,smooth(total(PS1[ic[jc]:ic[jc+1],bn1:bn2],1),20),ht[bn1:bn2],xrange=[0,500],yrange=[h1,h2],$
  title='file:'+IC[jc],charsize=2
  ;plot,smooth(PS1[ic[jc],bn1:bn2],20),ht,yrange=[h1,h2],color=2,background=-2,title='file'+ic[jc]
  oplot,smooth(total(PS2[ic[jc]:ic[jc+1],bn1:bn2],1),20),ht[bn1:bn2],color=100;

endfor; jc
wait,5
;STOP
outpath=path0+'contours\'
outplot1=outpath+dnm+'prfl_4.png'
;write_png,outplot1,tvrd(/true)
;plot,A[0,*],ht,color=120,xrange=[0,50],yrange=[0,5],position=p2, xtitle='time (min)',ytitle='km',title='0425 analog channel'



STOP

outplot1=outpath+dnm+'prfl.bmp'
;write_bmp,outplot1,tvrd(/true)
close,2

stop
   ;;;;;;;;;;;;;;;;;plot contour;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
erase
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

 nbin=bn2-bn1+1
  ;na=30 ;reset inital file for error data
  na=0
  x=indgen(m/2-na)
  y=dz*indgen(Nbin)/1000+h1
  ;
  CPPM1=PS1[na:m2-1,bn1:bn2]  ;chan 1 PARALLEL
  CPPM2=PS2[na:m2-1,bn1:bn2]  ;chan 2 PERPENDI

 ; CPPD=A[0:m-1,*] ; analog


  col = 240 ; don't change it
  cmin=0;min(AZ);10 is arbitrary set the 5th file
  cmax1=max(PS1[m/4,bn1+100:bn2-100]);for high altitude  ;cmax=1*max(CPPM[m/2,100:1000]); for low altitude
  cmax2=max(PS2[m/4,bn1+100:bn2-100]);
  ctest=mean([cmax1,cmax2])
  cmax=min(ctest)  ; select the largest one

  nlevs_max =20 ; choose what you think is right
  cint = (cmax-cmin)/nlevs_max
  CLEVS = CMIN + FINDGEN(NLEVS_MAX)*CINT  ;findgen(nlevs_max+1
 ;CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
  clevs0 = clevs ; for plot the color bar

  NLEVS = N_ELEMENTS(CLEVS)+1 ;actual number of countour levels

    ;print,i0,' cmin,cmax',cmin,cmax,cint,nlevs

    C_INDEX=(FINDGEN(NLEVS)+1)*col/(NLEVS)
    c_index(NLEVS-1) = 1 ; missing data = white
;p0=[0.1,0.15,0.90,0.95]
; plot_position1 = [0.1,0.15,0.93,0.49]; plot_position=[0.1,0.15,0.95,0.45]
; plot_position2 = [0.1,0.6,0.93,0.95]; plot_position2=[0.1,0.6,0.95,0.95]
 ; BAR_POSITION1=[0.97,0.2,0.98,0.45]
 ; BAR_POSITION2=[0.97,0.5,0.98,0.95]

!p.multi=[0,1,2]

pA =[0.1,0.15,0.90,0.45];
pB = [0.1,0.6,0.90,0.90];
BAR_0=[0.94,0.2,0.96,0.9];
;;;;;;;;;;;;separate two channels;;;;;;;;;;;;;;;;;;;;
  ;Tword=''
; read,wordx,prompt='input spec for title: '

   contour,CPPM1,x,y,xtitle='Time interval (min)',ytitle='Height (km)',yrange=[h1,h2],$
   LEVELS = CLEVS, /FILL, C_COLORS = C_INDEX ,/FOLLOW,charsize=1.4, position=pA,$
   title='CPPM1'
  ;stop
   ;xyouts,500,5,'fn',color=1,charsize=2
   ;C_INDEX=C_INDEX*2.5
   contour,CPPM2,x,y,ytitle='Height (km)',yrange=[h1,h2],LEVELS = CLEVS, /FILL,$
    C_COLORS = C_INDEX,/FOLLOW,charsize=1.4, position=pB,title=dnm+'-CPPM2'

  ; xyouts,500,5,'fn',color=1,charsize=2


 ; plot a color bar, use the same clevs as in the contour

  ;stop
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
 if (a_p eq 1) then wordx='photon' else wordx='Analog'

 ;read,wordx,prompt='labels: '
 outpath=path0+'contour\'
 outplot2=outpath+dnm+wordx+'_.png'
 write_png,outplot2,tvrd(/true)
;out2=outpath2+fx
STOP


end
;**************** depolarization  ********************




