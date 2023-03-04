Pro Raman_AEROSOL
; In the first part we will read data and plot;
; In the second part, we will process signal according to Fernald
;P;rt I Rayleigh calcution
 ; read,bnum, prompt='Enter total number bins (eg.4096)  '
   ;constants  for the program
 ; from lidar equation:  dS/dr= (1/beta )d(beta) /dr- 2Kext
  ;beta=XcrossSectin*N(r); N(r) density of N2
  ;dbeta /dr = R dN(r )/dr
 ; dS/dr= (1/N)dN/dr -2 Kext
 ; Kext =(1/2)(d ln(N)/dr-dS/dr)
  ;  =(1/2)[lnN(I)-lnN(I+1)]/dr - [S(I) - S(I+1)]/dr


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;program;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   loadct,5
   device,decomposed=0

   yr='';   year\month
   year=2008
   yr=strtrim(year,2)

    bpath='G:\lidar_data\2008_09_Raman\Raman_N2\2009 mca N2\'
    opath="D:\lidar_data\2008_09_Raman_out\"

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

  Nden=fltarr(bnum) ;air density
  ;beta_r  backscattering coefficient of air
   beta_air=fltarr(bnum);   =beta_r

   Sr=8*!pi/3; lidar ratio for air
   LogDen=fltarr(bnum)
  FOR nair=1,bnum do begin
         xkm=nair*dz/1000
        Beta_air[nair-1]=beta_r(xkm)  ;build array of back scatter coeff of air
        Nden[nair-1]=density(xkm)
        LogDen[nair-1]=Alog(Nden[nair-1])
    ENDFOR
  plot,beta_air,ht,color=25,background=-2
  stop
  plot,Nden,ht,color=25,background=-2
  stop
  plot,LogDen,ht,color=25,background=-2,xtitle='alog density,LogDen '

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
  Read, dnm, PROMPT='Enter filename dnm as de262313:  '
;'   ; Enter date+code
  month=strmid(dnm,0,2)
  fnm=strmid(dnm,0,4); Enter date+code

  READ,n1, n2, PROMPT='Intial and final records;eg.10,100 129: '
  n1=fix(n1)
  n2=fix(n2)
  nx=n2-n1+1


   sg=fltarr(nx,bnum+1)
   sumsg=0
  PR2=fltarr(nx,bnum+1) ;PR2
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

     sg[Jr,*]=smooth(cnt_sig[0:bnum]-bk[jr],10) ;smooth signal

     for k=1,bnum do begin

        if (sg[Jr,k] LE 0) then sg[Jr,k]=sg[Jr,k-1]

       endfor  ;k
     if(jr eq 0) then begin
     plot,sg[0,*],ht,color=4,background=-2,xrange=[0,5000]
     endif
     oplot,sg[jr,*],ht,color=4*jr
     ENDFOR ;JR
 STOP

   BX=fltarr(nx,bnum); dX/dr
    DX=fltarr(nx,bnum);
   beta_a=fltarr(nx,bnum)
      PR2[0,*]=Alog(sg[0,*]*(z^2))
     plot,PR2[0,*],ht,color=2,background=-2,xrange=[15,25],xtitle='X=Ln(Sg*z^2 ',ytitle='ht m'



    for j0=0,nx-1 do begin
       PR2[j0,*]=Alog(sg[j0,*]*z^2);
       oplot,PR2[j0,*],ht,color=5*j0;
    endfor;jo
  stop
   ;fileo=opath+yr+fnm+'DE26_387.bmp'
   ; write_bmp,fileo,tvrd()


   For j1=0,nx-1 do begin
     for k1=izt-1,10,-1 do begin
     BX[j1,k1]=LogDen[j1]-PR2[j1,k1]
      DX[j1,k1]=BX[j1,k1]-BX[j1,k1+1]

    endfor;j1

    endfor; k1
      beta_a=0.5*DX/dz


   plot,smooth(beta_a[0,10:izt-1],20),ht,color=2,background=-2,xrange=[0,0.01],xtitle='beta_a'
   stop
   Av_beta=total(beta_a,1)/(nx)
  oplot,smooth(AV_beta[10:izt-1],20),ht,color=95,thick=2
  stop
   ;file2=opath+yr+dnm+'_TEST.bmp'
    ;write_bmp,file2,tvrd()



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