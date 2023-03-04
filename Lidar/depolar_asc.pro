Pro Depolar_ASC

close,/all

;  ; read,bnum, prompt='Enter total number bins (eg.4096)  '
   bnum= 8000  ;4km km
   ;constants  for the program
   bT=25     ;160 ns for SR430 bin width

   ns=1.0E-9   ;nanosecond
   c=3.0E8     ;speed of light

   dz= bT*ns*(c/2)/1000  ;increment in height is dz=24 m

   dz1000=dz*1000 ;in meter

  fnm='';  file name
  year='2020'
  ;read,year,prompt='Input year of data as 2019:'
  ;fnm='0211ASC'
  read,fnm,PROMPT='NAME OF THE FILE AS 0415ASC: '
h1=0
h2=10
  ;read,h1,h2,prompt='Initial and final height in km as ,1,5: '
  b1=long(h1/dz);
  b2=long(h2/dz)
  nb=b2-b1+1

  z=findgen(bnum)*dz;+h1  ; height in km
   ht=z[0:nb]*1000+h1 ; in meter
  ;plot,ht
  da=strmid(fnm,0,4)

  ;RB=fltarr(16,30)  ; output file type
   ;dnm='0806'

   bpath='D:\LiDAR_DATA\'+year+'\'+fnm;
    ;bpath=path+FNMD;  bpath='G:\0425B\'
   fx=bpath+'\a*'  ;file path
   fls=file_search(fx)
   Sf=size(fls)
    PRINT,'NUM OF TOTAL FILES IN THIS DIRECTORY: ',SF

  ;

  ;Read, dnm, PROMPT='Enter filename dnm as ja162136;'   ; Enter date+code
 ; month=strmid(dnm,0,2)
;  stop
  READ,n1, n2, PROMPT='Intial and final records;eg.10,100 : '
;n1=1
;n2=200
  read,m0,prompt='Number of files to average (eg 5) :'
  m0=long(m0)
  n1=fix(n1)
  n2=fix(n2)
  NF=n2-n1+1
  NF2=long(Nf/2);
  ;m0=1; average files to average; default is 5
  n5=NF/m0; number of  averaged data files
  m5=long(Nf/(2*m0));
  F1=strtrim(fix(n1),2)
  F2=strtrim(fix(n2),2)
  FS=fnm+'                         file:'+F1+'_'+F2;used to print title
  ;Ftitle=fnm
  ;stop
  ;define arrays
  b0=8000
  DATAB=FLTARR(2,b0)
  ;PS0=fltarr(NF,b0) ;original PS  Analog signal
  PS=fltarr(NF,b0); treated PS signal


  sg=fltarr(NF/2,b0)
  cnt_sig=fltarr(b0)

  ;read,h1,h2,prompt='height region as 1, 6 km  '
  ; input data


 ;;;;;;;;;;;;;;;;;;;; reading data below

  hd=''
  nc=0  ;file count

  FOR I=0,n2-n1-1 DO BEGIN ; open file to read
        Ix=I+n1
       OPENR,1,fls[Ix]

         FOR h=0,5 do begin ;;;read licel first 5 head lines
          readf,1,hd
          ;print,hd
         endfor   ;h

         READF,1, DATAB


      PS[nc,0:b0-30]=DATAB[0,29:b0-1];  Take analog data
      ;PS[j,*]=DATAB[1,]; photon counting data
      close,1

      nc=nc+1

  ENDFOR; I
  plot,datab[0,0:1000],title='check PS/AS '

  oplot,datab[1,0:1000],psym=3
  print,'change datab for analog/photon counting setting'
  stop
  read,k0, prompt='select 0 or 1 for photon counting:'
      close,1

   PS1=fltarr(NF/2,b0) ;PS1=fltarr(m/2,Nbin) ; parallel
   PS2=fltarr(NF/2,b0) ; perpendicular

   BK1=fltarr(NF/2)
   BK2=fltarr(NF/2)

    J=0;          count file Separate parall and perpendicular channels

    for k=k0,NF-2,2 do begin; alternative PLL/PPD
     PS1[J,*]=PS[k,*]
     PS2[J,*]=PS[k+1,*]
     BK1[J]=mean(PS1[J,b0-2000:b0-1])
     BK2[J]=mean(PS2[J,b0-2000:b0-1])
     PS1[j,*]=PS1[j,*]-bk1[j]
     PS2[j,*]=PS2[j,*]-bk2[j]

     J=J+1
    endfor; k

    J2=0

   ; na=long(NF/2)
  ;  NC=long(NF/(2*m0))
   ; bkRatio=fltarr(na)
    ;ps1_5000=fltarr(na)
    ;ps2_5000=fltarr(na)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;AVERAGE data;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

AP1=fltarr(m5,b0)
AP2=fltarr(m5,b0)
;AP3=fltarr(m5,b0)  ; test channel
 j3=0

    FOR i1=0 , NF/2-m0, m0 do begin; average 5 profiles
     For jy=0,b0-1 do begin ;sum 5


       AP1[J3,jy]=total(PS1[i1:i1+m0-1,jy],1)/5;-BK1[j3]
       AP2[J3,jy]=total(PS2[i1:i1+m0-1,jy],1)/5;-BK2[J3]
     ; AP3[J3,jy]=(PS2[i1,jy]+PS2[i1+1,jy]+PS2[i1+2,jy]+PS2[i1+3,jy]+PS2[i1+4,jy])/5 ; test

     ENDFOR  ;i1
   j3=j3+1
 ENDFOR; I

stop
BS1=fltarr(m5)
BS2=fltarr(m5)
for i2=0,m5-1 do begin
 BS1[i2]=mean(ap1[i2,5000:5500])
 BS2[i2]=mean(ap2[i2,5000:5500])
endfor
stop
PS1A=total(AP1,1)/m5
PS2A=total(AP2,1)/m5
erase
loadct=0
!p.multi=[0,1,1]
plot,PS1A,color=2,background=-2,title=fnm+'  sum all signals'
oplot,PS2A,color=90

stop

!p.multi=[0,2,1]
pos1 = [0.1,0.1,0.40,0.95]; plot_position=[0.1,0.15,0.95,0.45]
pos2 = [0.6,0.1,0.90,0.95];


!p.multi=[0,2,1]
IDP=smooth(PS1A,100)/smooth(PS2A,100)
DP=1/IDP
!p.multi=[0,1,1]
plot,smooth(IDP[0:nb*2],100,/edge_truncate),color=2,background=-2,title='Dp/ IDP'
stop
oplot,smooth(DP[0:nb*2],100,/edge_truncate),color=150
cp1=mean(DP[nb/2:nb])
cp2=mean(IDP[nb/2:nb])
cp=[cp1,cp2]
print,cp1,cp2,min(cp)

stop
;read,BK_dp,prompt=' smaller of above
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; determine absolute dp
CF=min(CP)/0.015
;XDP=fltarr(bnum)
;read,ANS, prompt='DP or IDP: '
if (CP1 gt CP2) then XDP=IDP else XDP=dp


    trueDP=XDP/cf;

    DePolar=smooth(trueDP,10);

 z=ht-3
   plot,Depolar[0,*],ht,color=2,background=-2;xrange=[0,1]
    ;
  FOR i5=5 , NC-1, 2 do begin; average 5 profiles
   oplot,depolar[i5,*]+i*0.01,ht,color=2

  ENDFOR; i5


stop


   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;;;;;;;;;;;;;CONTOUR plot;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


   out_path='E:\IDL\lidar\output\'
   FileDp=out_path+'DP_'+da+'_.txt'
   openw,2,fileDP
   printf,2,Depolar
   close,2


  stop

   end





