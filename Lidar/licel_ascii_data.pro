Pro Licel_ASCII_data
; this is for ascii txt files converted from original lidar data
CLOSE,/ALL
;!p.multi=[0,1,2]
;!p.background=255

  ;bpath='f:\Lidar_data\2007\ap\ap_TEX';\CH6_3sB'
  bpath='E:\LIDAR_DATA\2019\1219ASC\'
  fx=bpath+'\a*'
  fls=file_search(fx)
    nf=size(fls)
    PRINT,'NUM OF TOTAL FILES IN THIS DIRECTORY: ',NF
    STOP

  ; SEARCH files of the day, starting with 0 JF=0
  READ,JF,PROMPT='STARTING FILE TO SEARCH: '
     ;data count J=0 is the name of the 1st file
  fi=fls[Jf]
  fi_date=strmid(fls[jf],31,2)
  nfday=where(strmid(fls,31,2) eq fi_date)

  S1=size(nfday)
  print,S1[1]
  stop
sdnm=strmid(fi,8,15)  ; change this for correct word count
month=strmid(sdnm,3,1)
;if (month eq 4) then MX='AP'
da=strmid(sdnm,4,2)
hr=strmid(sdnm,6,2)
minute=strmid(sdnm,9,2)
dnm='AP'+da+hr+minute  ; this is the file name

print,dnm
stop
 N=2000
T=findgen(N)

ht=3.0E8*50.E-9*T/2./1000.+0.001   ;convert ht to km and remove 0 with bin resolution 50 ns
  FX=BPATH+'\T*';    e*'
  ;fx=bpath+'\t09726*';  yr+'\'+month+'\'+dnm+'.'
  ; read,h1,h2,prompt='Initial and final height as ,1,5 km:'



    nx=nf[1]
    h1=1.0
    h2=4.0
    n1=round(h1*1000./7.5)  ;channel number
    n2=round(h2*1000./7.5)  ;ch
   ;s1=strtrim(fix(ni),2)
   ;s2=strtrim(fix(nf),2)
   ;Sw ='      file:'+s1+'_'+s2;used to print title
    sigxm=fltarr(nx,N);n2-n1+1)
    ;=fltarr(nx,N)
    pr2m=fltarr(nx,N)
    pr2d=fltarr(nx,N)

     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    hd=''

    Read,n1,n2,prompt='starting and ending file number: '
     m=n2-n1+1
    DATAB=FLTARR(4,N)
    ApM=fltarr(m,N)
    ApD=fltarr(m,N)
    ppm=fltarr(m,N)
    ppd=fltarr(m,N)
    close,/all
    J=0
   FOR I=n1,n2 DO BEGIN
    OPENR,1,fls[I]
    readf,1,hd
    READF,1, DATAB
    APm[J,*]=datab[0,*]
    PPm[J,*]=datab[1,*]
    apd[J,*]=datab[2,*]
    PPd[J,*]=datab[3,*]
    ; sig=fltarr(nx,40000)
    close,1
    J=J+1
   ENDFOR
   stop
!p.multi=[0,1,2]
p1 = [0.1,0.15,0.90,0.49]; plot_position=[0.1,0.15,0.95,0.45]
 p2 = [0.1,0.6,0.90,0.95]

  ; film=dnm+'.'+strtrim(I,2)+'m'
outfile='F:\lidar_data\2007\AP\AP_test\'
plot,APM[0,*],ht,color=2, background=-2,xrange=[0,10],yrange=[0,4],position=p1

FOR J=0,M-1 DO BEGIN
oplot,APM[J,*]+J*0.5,ht, color=5+j
openw,2,outfile+dnm+'.'+strtrim(J,2)+'m'
printf,2,PPM[J,0:999]
close,2
ENDFOR

STOP

plot,PPD[0,*],ht,color=2,background=-2,position=p2,yrange=[0,4],xrange=[0,2000]

FOR K=0,M-1 DO BEGIN
oplot,Ppd[K,*]+K*5,ht,color=5+K
openw,2,outfile+dnm+'.'+strtrim(k,2)+'d'
printf,2,PPD[k,0:999]
close,2
ENDFOR



   stop
   end

