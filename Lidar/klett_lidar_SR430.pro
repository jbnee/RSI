Pro Klett_lidar_SR430;_not working
;only beta_a[0] is right
; In the first part we will read data and plot;
; In the second part, we will process signal according to Fernald
;Part I Rayleigh calcution
 ; read,bnum, prompt='Enter total number bins (eg.4096)  '
   ;constants  for the program

   bT=160      ;160 ns for SR430 bin width

   ns=1.0E-9   ;nanosecond
   c=3.0E8     ;speed of light
    bnum= 1000  ;30 km
   ; binx=2500
   dz=bt*ns*c/2 ;7.5;   24;  bT*ns*c/2  ;increment in height is dz=24 m
    z=dz*findgen(bnum+1)+1;   Height in m
   ht=z/1000.  ; height in km
  ;treat Rayleigh scattering

  bn=fltarr(bnum+1); bin array

  beta_r=fltarr(bnum+1) ;Rayleigh backscattering coefficient
  kext=fltarr(bnum+1)
  density=fltarr(bnum+1);air density
  beta_r=dblarr(bnum+1) ;backscattering coefficient of air
   TAU=fltarr(bnum+1); Rayleigh optical thickness
   TM=fltarr(bnum+1)  ;  Rayleigh transmission

     density= 1.E25*(2.4498-0.22114*ht+0.00701*ht^2-7.75225E-5*ht^3)  ;ht in km; in molec/m3
     beta_r=5.45E-32*(550./532.)^4*density  ;Rayleigh backscattering coefficient

     plot,beta_r,ht, background=-2,color=2
     stop
  Sa=60; lidar ratio  ;for cirrus cloud
  Sr=8*!pi/3; lidar ratio for air

   kext=(8*3.1416/3.)*beta_r   ;Rayleigh extinction
 for j=1,bnum do begin
    tau[j]=kext[j]*24+tau[j-1]
    Tm[j]=exp(-2*tau[j])
 endfor; j
plot,tau,ht,position=plot_position1,title='tau',ytitle='km';charsize=2.0
;xyouts,0.02,15,'tau optical thickness'
plot,tm,ht,position=plot_position2,xrange=[0.75,1],ytitle='km',xtitle='opt,thickness';
;xyouts,0.85,15,'transmission atmosphere'
stop
INTB=fltarr(bnum+1); integral of beta_r from top down
INTB[bnum]=0
FOR I1=bnum-1,1,-1 do begin

 INTB[I1]=INTB[bnum]+(beta_r[I1]+beta_r[I1-1])*(dz/2)
ENDFOR;I1


plot,INTB,ht,xtitle='integrated beta_r top down', ytitle='km'

stop
;Part 2 Read data
  close,/all

  Data_path="F:\lidar_data\"   ;\Lidar_systems\LidarPro\DePolar\";  2003\jn022058\jn022058.4M""   ; AUR or SPR
  yr=''
  read,year, prompt='input year? '
 yr=string(year,format='(I4.4)')
    ;yr=strtrim(year,2); e space
   dnm=''

   Read, dnm, PROMPT='Enter filename dnm as ja162136;'   ; Enter date+code
  month=strmid(dnm,0,2)
  fnm=strmid(dnm,0,4)
  READ,n1, n2, PROMPT='Intial and final records;eg.10,100 129: '
  n1=fix(n1)
  n2=fix(n2)
  nx=n2-n1+1
  n5=round(nx/5.);


  pr2m=fltarr(n2-n1+1,bnum)
   ;sumsg1=0
  X0=fltarr(n2-n1+1,bnum) ;average 5 PR2
  X=fltarr(n5,bnum); PR2

  bratio=dblarr(n5,bnum)
  read,h1,h2,prompt='height region as 1, 6 km  '
  ; input data
   dz1000=dz/1000.0
   lo_bin=floor(h1/dz1000)
    hi_bin=floor(h2/dz1000)
    b2=hi_bin-2
     gbin=hi_bin-lo_bin

   data_file=fltarr(n2-n1,bnum)
   cnt_sig=fltarr(bnum)


   sumsg=0
  X=fltarr(n5,bnum) ;PR2
  V1=fltarr(n5,bnum)  ;  ??? upper term in Fernald
  B1=fltarr(n5,bnum)
  beta_a=dblarr(n5,bnum)  ;backscattering coefficient of aerosol
  bratio=dblarr(n5,bnum)

  ; input data

  sg=fltarr(n5,bnum)
  csig=fltarr(bnum)
  bk=fltarr(bnum)
    z=z[0:bnum-1]+dz
    izt=h2*1000/dz
  For Jr=0,n5-1  do begin  ;1st For ; automatically read as many files
     jf=n1+jr ;file index starting from n1
      ;multp=n2-n1+1/Mav
    ni=strcompress(jf,/remove_all)

   fn=Data_path+yr+'\'+month+'\'+ dnm+'.'+ni+'m'
   ; out_file=data_path+'\output\'+'_prf.'+'bmp'
     openr,1,fn; data_file;
     ;readf,1,cnt_sig

     cnt_sig=read_binary(fn, DATA_TYPE=2)  ; cnt_sig  ;read binary file
     close,1

     csig=cnt_sig[11:bnum+10]  ;take signal betwen h1 and h2

     sg=smooth(csig,10) ;smooth signal

     bk[jr]=mean(sg[bnum-500:bnum-1])
      sg=sg-bk[jr]
     pr2m[Jr,*]=sg*(z^2)

     for Im=0,bnum-1 do begin

     if (pr2m[Jr,im] LE 0) then Pr2m[jr,im]=bk[jr]


     endfor
     BK0=mean(bk)
    ; Pr2m[*,hi_bin:bnum-1]=bk0
     X[jr,*]=smooth(Alog(Pr2m[jr,*]),40)

 endfor;jr

     plot,X[0,*],ht,color=2,background=-2,xrange=[0,100],yrange=[h1,h2],$file 1',color=2
     title='X= log(PR2m))',xtitle='X',ytitle='km'

    FOR js=0,n5-1 do begin
     oplot,X[js,*]+1.2*Js,ht,color=2;
     B1[js,izt+1]=0
     For k =izt,0,-1 do begin   ;calculation start from Izt
       V1[js,k+1]=exp(X[js,k]-X[js,izt])
       B1[js,k]=B1[js,k+1]+(1.0/SA)*(V1[js,k]+V1[js,k+1])*(dz/2.0);B1 is the integral of V1 from zm to z

     ENDFOR;k

    ENDFOR ;js
     ;xyouts,2000+Jr*100,15,'Files',color=2

    STOP

 ;Initial condition

   ; beta_a(*,IZT)=0  ;5*beta_r(Izt-1)  ;initial condition at 30 km =beta_a
    B10=beta_r(Izt)


; evaluation of the second bottom term below
  For nj=0,n5-1  do begin  ;from starting file n1 to last file n2
     For k =izt-1 ,1,-1 do begin   ;calculation start from Izt
      beta_a[nj,k]=V1[nj,k]/(x[nj,izt]/B10+B1[nj,k]);

     Endfor  ;k
  ENDFOR   ;nj
    maxa=max(beta_a[0,*])
    ;plot,beta_a[0,100:izt-1],ht+100/24.0,yrange=[10,20], background=-2,color=1,xtitle='beta_a'
     plot,beta_a[0,0:izt-1]/maxa,ht,xrange=[0,10*maxa],yrange=[h1,h2], background=-2,color=1,xtitle='beta_a'
      stop; section IIA

    For k=0,n5-1 do begin
         ;oplot,beta_a[k,100:izt-1],ht+100/24.0,color=2  ;ht[100:izt-100]
          oplot,beta_a[k,0:izt-1]/maxa,ht,color=2
          wait, 1
    ENDFOR ;k
    stop ;secion IIB
     out_path='F:\lidar_data\test\'; lidarPro\output\yrmn"
    outfile1=out_path+fnm+'Klt_BETA_A.bmp'
       write_bmp,outfile1,tvrd(/true)


      AOD1=fltarr(n5)
       AOD1[0]=0

       read,hc1,hc2,prompt='cloud height region in km as 1,3 km'
       bc1=round(hc1*1000/dz)
       bc2=round(hc2*1000/dz)

       for ia=0,n5-1 do begin

       AOD1[ia]=total(beta_a(ia,bc1:bc2),2)*dz*SA/(bc2-bc1+1)
       endfor
       ;Rst=finite(AOD1,/nan)
      ; Rs2=where(Rst eq 1)
      ; AOD1[RS2]=0

       plot,AOD1,color=2,background=-2,psym=4,ytitle='AOD',xtitle='time #'
       oplot,AOD1,color=35

       stop
       AOD=mean(AOD1)
       print,'AOD:  ',AOD

       stop

       outfile1=out_path+fnm+'AOD.bmp'
       write_bmp,outfile1,tvrd(/true)


       ;bratio=1+beta_a[1,100:Izt]/beta_r[100:izt]

    bratio[0,0:izt]=1+smooth(beta_a[0,0:izt]/beta_r[0:izt],10)
     plot,bratio[0,0:izt],ht,yrange=[h1,h2],background=-2,color=10;xtitle='back ratio';xrange=[0,100]
      ;bbratio=bratio
      stop  ;IIC
      sumratio=0
       For L=1,n5-1 do begin
       bratio[L,0:izt]=1+smooth(beta_a[L,0:izt]/beta_r[0:izt],10)
       oplot,bratio[L,0:izt]+l,ht,color=1;yrange=[0,h2] ;izt-100
       ;stop
       sumratio=sumratio+bratio[L,0:izt]
       endfor
     stop
     avratio=sumratio/(L+1)
     plot,avratio,ht,color=1,background=-2,yrange=[h1,h2],title='average ratio'
     stop    ;Section III
    ;; write_bmp,out_file,tvrd()
      END
