Pro WHFernal_1    ; In the first part we will read data and plot;
; In the second part, we will process signal according to Fernald
;Part I read data
  Read,bnm, prompt='Enter bin number'
  bn=fltarr(bnm); bin array of 1250 for 1250*0.024=1250
  ITz1=fltarr(bnm)
  ITz2=fltarr(bnm)
  beta_r=fltarr(bnm) ;Rayleigh backscattering coefficient
  ht=fltarr(bnm)



  close,/all
  Data_path="D:\Lidar systems\LidarPro\Rayleigh\";  2003\jn022058\jn022058.4M""   ; AUR or SPR
 ;Data_path="H:\lidarPro\Rayleigh\"

  out_path="D:\lidar systems\lidarPro\output\"
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
  READ, bT, PROMPT='Enter bin width in nanosecond, eg. 160    '

  ; bT=160
   ns=1.0E-9   ;nanosecond
   c=3.0E8     ;speed of light
   dz=bT*ns*c/2

  READ,n1, n2, PROMPT='Intial and final records;eg.10,100 129: '
  n1=fix(n1)
  n2=fix(n2)

  binN=bnm;   The total number of bins of data considered here for 30 km
  ht=(dz/1000)*findgen(binN);   Height in km

   Rkm=3.0E5*bT*1.E-9*c/2.   ;Range in km
   ht_sig=ulonarr(1,binN);uintarr(binN+1);uintarr(binN); bytarr(binN);ulon
   cnt_sig=intarr(binN)  ;uintarr
   sg=fltarr(n2-n1+1,bnm)

   sumsg=0
  For Jr=1,n2-n1+1  do begin  ;1st For ; automatically read as many files
    ni=strcompress(Jr,/remove_all)
    data_file=data_path+dirnm+datecode+'.'+ni+'m';+Dtype ;

     openr,1,data_file;

     readu,1, ht_sig  ;read binary file
     close,1
       For i=0,2047 do begin
        cnt_sig[i]=ht_sig[2*i]
        endfor
     sg[Jr-1,*]=smooth(cnt_sig,10) ;smooth signal
          ;maxsg=max(sg)
        ; sumsg=sumsg+sg

     if (Jr eq n1) then begin
     plot,sg[jr-1,*],ht,background=-2, color=3,yrange=[10,100];,xrange=[1,50000]
     ;xyouts,2000,15,'file 1',color=2
     endif else begin
     oplot,sg[jr-1,*],ht,color=2;
     ;xyouts,2000+Jr*100,15,'Files',color=2
   endelse
   endfor
 stop

;
;Part II Backscattering coefficient calculation  based on Fernald 1984

  X=fltarr(n2-n1+1,binN+1) ;PR2
 A=fltarr(binN+1)
 density=fltarr(binN+1)
  beta_r=fltarr(binN+1) ;backscattering coefficient of air
 beta_a=fltarr(n2-n1+1,binN+1)  ;backscattering coefficient of aerosol
 BTM=fltarr(n2-n1+1,binN+1)  ;numerator of Fernald eq. (5) and (6)
 BTM1=fltarr(n2-n1+1,binN+1)
 BTM2=fltarr(n2-n1+1,binN+1)
 dz=bT*ns*c/2    ;height resolution 24 m for 160 ns
 ht=findgen(binN+1)*dz  ;height in meters of 0-30 km
 km=ht/1000.
 ; density of air is the polynomial fit of height determined from radiosonde
 density= 1.E25*(2.4498-0.22114*km+0.00701*km^2-7.75225E-5*km^3)  ;ht in km; in molec/m3
 beta_r=5.45E-32*(550/532)^4*density  ;Rayleigh backscattering coefficient
  Sa=30
  Sr=8*!pi/3

 For na=0,bnm-1 do begin
  A[na]=(Sa-Sr)*(beta_r[na]+beta_r[na+1])*dz
 endfor

 ;plot,beta_r,ht, background=-2,color=2
 hz1=binN*dz/1000.     ;30 km as the reference point
 hz0=0              ;ground level

 beta_a(*,binN)=1.05*beta_r(binN)  ;initial condition at 30 km =beta_a
 Izt=binN              ;top beam at 30 km which is 1250

  ;stop



  For nj=0,n2-n1  do begin  ;from starting file n1 to last file n2

    X[nj,0:bnm]= sg[nj,0:bnm]*km^2    ;PR^2
   For Iz=Izt,100,-1 do begin          ;calculation starts from 30 km

    BTM1[nj,Iz-1]=X[nj,Iz]/((beta_r[Iz]+beta_a[nj,Iz]))
    BTM2[nj,Iz-1]=Sa*(X[nj,Iz]+X[nj,Iz-1])*EXP(A[Iz])*dz
    BTM[nj,Iz-1]=BTM1[nj,Iz-1]+BTM2[nj,Iz-1]

    beta_a[nj,Iz-1]=(X[nj,Iz-1]*exp(A[Iz-1]))/(BTM[nj,Iz-1])-beta_r[Iz-1]

   Endfor  ;Iz

   ;plot,beta_a[0,*],ht,background=-2,color=1
   endfor   ;nj
    ;stop
       plot,beta_a[0,*],ht,background=-2,color=1

      stop
      For k=0,n2-n1 do begin
         oplot,beta_a[k,*],ht,color=2

       endfor ;k
       stop
     bratio=beta_a[0,*]/beta_r
     plot,bratio,km,background=-2,color=1,yrange=[12,20]

       For L=1,n2-n1 do begin
       bratio=beta_a[L,*]/beta_r
       oplot,bratio,km,color=1
       endfor
     stop
 end

