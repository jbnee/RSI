Pro FFT_2020_2channel
; this is for ascii txt files converted from original lidar data
;;;two channel data with even and odd number separately for one of 2 channels
;;;;can be expand to 5 channels
CLOSE,/ALL
ERASE
NBin=6000; total bin number  6000x3.75=22.5 km
;T=findgen(NBin)   ; define time
fq=40.0e6 ;  20 or 40 MHz
BT=1/fq ; bin width
v=3.0E8; speed of light
dz=v*BT/2  ;this derive height resolution  3.75m
ht=dz*indgen(Nbin)/1000.+0.0001   ;convert ht to km and remove 0 as base

FNMD='';  file name
read,FnmD,PROMPT='NAME OF THE FILE AS 0314ASC: '
read,h1,h2,prompt='Initial and final height as ,1,5 km:'

 path='E:\LiDAR_DATA\2020\'
 bpath=path+'ASC\'+FNMD;  bpath='G:\0425B\'
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
    nf1=0         ;LICEL data format inital file number is 5 ignore first 5 data
    nf2=NF-1
   ;Read,nf1,nf1,prompt='starting and ending file number: '
     m=nf2-nf1+1  ;m is the number of total files for example 200 with 100 parallel 100 perpendicular
    DATAB=FLTARR(2,Nbin)
    Ps=fltarr(m,Nbin) ;Ps photon counting signal

    As=fltarr(m,Nbin) ;As  Analog signal

    close,/all
    J=0;nf1-1
   FOR I=nf1,nf2-1 DO BEGIN ; open file to read
    OPENR,1,fls[I]

      FOR h=0,5 do begin ;;;read licel first 5 head lines
        readf,1,hd
        print,hd
      endfor   ;h
;;;;;;;;;;;;;;;;;;;; reading data below
    READF,1, DATAB
    AS[J,*]=datab[0,*];*(ht*1000)^2; PR2
    PS[J,*]=datab[1,*];*(ht*1000)^2

    close,1
    J=J+1
   ENDFOR;   I
   stop   ;check error
   ;;;;;;;;;;;;;;;;;;;separate two channel data;;;;;;;;;;;;;;;;;;;
    PS1=fltarr(m/2,Nbin) ; parallel

    PS2=fltarr(m/2,Nbin) ;perpendicular
    J=0;          count file
    for k=0,m-2,2 do begin
     Ps1[J,*]=Ps[k,*]
     bk1=min(PS1[j,5500:5900])
     PS1[j,*]=PS1[j,*]-bk1
     ;PR2m[j,*]=PS1[j,*]*(ht*1000)^2;

     PS2[J,*]=Ps[k+1,*]
     bk2=min(PS2[j,5500:5900])
     PS2[j,*]=PS2[j,*]-bk2
     ;PR2D[j,*]=PS2[j,*]*(ht*1000)^2;

     ;As1[k,*]=As[k,*]
     ;As2[k,*]=As[k+1,*]
     J=J+1
    endfor; k
np=size(ps1);
ns=np[1]
;;;;;;;;;;;;;;;;;;;;;;line plots;;;;;;;;;;;;;;;;;;;;;;;

!p.multi=[0,1,1]
;pos1 = [0.1,0.1,0.45,0.9]; plot_position=[0.1,0.15,0.95,0.45]


;pos2 = [0.55,0.1,0.90,0.9]
;p3=[0.4,0.1,0.65,0.9] ;middle position
  ; film=dnm+'.'+strtrim(I,2)+'m'

outpath=path+'plots\'
outplot=outpath+'signal plot.png'
XC=da+'-  paralle/perpendicular polarization'
XA=FNMD+'Analog channel'
;h1=1.5
;h2=8
m2=round(m/2)
meanPs1=total(Ps1,1)/m2;
meanPs2=total(Ps2,1)/m2
maxp=max(meanPs1)
plot,meanPs1,ht,color=2, background=-2,xrange=[0,2*maxp],yrange=[h1,h2],xtitle='count',ytitle='km',$
   title=XC+'every 5',charsize=2
oplot,meanPs2,ht,color=180; background=-2,xrange=[0,maxp],yrange=[h1,h2],position=pos2,xtitle='time (min)',ytitle='km',$
;title=XC,charsize=2
write_png,outplot,tvrd()
;plot,A[0,*],ht,color=120,xrange=[0,50],yrange=[0,5],position=p2, xtitle='time (min)',ytitle='km',title='0425 analog channel'
FOR ic=0,ns-1,10 do begin
oplot,smooth(PS1[ic,*],20)+ic,ht,color=2
endfor

STOP
;;****************FFT signals*****************************
PS12=PS1+PS2;
h1=4500.;
h2=6000;
b1=h1/dz
b2=h2/dz
PSx=Ps12[*,b1:b2-1]
Nx=n_elements(PSx)
SumP=total(PSx,2)
SSmP=smooth(sump,10)
sfft=fft(SSmP)
;lomb_Sg= LNP_TEST(x, y, WK1 = freq, WK2 = amp, JMAX = jmax)
N0=n_elements(sfft)/2

Nf=indgen(N0)
power=abs(sfft[1:N0])^2;
nyquist=1./2;
freq=nyquist*Nf/N0
ffty=fltarr(2,n0)
ffty[0,*]=freq
ffty[1,*]=power[0:N0-1]
period=1/freq
plot,period,power,color=2,background=-2,xtitle='Period (min)',ytitle='Power',title='FFT signals'

 stop
 outpath2='E:\RSI\TAAL\'
 fx=da+'_FFT.png'
out2=outpath2+fx
WRITE_png,OUT2,TVRD(/true)

stop

end
