Pro FFT_SHIFT_TONGA
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
;read,FnmD,PROMPT='NAME OF THE FILE AS 0415ASC: '
FnmD='0115 ASC'
print,'filename: ',FnmD
read,h1,h2,prompt='Initial and final height as ,1,5 km:'
;path='E:\temp\'
mon=''
;path='E:\LiDAR_DATA\'+year+'\ASC\';
 path='D:\Lidar_DATA\'+year+'\';
 bpath=path+FNMD;  bpath='G:\0425B\'
  fx=bpath+'\a*'  ;file path
  fls=file_search(fx)
   Sf=size(fls)
    PRINT,'NUM OF TOTAL FILES IN THIS DIRECTORY: ',SF
;stop
    Fno=Sf[1]
    T0=strmid(fls[0],41,5)
    T9=strmid(fls[Fno-1],41,5)
  ; SEARCH files of the day, starting with 0
  JF=0

da=strmid(fnmd,0,4)

print,da  ;day of data


    nx=Sf[1]


    bn1=round(h1*1000./dz)  ;define range of interest bn1 is the lower bin number
    bn2=round(h2*1000./dz)  ;upper bin
    Ht=ht(bn1:bn2-bn1+1)

    sigxm=fltarr(nx,Nbin);   signal count in with range bn2-bn1+1)
    ;=fltarr(nx,N)
    pr2m=fltarr(nx,Nbin)

    Pr2d=fltarr(nx,Nbin)

     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    hd=''

    NF=sf[1]   ; number of files
    ;nf1=4         ;LICEL data format inital file number is 5 ignore first 5 data
    ;nf2=NF-1
    print,'Number of files,: ',NF
    stop
    Read,nf1,nf2,prompt='starting and ending file nf1, nf2: '
    nf1=fix(nf1);
    nf2=fix(nf2);
     m=nf2-nf1+1  ;m is the number of total files for example 200 with 100 parallel 100 perpendicular

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

   FOR I=nf1-1,nf2-1 DO BEGIN ; open file to read
    OPENR,1,fls[I]

      FOR h=0,5 do begin ;;;read licel first 5 head lines
        readf,1,hd

        ;print,hd
      endfor   ;h
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

   ;stop   ;check error
   ;;;;;;;;;;;;;;;;;;;separate two channel data;;;;;;;;;;;;;;;;;;;
   ; PS1=fltarr(m/2,Nbin) ; parallel
   ; PS2=fltarr(m/2,Nbin) ;perpendicular
  ;ANALOG
    AS1=fltarr(m/2,Nbin) ;PS1=fltarr(m/2,Nbin) ; parallel
    AS2=fltarr(m/2,Nbin) ; perpendicular
    J=0;          count file
    for k=0,m-2,2 do begin
     As1[J,*]=As[k,*] ; parallel signal
     As2[J,*]=As[k+1,*] ;perpendicular

     ;As1[k,*]=As[k,*]
     ;As2[k,*]=As[k+1,*]
     J=J+1
    endfor; k

;;;;;;;;;;;;;;;;;;;;;;line plots;;;;;;;;;;;;;;;;;;;;;;;
Sz=size(AS1)

;!p.multi=[0,1,1]
;write_png,outplot,tvrd()
;plot,A[0,*],ht,color=120,xrange=[0,50],yrange=[0,5],position=p2, xtitle='time (min)',ytitle='km',title='0425 analog channel'
bn1=h1*1000/dz
bn2=fix(h2*1000/dz)
AS1x=AS1[*,0:bn2-1]; reduce heights range
Sz1=size(AS1x)
stop
;m0=AS[1]
;n0=AS[2]
mf=floor(nf2-nf1+1)/2
xx=indgen(mf)
yy=dz*indgen(bn2);

contour,AS1x,xx,yy,color=2,background=-2,yrange=[500,1500]
;window,1
stop
read,DT,prompt='time span as=240 min.; '

;;;***** Take signal hourly average below *******************
H0=DT/60; hours number
ASH=AS1x[*,bn1:bn2-1]  ;fltarr(H0,bn2) ;

;ih=0
;!p.multi=[0,H0,1]
plot,total(ASH,1),color=2,background=-2
for ih=0,H0-1 do begin
 oplot,total(ASH[ih:ih+60,*],1),color=ih0

endfor

stop


window,1

Z=FFT(ASH) ; 2D FFT only the parallel part

;powerZ = (ABS(Z)^2)   ; log of Fourier power spectrum.
;PZ=powerz[1:150,1,400]

Z=fft(AS1x)
SZ=size(Z)

imagesize=[SZ[1],SZ[2]]
center = imageSize/2 + 1
ORIGIN=[0,0]
fftShifted = SHIFT(Z,ORIGIN)  ;SHIFT(Z, center)
displaySize = 2*imageSize
DEVICE, DECOMPOSED = 0
LOADCT, 20
WINDOW, 0, XSIZE = displaySize[0], YSIZE = displaySize[1], TITLE = 'Original Image'
TVSCL, CONGRID(ASH, displaySize[0], displaySize[1]);

STOP
scaledPowerSpect = ALOG10(Z)

interval = 1.
hFrequency = INDGEN(imageSize[0])
hFrequency[center[0]] = center[0] - imageSize[0] + $
   FINDGEN(center[0] - 2)
hFrequency = hFrequency/(imageSize[0]/interval)
hFreqShifted = SHIFT(hFrequency, -center[0])
vFrequency = INDGEN(imageSize[1])
vFrequency[center[1]] = center[1] - imageSize[1] + $
   FINDGEN(center[1] - 2)
vFrequency = vFrequency/(imageSize[1]/interval)
vFreqShifted = SHIFT(vFrequency, -center[1])


window, 1, TITLE = 'FFT Power Spectrum: '+ 'Log Scale (surface)'
SHADE_SURF, scaledPowerSpect, hFreqShifted, vFreqShifted, $
   /XSTYLE, /YSTYLE, /ZSTYLE, $
   TITLE = 'Log-scaled Power Spectrum', $
   XTITLE = 'Horizontal Frequency', $
   YTITLE = 'Vertical Frequency', $
   ZTITLE = 'Log(Squared Amplitude)', CHARSIZE = 1.5


stop
WINDOW, 2, XSIZE = displaySize[0], YSIZE = displaySize[1], $
   TITLE = 'FFT Power Spectrum: Logarithmic Scale (image)'

STOP

outpath='E:\RSI\Tonga volcano\'
xx=''
read,xx,prompt='add description such as files'
outplot=outpath+'FFT'+da+xx+'.png';
write_png,outplot,tvrd()
close,2
   ;;;;;;;;;;;;;;;;;plot contour;;;;;;;;;;;;;;;


stop
end

