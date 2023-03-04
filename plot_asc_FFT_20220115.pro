Pro Plot_ASC_FFT_20220115
; this is for ascii txt files converted from original lidar data
;;;two channel data with even and odd number separately for one of 2 channels
;;;;can be expand to 5 channels
CLOSE,/ALL
ERASE
NBin=8000; total bin number  6000x3.75=22.5 km
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
read,h1,h2,prompt='Initial and final height as ,1,5 km:'
h1=fix(h1)
h2=fix(h2)
H_range=string(h1)+'-'+string(h2)
H_range=strcompress(h_range,/remove_all); remove whie space
bn1=h1/dz
bn2=h2/dz
;path='E:\temp\'
;mon='Dec'
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
    Read,nf1,nf2,prompt='starting and ending file nf1, nf2: '
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
     As1[J,*]=As[k,*] ;parallel
     As2[J,*]=As[k+1,*] ;perpendicular

     ;As1[k,*]=As[k,*]
     ;As2[k,*]=As[k+1,*]
     J=J+1
    endfor; k

;;;;;;;;;;;;;;;;;;;;;;line plots;;;;;;;;;;;;;;;;;;;;;;;

;!p.multi=[0,1,1]
!p.multi=[0,2,1]
pA =[0.1,0.15,0.45,0.90]


pB = [0.55,0.15,0.90,0.90]
loadct=5

XC=da+'signal plots'
XA=FNMD+'Analog channel'

m2=floor(m/2)
meanAS1=total(AS1,1)/m2;
meanAS2=total(AS2,1)/m2
maxa=max(meanAS1)
maxp=max(meanAS2)
plot,meanAS1,ht,color=2, background=-2,xrange=[maxa/2,2*maxa],yrange=[h1,h2],xtitle='time ',ytitle='km',$
   charsize=1.2,position=pA

for ip=0,m2-1,5 do begin
 oplot,AS1[ip,*]+ip*5,ht,color=200
;oplot,AS1[ip,*]+maxa/2+ip,ht,color=20
endfor
;stop

plot,meanAS2,ht,color=120,background=-2,xrange=[maxp/2,2*maxp],yrange=[h1,h2],ytitle='km',title='AVParallel',$
charsize=1.2,position=pB;
for iq=0,m2-1,5 do begin
oplot,AS2[iq,*]+iq*5,ht,color=200
;oplot,AS1[ip,*]+maxa/2+ip,ht,color=20
endfor
;outpath='E:\licel_data\2022\2022_outputs\'
outpath='D:\volcano aerosols\Tonga 2022\lidar output\'
outplot=outpath+da+'_profile.png'
;write_png,outplot,tvrd()

stop
window,1
;!p.multi=[0,1,1]
;write_png,outplot,tvrd()
;plot,A[0,*],ht,color=120,xrange=[0,50],yrange=[0,5],position=p2, xtitle='time (min)',ytitle='km',title='0425 analog channel'
AS=AS1+AS2;
IAS1=total(AS[*,bn1:bn2],2); integrated signal 375:3750 km

PLOT,Ias1,color=2,background=-2,title='integrate signal km:  '+H_range

Y1=FFT(Ias1)

 N0=n_elements(Y1)/2
 nf=indgen(N0)

 power=abs(Y1[1:N0])
 nf=nf[1:N0-1]
  freq=0.5*nf/n0
 N3=n_elements(nf)
 Peri=1/freq

 ;plot,peri,power
 plot,peri,power,color=2,xrange=[0,n3],background=-2,title='FFT power'



STOP
;xyouts,10,10000,'4am  9-15km   ',color=2

outpath='D:\volcanos\Tonga 2022\lidar outputs\'
xx=''
read,xx,prompt='add description such as files'
outplot=outpath+da+xx+'_FFT.png';
write_png,outplot,tvrd()
;close,2
   ;;;;;;;;;;;;;;;;;plot contour;;;;;;;;;;;;;;;
;outFFT=fltarr(2,49)
 ;outFFT[0,*]=peri
;outFFT[1,*]=power[0:48]


stop
end
