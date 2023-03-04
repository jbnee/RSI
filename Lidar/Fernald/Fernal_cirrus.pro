Pro Fernal_cirrus; In the first part we will read data and plot;
; In the second part, we will process signal according to Fernald
;Part I read data
 ; read,bnum, prompt='Enter total number bins (eg.4096)  '
  bnum=4096
  bn=fltarr(bnum); bin array of 1250 for 1250*0.024=30km
  ITz1=fltarr(bnum)
  ITz2=fltarr(bnum)
  beta_r=fltarr(bnum) ;Rayleigh backscattering coefficient
  ht=fltarr(bnum)
  ;constants  for the program
   bT=160      ;160 ns for SR430 bin width
   ns=1.0E-9   ;nanosecond
   c=3.0E8     ;speed of light
   dz=bT*ns*c/2  ;increment in height is dz=24 m

  close,/all
  Data_path="D:\Lidar systems\LidarPro\Rayleigh\";  2003\jn022058\jn022058.4M""   ; AUR or SPR

  yrmn='';   year\month
  Read,yrmn, prompt='Enter director Year, month as 2003\se\:  '
  dirnm=data_path+yrmn
   out_path="D:\lidar systems\lidarPro\output\yrmn"

  event=0
  ;RB=fltarr(16,30)  ; output file type
  filecode=''
  ;file_hd=''

  Read, filecode, PROMPT='Enter code as se010044/se112342 '   ; Enter date+code
    ;Dtype=''  ;D or M
    ;read,file_hd, Prompt='enter file head name as se010044: '
    ; fbn=file_basename(data_path+dirnm+datecode)
    ;Read,Dtype, prompt='enter D or M  '
    ;datecode=string(datecode, format="(I8.8)")
    ;READ, bT, PROMPT='Enter bin width in nanosecond, eg. 160    '


  READ,n1, n2, PROMPT='Intial and final records;eg.10,100 129: '
  n1=fix(n1)
  n2=fix(n2)

  ;binN=bnum;   The total number of bins of data considered here for 30 km
  ht=(dz/1000)*findgen(bnum);   Height in km

   ;Rkm=3.0E5*bT*1.E-9*c/2.   ;Range in km
  ; cnt_sig=uintArr(bnum);uintarr(bnum); bytarr(bnum)
   sg=fltarr(n2-n1+1,bnum)

   sumsg=0
  For Jr=1,n2-n1+1  do begin  ;1st For ; automatically read as many files
     jf=n1+jr-1
    ni=strcompress(jf,/remove_all)
   ; ni=strcompress(Jr,/remove_all)

    fn=dirnm+filecode+'.'+ni+'m'                                   ;+Dtype ;

     out_file=data_path+'out_'+ni+'.'+'bmp'
     ;openr,1,data_file;

     cnt_sig=read_binary(fn, DATA_TYPE=2)  ; cnt_sig  ;read binary file
     close,1

     bk=median(cnt_sig[bnum-500:bnum-1]);  treat background
     sg[Jr-1,*]=smooth(cnt_sig,10)-bk ;smooth signal
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
 stop  ;1

;
;Part II Backscattering coefficient calculation  based on Fernald 1984

 X=fltarr(n2-n1+1,bnum+1) ;PR2
 A=fltarr(bnum+1)
 density=fltarr(bnum+1);air density
  beta_r=fltarr(bnum+1) ;backscattering coefficient of air
 beta_a=fltarr(n2-n1+1,bnum+1)  ;backscattering coefficient of aerosol
 BTM=fltarr(n2-n1+1,bnum+1)  ;numerator of Fernald eq. (5) and (6)
 BTM1=fltarr(n2-n1+1,bnum+1)
 BTM2=fltarr(n2-n1+1,bnum+1)
 dz=bT*ns*c/2    ;height resolution 24 m for 160 ns
 ;;;ht=findgen(bnum+1)*dz  ;height in meters of 0-30 km
 ;;;km=ht/1000.
 ; density of air is the polynomial fit of height determined from radiosonde
 density= 1.E25*(2.4498-0.22114*km+0.00701*km^2-7.75225E-5*km^3)  ;ht in km; in molec/m3
 beta_r=5.45E-32*(550/532)^4*density  ;Rayleigh backscattering coefficient
  Sa=30; lidar ratio
  Sr=8*!pi/3; lidar ratio for air

 Izt= 1250             ;top beam at 30 km which is 1250
 For na=0,Izt-1 do begin
  A[na]=(Sa-Sr)*(beta_r[na]+beta_r[na+1])*dz
 endfor  ;na
  A[Izt]=A[Izt-1]
 ;plot,beta_r,ht, background=-2,color=2
 hz1=Izt*dz/1000.     ;30 km as the reference point
 hz0=0              ;ground level
 bnum=Izt
 beta_a(*,Izt)=2*beta_r(Izt)  ;initial condition at 30 km =beta_a
;read,IZt,prompt='top height to treat in bin number: 1250(30 km),833(20km0  :'



  ;stop
  ;TO3 is the ozone transmission at 532 nm
 ; TO3=6.8828e-008*km^4 - 6.8432e-006*km^3 + 1.5743e-004*km^2 - 0.0015*km + 1.0011
   TO3=1
  For nj=0,n2-n1  do begin  ;from starting file n1 to last file n2

    X[nj,0:Izt-1]= sg[nj,0:Izt-1]*km^2/TO3   ;PR^2
   For Iz=Izt,100,-1 do begin   ;calculation start from Izt

    BTM1[nj,Iz-1]=X[nj,Iz]/((beta_r[Iz]+beta_a[nj,Iz]))
    BTM2[nj,Iz-1]=Sa*(X[nj,Iz]+X[nj,Iz-1])*EXP(A[Iz])*dz
    BTM[nj,Iz-1]=BTM1[nj,Iz-1]+BTM2[nj,Iz-1]

    beta_a[nj,Iz-1]=(X[nj,Iz-1]*exp(A[Iz-1]))/(BTM[nj,Iz-1])-beta_r[Iz-1]

   Endfor  ;Iz

   ;plot,beta_a[0,*],ht,background=-2,color=1
   endfor   ;nj
    ;stop

    plot,beta_a[0,100:izt-100],ht,background=-2,color=1,xtitle='beta_a'

      stop;  II
      For k=0,n2-n1 do begin
         oplot,beta_a[k,100:izt],ht[100:1150],color=2

       endfor ;k
       stop ;IIB
    bratio=1+beta_a[1,100:Izt]/beta_r[100:izt]

     plot,bratio,ht[100:1150],background=-2,color=1,xrange=[0,100]
      bbratio=bratio
      stop  ;IIC
      sumratio=0
       For L=1,n2-n1 do begin
       bratio=1+beta_a[L,100:Izt]/beta_r
       oplot,bratio+ max(bbratio),ht[100:1150],color=1
       ;stop
       sumratio=sumratio+bratio
       endfor
     stop
     avratio=sumratio/(L+1)
     oplot,avratio,ht[100:1150],color=1, psym=7
     stop
    ; write_bmp,out_file,tvrd()
     end

