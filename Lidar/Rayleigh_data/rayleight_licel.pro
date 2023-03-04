Pro RayleighT_licel
 ;edit 2018/12/18
; In the first part we will read data and plot;
; In the second part, we will process signal according to Fernald
; Rayleigh lidar calcution
 ; read,bnum, prompt='Enter total number bins (eg.4096)  '
 ;loadct,5
 device,decomposed=0
   ;constants  for the program

   bnum= 4000  ;30 km
   bT=50;  160      ;160 ns for SR430 bin width

   ns=1.0E-9   ;nanosecond
   c=3.0E8     ;speed of light
   dz=7.5;   24;  bT*ns*c/2  ;increment in height
   zm=dz*indgen(bnum);   Height in m

   ht=zm/1000.  ; height in km

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Part 1 Read data  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  close,/all

  Data_path="F:\lidar_data\"
   dnm=''
   yr=''
  year=2009;
  yr=string(year,format='(I4.4)')
 ; yr=strtrim(year,2);  remove white space

   Read, dnm, PROMPT='Enter filename dnm as JY120230;'   ; Enter date+code
  month=strmid(dnm,0,2)
  fnm=strmid(dnm,0,4)
  READ,n1, n2, PROMPT='Intial and final records;eg.10,100 129: '
  n1=fix(n1)
  n2=fix(n2)
  nx=n2-n1+1
  n5=round(nx/5.);
  s1=strtrim(fix(n1),2)
  s2=strtrim(fix(n2),2)
  S='                file:'+s1+'_'+s2;used to print title
  ctitle=yr+dnm+S

  read,h1,h2,prompt='height region as 10, 30 km  '
  ; input data

   lo_bin=floor(h1/(dz/1000))
   hi_bin=floor(h2/(dz/1000))

;;;;;;;;;;;define arrays;;;;;;;;;;

    cnt_sig=fltarr(bnum)
    csig1=fltarr(bnum)
    sg1=fltarr(nx,bnum)


    X1=fltarr(n5,bnum) ;PR2

  ; input data


   For Jr=0,nx-1  do begin  ;1st For ; automatically read as many files
     jf=n1+jr ;file index starting from n1
      ;multp=n2-n1+1/Mav
     ni=strcompress(jf,/remove_all)

     fn=Data_path+yr+'\'+month+'\'+ dnm+'.'+ni+'m'
   ; out_file=data_path+'\output\'+'_prf.'+'bmp'
     openr,1,fn; data_file;
     readf,1,cnt_sig

     ;cnt_sig=read_binary(fn, DATA_TYPE=2)  ; cnt_sig  ;read binary file
     close,1
     csig1[0:10]=mean(cnt_sig[0:10])
     csig1[11:bnum-1]=cnt_sig[11:bnum-1]  ;take signal betwen h1 and h2

     sg1[jr,*]=smooth(csig1,10) ;smooth signal

     bk1=min(sg1[jr,bnum-20:bnum-1])

     sg1[jr,*]=sg1[jr,*]-bk1

    ENDFOR; JR
     bnum=hi_bin
     P_M=fltarr(n5,bnum)

    For J2=0,n5-1 DO BEGIN

      P_M[j2,*]=(total(sg1[J2:J2+4,*],1)/5)  ;average of 5 profiles
       ;X1[J2,*]=smooth(Alog(pr2m[J2,*]),10)
      maxx=max(P_M[j2,*])
       if j2 eq 0 then begin
          plot,P_m[j2,*],ht,color=2,background=-2,xrange=[0,maxx],yrange=[h1,h2],title=dnm,xtitle= 'count',ytitle='km';file 1',color=2
       endif ;
     endfor; J2

       FOR I2=0,n5-1  do begin
        oplot,P_M[I2,*]+ 10*I2,ht,color=10*I2;
       ;wait,1
       endfor  ;I2


   STOP



  ; smz=smooth(,20)  ;smooth signal

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


z2=hi_bin; reference point
z0=lo_bin
For J5=0,n5-1 do begin

  Y2b[J5,z2-1]=0
  T[J5,z2-1]=230   ;k initial condition


 For n=z2-2,z0,-1 do begin


 Y1[J5,n]=(T[J5,z2-1]*((zm[z2-1]/zm[n])^2)*(P_M[J5,z2-1]/P_m[J5,n]))

 Y2a[J5,n]=(g/R)/(zm[n]^2*P_M[J5,n])
  ;;;; the ingegral below ;;;;;;;;;;;;;;;;
 Y2b[J5,n]=Y2b[J5,n+1]+(dz/2)*(zm[n]^2*P_M[J5,n]+zm[n+1]^2*P_M[J5,n+1])

 T[J5,n]=Y1[J5,n]+Y2a[J5,n]*Y2b[J5,n]

endfor  ;n
 smT[J5,*]=smooth(T[j5,*],10)
endfor; J5

plot,smT[0,*],zm/1000,color=2,background=-2,yrange=[h1,h2]

For i5=1,n5-1 do begin
oplot,smT[i5,*]+100*i5,zm/1000,color=2
endfor ;i5
stop
AvT=fltarr(bnum)
AvT=total(smT,1)/n5
h1=10
plot,AvT-273,zm/1000,color=2,background=-2,yrange=[h1,h2],xrange=[-100,0]

stop

JY12_2009=fltarr(2,1600)
JY12_2009[0,*]=zm[2400:3999]
JY12_2009[1,*]=AVT[2400:3999]

    out_path='F:\RSI\lidar\Rayleigh_data\'; lidarPro\output\yrmn"
    RayT=out_path+fnm+'2009_T.txt'
    openw,1,RayT
    printf,1,JY12_2009
    close,1

   ; write_bmp,outfile1,tvrd(/true)

end

