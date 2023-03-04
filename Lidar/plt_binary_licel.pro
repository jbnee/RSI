Pro Plt_binary_licel

!P.MULTI = [0,1,2]
   plot_position1 = [0.1,0.15,0.98,0.49]; plot_position=[0.1,0.15,0.95,0.45]
  plot_position2 = [0.1,0.6,0.98,0.94]; plot_position2=[0.1,0.6,0.95,0.95]
   plot_postion0=[0.1, 0.1,0.9,0.9]
!p.background=255

NBin=6000; total bin number  6000x3.75=22.5 km
T=findgen(NBin)   ; define time
fq=40.0e6 ;  20 or 40 MHz
BT=1/fq ; bin width
v=3.0E8; speed of light
dz=v*BT/2  ;this derive height resolution  3.75m
ht=dz*T/1000.+0.0001   ;convert ht to km and remove 0 as base

FNMD='';  file name
year='2021'
;read,year,prompt='Input year of data as 2019:'
read,FnmD,PROMPT='NAME OF THE FILE AS 0415ASC: '

da=strmid(fnmd,0,4)

print,da  ;day of data


;path='E:\LiDAR_DATA\'+year+'\ASC\';
 path='D:\Lidar_DATA\'+year+'\';
 da=strmid(fnmd,0,4);
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



    nx=Sf[1]

   read,h1,h2,prompt='Initial and final height as ,1,5 km:'

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
    Read,nf1,nf2,prompt=' starting and ending file nf1mnf2: '
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
   I=nf1
  ;FOR I=nf1-1,nf2-1 DO BEGIN ; open file to read
    OPENR,1,fls[I]

      FOR h=0,5 do begin ;;;read licel first 5 head lines
        readf,1,hd

        print,hd
      endfor   ;h
      stop
      sig1=read_binary(fls[I],data_type=1)
      sig2=read_binary(fls[I],data_type=2)
;;;;;;;;;;;;;;;;;;;; reading data below
      ;READF,1, DATAB
      ;AS[J,*]=datab[a_p,*];*(ht*1000)^2; PR2
      BAS[j]=min(AS[J,5500:5999]); background
     ; PS[J,*]=datab[1,*];*(ht*1000)^2  ;bpath='f:\Lidar_data\';   lidarPro\depolar\'
   close,1
    J=J+1
  ; ENDFOR;
stop
Ns1=n_elements(sig1)/4
x1=fltarr(Ns1)
x2=fltarr(Ns1)
x3=fltarr(Ns1)
x4=fltarr(Ns1)

sig1_b=fltarr(4,Ns1)
J1=0
for N1=0,Ns1/2,4 do begin
x1[J1]=sig1[N1]
x2[J1]=sig1[N1+1]
x3[J1]=sig1[N1+2]
x4[J1]=sig1[N1+3]
J1=J1+1
endfor;

plot,x3[0:10000]
stop
print,'END'


 end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 ;

