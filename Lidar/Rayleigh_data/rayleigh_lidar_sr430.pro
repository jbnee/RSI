Pro Rayleigh_lidar_SR430
;
; In the first part we will read data and plot;
; In the second part, we will process signal for temperature calcution
 ; read,bins, prompt='Enter total number bins (eg.4096)  '
   ;constants  for the program
;  $1 basic constants
   bT=160      ;160 ns for SR430 bin width

   ns=1.0E-9   ;nanosecond
   c=3.0E8     ;speed of light
   bins= 8192  ;30 km

   dz=bt*ns*c/2 ;7.5;   24;  bT*ns*c/2  ;increment in height is dz=24 m
    z=dz*findgen(bins+1)+1;   Height in m
   ht=z/1000.  ; height in km
  ;treat Rayleigh scattering

   bn=fltarr(bins); bin array


;$2:Part 2 Read data
 ;;;5 data are averaged
  close,/all

  Data_path="F:\lidar_data\"
  yr=''
  read,year, prompt='input year? '
  yr=string(year,format='(I4.4)')
    ;yr=strtrim(year,2); e space
   dnm=''

   Read, dnm, PROMPT='Enter filename dnm as ja162136;ja170115: '   ; Enter date+code
  month=strmid(dnm,0,2)
  fnm=strmid(dnm,0,4)
  READ,n1, n2, PROMPT='Intial and final records;eg.10,100 129: '
  n1=fix(n1)
  n2=fix(n2)
  nx=n2-n1+1
  n5=round(nx/5.);

  bins=8192  ;original SR430 bins
  P_M=fltarr(n2-n1+1,bins)
   ;sumsg1=0
  X0=fltarr(n2-n1+1,bins) ;average 5 P_M
  X=fltarr(n5,bins); P_M


  read,h1,h2,prompt='height region as 10, 30 km  '
  ; input data
   dz1000=dz/1000.0
   lo_bin=floor(h1/dz1000)
   hi_bin=floor(h2/dz1000)
    b2=hi_bin-2
     gbin=hi_bin-lo_bin

   data_file=fltarr(n2-n1,bins)
   cnt_sig=fltarr(bins)

   sumsg=0

  sg=fltarr(n5,bins)
  csig=fltarr(bins)
  bk=fltarr(bins)
   z=z[0:bins-1]+dz
   ; izt=h2*1000/dz
  For Jr=0,nx-1  do begin  ;1st For ; automatically read as many files
     jf=n1+jr ;file index starting from n1
      ;multp=n2-n1+1/Mav
    ni=strcompress(jf,/remove_all)

    fn=Data_path+yr+'\'+month+'\'+ dnm+'.'+ni+'m'

     datab=read_binary(fn,data_type=2)
        ; sig1=datab(0:bins-1)
     P_M[jr,*]=datab(0:bins-1)
     ENDFOR; Jr

   stop
    ;;;;;;;;;average n5;;;;;;;;;;;;;;
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;;;;;;;bnum =hi_bin to lo_bin
 bnum=hi_bin
;PQ_M=P_M[*,0:bnum];;select signal range
P_M5=fltarr(n5,bnum) ;P_M
Jm=0
AVSig=fltarr(n5,bnum)
HT=ht[0:hi_bin]
plot,P_M[0,*],ht,color=2,yrange=[0,h2],background=-2
;apm=max(P_M[0,0:1000])
FOR i5=0 , nx-5,5 do begin
   AVsig[jm,*]=total(P_M[i5:i5+4,0:bnum-1],1)/5 ;average 5 data

   P_M5[Jm,*]=smooth(Avsig[Jm,*],10)
 oplot,(1+i5/n5)*P_M5[Jm,*],ht,color=2
jm=jm+1

ENDFOR   ; i5

stop


 Y1=fltarr(n5,bnum)
 Y2a=fltarr(n5,bnum)
 Y2b=fltarr(n5,bnum)

 T=fltarr(n5,bnum)
 smT=fltarr(n5,bnum) ;smooth data
;;;temperature equation:
;;;;T(z1)=T(z2)*(z2^2/z1^2)*(S(z2)/S(z1))+(g/R)/[(z1^2*s(z1)]*Integral(z^2*s(z) dz)|z1:z2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
g=9.81     ; gravity constant
R=287.0    ;gas constant


z2=hi_bin; top height ; reference point
z0=lo_bin; low height limit

For J5=0,n5-1 do begin

  Y2b[J5,z2-1]=0
  T[J5,z2-1]=230   ;k initial condition


 For nbin=z2-2,0,-1 do begin


 Y1[J5,nbin]=(T[J5,z2-1]*((z[z2-1]/z[nbin])^2)*(P_M5[J5,z2-1]/P_M5[J5,nbin]))

 Y2a[J5,nbin]=(g/R)/(z[nbin]^2*P_M5[J5,nbin])
  ;;;; the ingegral below ;;;;;;;;;;;;;;;;
 Y2b[J5,nbin]=Y2b[J5,nbin+1]+(dz/2)*(z[nbin]^2*P_M5[J5,nbin]+z[nbin+1]^2*P_M5[J5,nbin+1])

 T[J5,nbin]=Y1[J5,nbin]+Y2a[J5,nbin]*Y2b[J5,nbin]

endfor  ;nbin

endfor; J5

plot,T[0,*],z/1000,color=2,xrange=[0,2500],background=-2,yrange=[h1,h2]


stop
For i5=0,n5/5-1 do begin
smT[i5,*]=total(T[i5:i5+4,*],1)/5
oplot,smT[i5,*],z/1000,color=2
endfor ;i5
stop
AvT=fltarr(bnum)
AvT=total(smT,1)/(i5+1)
h1=10
plot,AvT-273,z/1000,color=2,background=-2,yrange=[h1,h2];xrange=[-100,200]
PM1=total(P_M5,1)/n5
help,PM1
stop
tbin=hi_bin-lo_bin
outfil=fltarr(2,tbin)
outfil[0,*]=z[lo_bin:hi_bin-1]
outfil[1,*]=PM1

close,1
    out_path='F:\RSI\lidar\Rayleigh_data\'; lidarPro\output\yrmn"
    RayT=out_path+'R'+fnm+'_T.txt'
    openw,1,RayT
    printf,1,outfil
    close,1


  stop

 ; outfile1=out_path+fnm+'Ray_T.bmp'
      ; write_bmp,outfile1,tvrd(/true

  END
