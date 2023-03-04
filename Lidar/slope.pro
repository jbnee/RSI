Pro Slope; Solving lidar equation by assume constant slope of backscattering ratio,
;In the first part we will read data and plot;
; In the second part, we will process signal according to solve lidar eq. dX/dz=c/beta-2*X*beta
;X is ln(z^2P)
  bnum=4096
  ;read,bnum, prompt='Enter total number bins (eg.4096)  '
  bn=fltarr(bnum); bin array of 1250 for 1250*0.024=30km
  ;ITz1=fltarr(bnum)
  ;ITz2=fltarr(bnum)
  beta_r=fltarr(bnum) ;Rayleigh backscattering coefficient
  ht=fltarr(bnum)

  close,/all
  Data_path="D:\lidar systems\LidarPro\Rayleigh\";  2003\jn022058\jn022058.4M""   ; AUR or SPR
 ;Data_path="H:\lidarPro\Rayleigh\"

  ;out_path="D:\lidar systems\lidarPro\output\"
  dirnm=''
  Read,dirnm, prompt='Enter director Year, month as 2003\JN\'
   dirnm=dirnm+'\'
  event=0
  ;RB=fltarr(16,30)  ; output file type
  datecode=''

  Read, datecode, PROMPT='Enter date as se112342 '   ; Enter date
  Dtype=''
  ;Read,Dtype, prompt='enter D or M  '
  ;datecode=string(datecode, format="(I8.8)")
  ;READ, bT, PROMPT='Enter bin width in nanosecond, eg. 160    '
   bT=160  ; for NCU system
   ns=1.0E-9   ;nanosecond
   c=3.0E8     ;speed of light
   dz=bT*ns*c/2  ;height resolution

  READ,n1, n2, PROMPT='Intial and final files to treat ;eg.10,100 129: '
  n1=fix(n1)
  n2=fix(n2)

  ;binN=bnum;   The total number of bins of data considered here for 30 km
   ht=(dz/1000)*findgen(bnum);   Height in km

   Rkm=3.0E5*bT*1.E-9*c/2.   ;Range in km
   cnt_sig=uintArr(bnum);uintarr(bnum); bytarr(bnum)
   sg=fltarr(n2-n1+1,bnum)

   sumsg=0
  For Jr=1,n2-n1+1 do begin  ;1st  automatically read as many files
    jf=n1+jr-1
    ni=strcompress(jf,/remove_all)
    data_file=data_path+dirnm+datecode+'.'+ni+'m';+Dtype ;

     openr,1,data_file;

     readu,1, cnt_sig  ;read binary file
     close,1
     bk=median(cnt_sig[bnum-500:bnum-1]);  treat background

     sg[Jr-1,*]=smooth(cnt_sig,10)-bk ;smooth signal and abvoid zero
          ;maxsg=max(sg)
        ; sumsg=sumsg+sg

     if (Jr eq 1) then begin
     plot,sg[jr-1,*],ht,background=-2, color=3,yrange=[10,30];,xrange=[1,50000]
     ;xyouts,2000,15,'file 1',color=2
     endif else begin
     oplot,sg[jr-1,*],ht,color=2;
     ;xyouts,2000+Jr*100,15,'Files',color=2
   endelse
   endfor
 stop

;
;Part II Slope method for Backscattering coefficient calculation
bnum2=1250         ; for 30 km and below

 density=fltarr(bnum2+1)
  beta_r=fltarr(bnum2+1) ;backscattering coefficient of air
  beta_a=fltarr(n2-n1+1,bnum2)  ;backscattering coefficient of aerosol

; ht=findgen(bnum2+1)*dz  ;height range in meters of 0-30 km
 km=ht
 km[0]=0.01
 ; density of air is the polynomial fit of height determined from radiosonde
 density= 1.E25*(2.4498-0.22114*km+0.00701*km^2-7.75225E-5*km^3)  ;ht in km; in molec/m3
 beta_r=5.45E-32*(550/532)^4*density  ;Rayleigh backscattering coefficient
  Sa=30.0
  Sr=8*!pi/3
 hz1=bnum*dz/1000.     ;30 km as the reference point
 hz0=0              ;ground level
 ;stop
 slp=deriv(km,beta_r)
; slp=median(slp1)
  ; TO3=6.8828e-008*km^4 - 6.8432e-006*km^3 + 1.5743e-004*km^2 - 0.0015*km + 1.0011
 stop

;-------------------------OK
;X=fltarr[n2-n1,bnum2]
 Izt=bnum2
 htm=ht*1000
 For nj=0,n2-n1  do begin  ;from starting file n1 to last file n2

    X= Alog(sg[nj,0:bnum2-1]*(htm[0:bnum2-1]^2));/TO3   ;PR^2
   ;X[nj]= Alog(sg[nj,0:bnum2-1]*km[0:bnum2-1]^2)
    ;stop
  ;For nj2=0,n2-n1 do begin ; calculate the dX/dz  ;;;;;
    D2=deriv(X)
    D2[0:100]=0
    D=smooth(D2,10)

     ;For Iz=IZT,0,-1 do begin   ;calculation start from Izt

    beta_a[nj,*]=(-D+sqrt(D^2+8*Sa*slp))/(4*Sa)

     ;Endfor  ;Iz
endfor   ;nj2
     plot,beta_a[0,*],km[1:1250],background=-2,color=1

      stop
      For k=0,n2-n1 do begin
         oplot,beta_a[k,*],km[1:1250],color=2

       endfor ;k
       stop
     bratio=1+beta_a[0,*]/beta_r
     plot,bratio,km[1:850],background=-2,color=1;,xrange=[-1,1000]
      stop
      sumratio=0
       For L=1,n2-n1 do begin
       bratio=1+beta_a[L,*]/beta_r
       oplot,bratio,km[1:1250],color=1
       ;stop
       sumratio=sumratio+bratio
       endfor
     stop
     avratio=sumratio/(L+1)
     oplot,avratio,km,color=1, psym=7
     stop
     end

