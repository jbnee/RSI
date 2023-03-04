Pro Tonga_FFT_space

; this is for ascii txt files converted from original lidar data
;;;two channel data with even and odd number separately for one of 2 channels
;;;;FFT along time coordinate
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
FnmD='0115 PM ASC'
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
    Nb=bn2-bn1
   ;s1=strtrim(fix(ni),2)   ; starting file number
   ;s2=strtrim(fix(nf),2)   ;ending file number
   ;Sw ='      file:'+s1+'_'+s2;used to print title
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
    NB=bn2-bn1+1
    AS1=fltarr(m/2,NB) ;PS1=fltarr(m/2,Nbin) ; parallel
    AS2=fltarr(m/2,NB) ; perpendicular
    J=0;          count file
    for k=0,m-2,2 do begin
     As1[J,*]=As[k,*] ; parallel signal
     As2[J,*]=As[k+1,*] ;perpendicular

     ;As1[k,*]=As[k,*]
     ;As2[k,*]=As[k+1,*]
     J=J+1
    endfor; k

;;;;;;;;;;;;;;;;;;;;;;line plots;;;;;;;;;;;;;;;;;;;;;;;

;!p.multi=[0,1,1]

loadct=5

XC=da+'signal plots'
XA=FNMD+'Analog channel'

m2=floor(m/2)
meanAS1=total(AS1,1)/m2;
meanAS2=total(AS2,1)/m2
maxa=max(meanAS1)
maxp=max(meanAS2)
plot,meanAS1,ht,color=2, background=-2,symsize=1.5;,xrange=[0,maxa],yrange=[h1,h2],xtitle='time ',ytitle='km',$
  ;title=XC+'AV 5 perpendicular ' ,charsize=1.2,position=pA
oplot,meanAS2,ht,color=80
stop

;for ip=0,m2-1,10 do begin
;oplot,AS1[ip,*]+ip,ht,color=-50
;oplot,AS1[ip,*]+maxa/2+ip,ht,color=20
;endfor

;plot,meanAS2,ht,color=120,background=-2,symsize=1.5,xrange=[0,maxp],yrange=[h1,h2],ytitle='km',title='AVParallel',$
;charsize=1.2,position=pB;
;for iq=0,m2-1,10 do begin
;oplot,AS2[iq,*]+iq,ht,color=-20
;oplot,AS1[ip,*]+maxa/2+ip,ht,color=20
;endfor
outpath='D:\RSI\volcano\Tonga2022\'
outplot=outpath+da+'_profile.png'
;write_png,outplot,tvrd()


window,1
!p.multi=[0,1,2]

pA =[0.1,0.15,0.95,0.45]
pB = [0.1,0.6,0.95,0.90]

;!p.multi=[0,1,1]
;write_png,outplot,tvrd()
;plot,A[0,*],ht,color=120,xrange=[0,50],yrange=[0,5],position=p2, xtitle='time (min)',ytitle='km',title='0425 analog channel'
bn1=h1*1000/dz
bn2=h2*1000/dz
;IAS1=total(AS1[*,bn1:bn1+nb/2],2); cha 1; integrated signal h1 to h2
;IAS2=total(AS2[*,bn1+nb/2:bn2-1],2); second half higher altitude
;PLOT,Ias1,color=2,background=-2,title='integrate signal 0.3-3km'
;oplot,IAS2,color=-60

;stop
Channel=''
read, channel, prompt=' 1  for AS1, or AS2 for 2'
if channel eq 1 then XS=AS1;;limit to heights 7500m
if channel eq 2 then XS=AS2;
stop
YS=total(XS,1)

Y=FFT(YS);
 ;Y1=FFT(Ias1)   FFT only the parallel part
 ;Y2=FFT(IAS2);
 NS=floor(n_elements(Y)/2);
 ;1=Y1[1:NS];  remove the first term
 ;nf=indgen(NS)

 Power1=abs(Y)^2;
  ; power1=abs(Y1)^2  ; take 1:N0/2 here 1:99
   ;Power2=abs(Y2)^2;

 Power=Power1[1:NS-1]

 plot,Power, color=2,background=-2;
 nyquist=0.5
 ;read,mtime,prompt='Times in minutes of data : '
 ;DT=mtime/N0
 ;;;Timeperdata=DT/N0
 freq=nyquist*(findgen(ns)/ns)
 freq=freq[1:(Ns-1)]
 print,strmid(fls[nf1],20,24)
 print,strmid(fls[nf2],20,24)

 read,DZ,prompt='range in meter.; '
 MZ=DZ/(nf2-nf1+1)
 print,Mz
 peri=1/freq;
 periZ=Mz*peri
  !p.multi=[0,1,1]
  xword=''
read,xword,prompt='add description such as files'
 plot,PeriZ,power,color=2,background=-2,title=DA+xword,xtitle='time min',ytitle='Power'
 oplot,PeriZ,power,psym=4,color=90
 print,stddev(power),mean(power)
 ERR=stddev(power)/mean(power)
 ;ERR2=stddev(power2)/mean(power2)
 print,'ERR=  ',ERR
 print,'peak power:',max(power);
; print,'peak power2, ',max(power2)
 ;Read,x0,y0,prompt='xyouts position as 30,10'
 ; dy=y0/10.
 ; xyouts,x0,y0+dy,'peak power',color=2
  ;xyouts,x0*1.2,y0+dy,max(power),color=2

  ;xyouts,x0*1.6,y0,'mean(power)',color=2
  ;xyouts,x0*1.8,y0,mean(power),color=2
  stop
  ;xyouts,x0,y0-dy,'stddev(power)',color=2
 ;xyouts,x0+15,y0-2*dy,stddev(power),color=2



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

