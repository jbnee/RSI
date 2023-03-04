Pro Wavelet_ASC0114
; this is for ascii txt files converted from original lidar data
;;;two channel data with even and odd number separately for one of 2 channels
;;;;can be expand to 5 channels
CLOSE,/ALL
ERASE
NBin=6000; total bin number  6000x3.75=22.5 km
T=findgen(NBin)   ; define time
fq=40.0e6 ;  20 or 40 MHz
BT=1/fq ; bin width
v=3.0E8; speed of light
dz=v*BT/2  ;this derive height resolution  3.75m
ht=dz*T/1000.+0.0001   ;convert ht to km and remove 0 as base

FNMD='';  file name
year='2022'
;read,year,prompt='Input year of data as 2019:'
read,FnmD,PROMPT='NAME OF THE FILE AS 0415ASC: '

;path='E:\temp\'
;mon=''
;path='E:\LiDAR_DATA\'+year+'\ASC\';
 path='D:\Lidar_DATA\'+year+'\';
 ;da=strmid(fnmd,0,4);
 bpath=path+FNMD;  bpath='G:\0425B\'
  fx=bpath+'\a*'  ;file path
  fls=file_search(fx)
   Sf=size(fls)
    PRINT,'NUM OF TOTAL FILES IN THIS DIRECTORY: ',SF
    Fno=Sf[1]
    T0=strmid(fls[0],41,5)
    T9=strmid(fls[Fno-1],41,5)
  ; SEARCH files of the day, starting with 0
  JF=0

   da=strmid(fnmd,0,4)

    print,da  ;day of data


    nx=Sf[1]


   ;s1=strtrim(fix(ni),2)   ; starting file number
   ;s2=strtrim(fix(nf),2)   ;ending file number
   ;Sw ='      file:'+s1+'_'+s2;used to print title
    sigxm=fltarr(nx,Nbin);   signal count in with range bn2-bn1+1)
    ;=fltarr(nx,N)
    pr2m=fltarr(nx,Nbin)
    pr2d=fltarr(nx,Nbin)

     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    hd=''

    NF=sf[1]   ; number of files
    ;nf1=4         ;LICEL data format inital file number is 5 ignore first 5 data
    ;nf2=NF-1
    Read,nf1,nf2,prompt=' starting and ending file nf1mnf2: '
     m=nf2-nf1+1  ;m is the number of total files for example 200 with 100 parallel 100 perpendicular

    read,h1,h2,prompt='Initial and final height as ,1,5 km:'
    bn1=round(h1*1000./dz)  ;define range of interest bn1 is the lower bin number
    bn2=round(h2*1000./dz)  ;upper bin


    DATAB=FLTARR(2,Nbin)
    Ps=fltarr(m,Nbin) ;Ps photon counting signal
    PSB=fltarr(m); background
    AS0=fltarr(m,Nbin) ;original As  Analog signal
    AS=fltarr(m,Nbin); treated AS signal
    BAS=fltarr(m);  AS background
    close,/all
    J=0;nf1-1
    read,ap, prompt='input 0 for analog,1 for counting:'
    a_p=fix(ap)
    ;read,h1,h2,prompt='Initial and final height as ,1,5 km:'

   FOR I=nf1-1,nf2-1 DO BEGIN ; open file to read
    OPENR,1,fls[I]

      FOR Jh=0,5 do begin ;;;read licel first 5 head lines
        readf,1,hd

        print,hd
      endfor   ;Jh
     ; stop
;;;;;;;;;;;;;;;;;;;; reading data below
      READF,1, DATAB
      AS[J,*]=datab[a_p,*];*(ht*1000)^2; PR2
      BAS[j]=min(AS[J,5500:5999]); background
     ; PS[J,*]=datab[1,*];*(ht*1000)^2
     ; PSB[j]=mean(datab[1,5000:5900]); background
     ; PS[j,*]=PS[j,*]-PSB[j]
      ; AS[j,*]=AS0[j,*]; -BAS[j]*0.95  ;remove background
    close,1
    J=J+1
   ENDFOR;
   stop
   ;stop   ;check error

outpath='E:\RSI\Tonga volcano\'
outdata=outpath+'AS'+DA+'.txt';
openw,1,outdata
printf,1,AS
close,1
;stop

rgb = bytarr(3,256)
openr,2,'E:\rsi\hues.dat'
readf,2,rgb
close,2
free_lun,2
r=bytarr(256)
g = r
b = r
r(0:255) = rgb(0,0:255)
g(0:255) = rgb(1,0:255)
b(0:255) = rgb(2,0:255)
tvlct,r,g,b
!P.BACKGROUND= 1 ; 0 = black, 1 = white
!P.COLOR=2 ;blue labels




   close,/all
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;input data;;;;;;;;;;;;;;;

sB=size(AS)
col=SB[1]
row=SB[2]
;V=rebin(B,col,row)

Nlevel=row
stop

T4as=Total(AS,1) ;total data number for selected time ;0-4am
;stop
dz=3.75/1000.
Ht=findgen(row)*dz  ;dkm=(km[N-1]-km[0])/N;
 wave = WAVELET(T4as,dz,PERIOD=period,COI=coi,/PAD,SIGNIF=signif)
     nscale = N_ELEMENTS(period)
     LOADCT,10
  power1=abs(wave)^2;

pA =[0.1,0.15,0.90,0.90]

pB = [0.1,0.6,0.90,0.90]

BAR_0=[0.94,0.2,0.96,0.9]

;;call make_contour here
;contour_make,power,ht,period
;stop
      CONTOUR,power1,ht,period,ytickinterval=2,background=-2,yrange=[min(period),max(period)],$
       XSTYLE=1,XTITLE='Range ht',YTITLE='Period km',TITLE=DA+'T Wavelet',$
        Nlevels=20,/fill, position=PA
      ; /YTYPE, NLEVELS=25,/FILL       ;*** make y-axis logarithmic

;


 signif = REBIN(TRANSPOSE(signif),Nlevel,nscale)
 power2=ABS(wave)^2/signif
 CONTOUR,power2,ht,period,/OVERPLOT,LEVEL=1.0,C_ANNOT='95%'
 PLOTS,Ht,coi,NOCLIP=0,color=90;     ;*** anything "below" this line is dubious
 close,1
;stop
DEVICE, GET_DECOMPOSED=old_decomposed
DEVICE, DECOMPOSED=0
;stop
 nlevs=20
 zb = fltarr(2,nlevs)

 for k = 0, nlevs-1 do zb(0:1,k) =  8.+1.0*nlevs*k
     xb = [0,1]
     zmax=max(zb);
     zmin=min(zb)
     a=(zmax-zmin)/(nlevs-1);
     b=zmin;  a/(nlevs-1)
     yb =0.025*(a*findgen(nlevs)+b)
     xname = ['','','']

 CONTOUR, zb, xb, yb(0:nlevs-1),Nlevels=20,/fill,position=bar_0,/noerase,$
 ycharsize=1,xcharsize=0.1;,xtickname=xname;,/Ytype
 ;Ytype: log scale
;stop
 ;contour_make,power,ht,period

Mpower=fltarr(6)
Mpower[0]=fix(dA)
Mpower[1]=max(power2)
Mpower[2]=total(power2[row/2,0:max(period)-1],2)
Mpower[3]=total(power2[2000,0:max(period)-1],2)
Mpower[4]=total(power2[3000,0:max(period)-1],2)
Mpower[5]=total(power2[*,max(period/2)],1)

print,Mpower

 fpath='e:\rsi\tonga volcano\'
 outname=Da
 read,outname,prompt='  filename as:wvlt****.png" ??  '
 f1 =fpath+outname+'.png'
WRITE_PNG, f1, TVRD(/TRUE)
stop


end
