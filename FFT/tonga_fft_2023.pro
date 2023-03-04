Pro Tonga_FFT_2023
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
;FnmD='0115 PM ASC'
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
    T0=strmid(fls[0],30,15)
    T9=strmid(fls[Fno-1],30,15)
    print,'1st file: ',T0
    print,'Last file:',T9

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

    Pr2d=fltarr(nx,Nbin)

     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    hd=''

    NF=sf[1]   ; number of files
    ;nf1=4         ;LICEL data format inital file number is 5 ignore first 5 data
    ;nf2=NF-1
    print,'Number of files,: ',NF


    Read,nf1,nf2,prompt='starting and ending file nf1, nf2: '
    nf1=fix(nf1);
    nf2=fix(nf2);
     m=nf2-nf1+1  ;m is the number of total files for example 200 with 100 parallel 100 perpendicular
    stop
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

!p.multi=[0,1,1]

XC=da+'signal plots'
XA=FNMD+'Analog channel'

m2=floor(m/2)
meanAS1=total(AS1,1)/m2;
meanAS2=total(AS2,1)/m2
maxa=max(meanAS1)
maxp=max(meanAS2)
plot,meanAS1[0:999],ht,color=2, background=-2,xtitle='count ',ytitle='Ht',$
   title=XC+'   mean perpendicular ' ,charsize=1.2,position=pA

oplot,meanAS2[0:999],ht,color=200
stop

!p.multi=[0,1,2]

pA =[0.1,0.15,0.95,0.45]

pB = [0.1,0.6,0.95,0.90]
loadct=5
plot,AS1[0,*],ht,color=2,background=-2,yrange=[h1,h2],xtitle='time ',ytitle='km',$
   title=XC+'AS1 ' ,charsize=1.2,position=pA

for ip=1,m2-1,5 do begin
oplot,AS1[ip,*]+ip,ht,color=200
;oplot,AS1[ip,*]+maxa/2+ip,ht,color=20
endfor
stop
plot,AS2[0,*],ht,color=120,background=-2,yrange=[h1,h2],ytitle='km',title='AS2',$
charsize=1.2,position=pB;
;stop
for iq=1,m2-1,5 do begin
oplot,AS2[iq,*]+iq,ht,color=200
;oplot,AS1[ip,*]+maxa/2+ip,ht,color=20
endfor
stop
outpath='D:\RSI\volcano\Tonga2022\'
outplot=outpath+da+'_profile.png'
;write_png,outplot,tvrd()


window,1
!p.multi=[0,1,2]
;write_png,outplot,tvrd()
;plot,A[0,*],ht,color=120,xrange=[0,50],yrange=[0,5],position=p2, xtitle='time (min)',ytitle='km',title='0425 analog channel'
bn1=fix(h1*1000/dz)
bn2=fix(h2*1000/dz)
IAS1=total(AS1[*,bn1:bn2],2); i£½22222222222ntegrated signal h1 to h2

PLOT,Ias1,color=2,background=-2,xtitle='time ',ytitle='Integrated signal',title='integrate AS1'

MAS1=MEAN(IAS1);
DAS1=IAS1-MAS1;

PLOT,DAS1,COLOR=2,background=-2,xtitle='#',ytitle='differential signal',title='Diff_AS1'

;stop
IAS2=total(AS2[*,bn1:bn2],2);
MAS2=MEAN(IAS2);
DAS2=IAS2-MAS2;

plot,DAS1,color=2,background=-2,xtitle='# ',ytitle='diff Integrated signal',title='DAS1'
PLOT,DAS2,color=2,background=-2,xtitle='# ',ytitle='diff Integrated signa2',title='DAS2'
stop
Y1=FFT(DAS1)
Y2=FFT(DAS2)

PLOT,Y1
PLOT,Y2

 ;Y1=FFT(Ias1) ;  FFT only the parallel part
 NS=fix(n_elements(Y1)/2);
 ;Y1=Y1[1:NS-1];  remove the first term
 xpower=2*abs(Y1)^2;
 power=xpower[1:NS-1]; REMOVE DC COMPONENT
 plot,power


 stop
 ;
 nyquist=0.5
 ;read,mtime,prompt='Times in minutes of data : '
 ;DT=mtime/N0
 ;;;Timeperdata=DT/N0
 freq=nyquist*(findgen(ns)/ns)
 plot,freq,power,xtitle='frequency',ytitle='power'
 ;plot,freq,power[2:148],xrange=[0,0.1]
 stop
 xfreq=freq[1:(Ns-1)]
 T=1/xfreq; period
 ;power=powerx[1:fix((ns-1)/2)]
 plot,xpower,xrange=[0,ns-1];
 print,strmid(fls[nf1],20,30)
 print,strmid(fls[nf2-1],20,30)

 read,DT,prompt='time span as=240 min.; '
 MT=DT/(nf2-nf1+1)
 print,MT
 np=n_elements(xpower)
 peri=MT*T;   /freq
  !p.multi=[0,1,1]
 plot,peri,xpower,color=2,background=-2,title=DA+' FFT power',$
 xtitle='time min',ytitle='Power',charsize=1.3

 px=max(power);
 pdev=stddev(power)
 pmn=mean(power)

 power_data=[px,pdev,pmn]
; ERR=stddev(power)/mean(power)
; print,'ERR=  ',ERR
stop

print,'Peak and mean Power, std power: ',power_data;

read,x0,y0,prompt='xyouts power data position as 30,10'

 xyouts,x0,y0,power_data,color=2;

  stop
 ;xyouts,x0,y0-dy,'mean(power)',color=2
  ;xyouts,x0*1.2,y0-dy,mean(power),color=2
  ;stop
 ; xyouts,x0,y0-2*dy,'stddev(power)',color=2
; xyouts,x0*2,y0-2*dy,stddev(power),color=2




STOP

outpath='E:\Tonga volcano 2022\Lidar outputs\'
xx=''
read,xx,prompt='add description such as files'
outplot=outpath+'FFT'+xx+da+'.png';
write_png,outplot,tvrd()
close,2
   ;;;;;;;;;;;;;;;;;plot contour;;;;;;;;;;;;;;;
outs=fltarr(2,ns-1)
outs[0,*]=peri
outs[1,*]=power
outdata=outpath+'power FFT'+da+'.txt'
openw,2,outdata
printf,outs
close,2


stop
end

