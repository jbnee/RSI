Pro Raman_Klett_test
; In the first part we will read data and plot;
; In the second part, we will process signal according to Fernald
;Part I Rayleigh calcution
 ; read,bnum, prompt='Enter total number bins (eg.4096)  '
   ;constants  for the program
   loadct,5
   device,decomposed=0

   yr='';   year\month
   year=2009
   yr=strtrim(year,2)

    bpath='f:\lidar_data\2008_09_Raman\MCA_N2\'+yr+'\'
    opath="F:\lidar_data\2008_09_Raman\output\"

   bT=40     ;bin width, 160 ns for SR430 bin width

   ns=1.0E-9   ;nanosecond
   c=3.0E8     ;speed of light
    bnum= 4000  ;range km

   dz=bT*ns*c/2  ;increment in height is dz=
    z=dz*findgen(bnum+1);   Height in m
   ht=z/1000.  ; height in km
  ;treat Rayleigh scattering
   ;READ,h1,h2,PROMPT='height region from h1(1km) to h2(20 km):  '
   h1=0.6;  ht[100]; lower height
   h2=8; ht[1500] ;upper height
   IZT=h2*1000/dz ;starting ht to process
   ;bn=fltarr(bnum+1); bin array of 1250 for 1250*0.024=30km

  ;beta_r ;Rayleigh backscattering coefficient

  ;density;air density
  ;beta_r  backscattering coefficient of air
   beta_air=fltarr(bnum);   =beta_r

   Sr=8*!pi/3; lidar ratio for air

  FOR nair=1,bnum do begin
         xkm=nair*0.0075
        Beta_air[nair-1]=beta_r(xkm)  ;build array of back scatter coeff of air
    ENDFOR
  plot,beta_air,ht,color=25,background=-2
  stop


;Part 2 Read data
  close,/all
   ;bpath="F:\Lidar data\Rayleigh\";  2003\jn022058\jn022058.4M""   ; AUR or SPR
   ;bpath='f:\lidar_data\2008_09_Raman\MCA_N2\2009\'

 ; Data_path="D:\Lidar systems\Depolar\"
   yr='';   year\month
   year=2008
   yr=strtrim(year,2)

   SA=Sr   ;for Raman

  ;RB=fltarr(16,30)  ; output file type

  dnm=''
  Read, dnm, PROMPT='Enter filename dnm as ja162136;'   ; Enter date+code
  month=strmid(dnm,0,2)
  fnm=strmid(dnm,0,4); Enter date+code

  READ,n1, n2, PROMPT='Intial and final records;eg.10,100 129: '
  n1=fix(n1)
  n2=fix(n2)
  nx=n2-n1+1


   sg=fltarr(nx,bnum+1)
   sumsg=0
  X=fltarr(nx,bnum+1) ;PR2
  BK=fltarr(nx)


  ht=z[0:izt]

  For Jr=0,nx-1  do begin  ;1st For ; automatically read as many files
     jf=n1+jr ;file index starting from n1
      ;multp=n2-n1+1/Mav
    ni=strcompress(jf,/remove_all)

     fn=bpath+month+'\'+ dnm+'.'+ni+'m'

     cnt_sig=read_binary(fn, DATA_TYPE=2)  ; cnt_sig  ;read binary file
     close,1

     Bk[jr]=mean(cnt_sig[bnum-100:bnum]);  treat background

     sg[Jr,*]=smooth(cnt_sig[0:bnum],10)-bk[jr] ;smooth signal

     for k=1,bnum do begin

        if (sg[Jr,k] LE 0) then sg[Jr,k]=sg[Jr,k-1]

       endfor  ;k
     if(jr eq 0) then begin
     plot,sg[0,*],ht,color=4,background=-2
     endif
     oplot,sg[jr,*],ht,color=4*jr
     ENDFOR ;JR
 STOP

      X[0,*]=Alog(sg[0,*]*(z^2))
     plot,X[0,*],ht,color=2,background=-2


    for j1=0,nx-1 do begin


       X[j1,*]=Alog(sg[j1,*]*z^2);

     oplot,X[j1,*],ht,color=5*j1;
    endfor;j1
  stop
  V1=fltarr(nx,IZT)

  B1=fltarr(nx,IZT)

  beta_n=dblarr(nx,IZT)  ;backscattering coefficient of aerosol

   P=density(h2)
   cross_Sec=2.5e-34/SA
     B10=1.0/(P*cross_sec);       ;0;5.0e-7;
   For js=0,nx-1 do begin
    B1[js,*]=0
    V1[js,izt-1]=0
    For k =izt-2 ,0,-1 do begin   ;calculation start from Izt
       V1[js,k+1]=exp(X[js,k]-X[js,izt]); Numerator Klett top
       B1[js,k]=B1[js,k+1]+(V1[js,k]+V1[js,k+1])*(dz/2);B1 is the integral of V1 from zm to z
       beta_n[js,k]=V1[js,k]/(B10+B1[js,k])
    ENDFOR;k
    beta_n[js,izt-1]=beta_n[js,izt-2]
  ENDFOR  ;js
    ;stop

    plot,beta_n[0,*],ht,color=2,background=-2;
    stop
    for nb=1,nx do begin
      oplot,beta_n[nb,*],ht,color=10
    endfor;  nb
    stop
;plot,V1[0:10,*],ht
 ;stop  ; section 1


  Av_beta=total(beta_n,1)/(nx+1)

    N2=dblarr(bnum)
    N2=av_beta/(cross_sec*SA)
    ;N2=smooth(N2,50)
    plot,N2,ht,color=2,background=-2;yrange=[h1,h2]

    qq=where(finite(N2))  ;remove NaN
    stop
   ; q0=size(qq)
   ;for Iq=1,q0[1]-1 do begin
     ;N2(qq(Iq))=N2(qq(Iq)-1)
    ;endfor
    N2x=N2(qq)*1e6  ;N2x is the data remove NaN,change to m3 unit
  oplot,N2x,ht,color=2,thick=2


    stop

   ; plot,n2x/den,ht,color=2,background=-2,yrange=[h1,y2],xtitle='ratio=N2X/density',ytitle='km',title='Klett_Raman'
     file2=opath+yr+dnm+'_TEST.bmp'
    write_bmp,file2,tvrd()

     fnm=strmid(dnm,0,4)
     OT2=opath+fnm+'test_beta.txt'
       openw,2,OT2
       printf,2,N2x
       close,2
       STOP
       end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Function beta_r,ht
 ;ht in km
 ;give backscattering of Rayleigh

 beta_r=5.45E-32*(550./532.0)^4*density(ht)  ;Rayleigh backscattering coefficient
 return,beta_r
end