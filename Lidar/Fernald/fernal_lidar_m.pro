Pro Fernal_lidar_2020
; In the first part Rayleigh scattering is calculate for the air molecules
 ;In the 2nd part, we will read data and plot;
; In the third part, we will process signal according to Fernald and backscatterign coefficient is obtained
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Part I Rayleigh calcution
 ; read,bnum, prompt='Enter total number bins (eg.4096)  '
   bnum= 4000  ;30 km
   ;constants  for the program
   bT=50      ;160 ns for SR430 bin width

   ns=1.0E-9   ;nanosecond
   c=3.0E8     ;speed of light

   dz= bT*ns*(c/2)/1000  ;increment in height is dz=24 m
   ht=findgen(bnum)*dz  ; height in km
   dz1000=dz*1000 ;in meter
   z=ht*1000 ; in meter
  ;treat Rayleigh scattering


  ;ITz1=fltarr(bnum)
  ;ITz2=fltarr(bnum)
  beta_r=fltarr(bnum+1) ;Rayleigh backscattering coefficient
  kext=fltarr(bnum+1)

  beta_r=dblarr(bnum+1) ;backscattering coefficient of air
   TAU=fltarr(bnum+1); Rayleigh optical thickness
   TM=fltarr(bnum+1)  ;  Rayleigh transmission
      density=fltarr(bnum+1);air density
      density= 1.E25*(2.4498-0.22114*ht+0.00701*ht^2-7.75225E-5*ht^3)  ;ht in km; in molec/m3
     beta_r=5.45E-32*(550./532.)^4*density  ;Rayleigh backscattering coefficient

     plot,beta_r,ht, background=-2,color=2,title='Rayleigh backscattering coefficient',ytitle='km',xtitle='beta -m'
     stop
  Sa=30; lidar ratio  ;for cirrus cloud
  Sr=8*!pi/3; lidar ratio for air

   kext=Sr*beta_r   ;Rayleigh extinction
  tau[bnum-1]=0
 for j=bnum-2,0,-1 do begin
    tau[j]=tau[j+1]+(kext[j]+kext[j+1])*dz1000/2
    Tm[j]=exp(-2*tau[j])
 endfor
plot,tau,ht,xtitle='opt,thick and transmission',xrange=[0,1]
xyouts,0.1,15, 'optical thickness'
oplot,Tm,ht; ,position=plot_position2,xrange=[0.75,1],ytitle='km',xtitle='opt,thickness';
xyouts,0.5,10,'atmospheric transmission'



stop
;Part 2 Read data
  close,/all
  path='E:\LiDAR_DATA\'+year+'\ASC\';
  ;data_path="E:\lidar_data\";

  year=2020;   year\month
  yr=strtrim(year,2);  remove white space

  ;Read,yr,  prompt='Enter  Year as 2009 '

  event=0
  ;RB=fltarr(16,30)  ; output file type
  dnm=''
  fnm=strmid(dnm,0,4)

  Read, dnm, PROMPT='Enter filename dnm as ja162136;'   ; Enter date+code
  month=strmid(dnm,0,2)

  READ,n1, n2, PROMPT='Intial and final records;eg.10,100 129: '
  n1=fix(n1)
  n2=fix(n2)
  m=n2-n1+1
  m0=5; average files to average; default is 5
  n5=m/m0; number of  averaged data files
  F1=strtrim(fix(n1),2)
  F2=strtrim(fix(n2),2)
  FS='                         file:'+F1+'_'+F2;used to print title
  Ftitle=yr+dnm

  ;define arrays

  sg=fltarr(m,bnum)
  cnt_sig=fltarr(bnum)
  PR2M=fltarr(n2-n1+1,bnum) ;average 5 PR2
  X=fltarr(n5,bnum); PR2

  read,h1,h2,prompt='height region as 1, 6 km  '
  ; input data

   bpath=path+FNMD;  bpath='G:\0425B\'
  fx=bpath+'\a*'  ;file path
  fls=file_search(fx)
   Sf=size(fls)
    PRINT,'NUM OF TOTAL FILES IN THIS DIRECTORY: ',SF
  ; STOP

  ; SEARCH files of the day, starting with 0
  JF=0

da=strmid(fnmd,0,4)

print,da  ;day of data




    bn1=round(h1*1000./dz)  ;define range of interest bn1 is the lower bin number
    bn2=round(h2*1000./dz)  ;upper bin;

  For Jr=0,nx-1  do begin  ;1st For ; automatically read as many files
     jf=n1+jr ;file index starting from n1
      ;multp=n2-n1+1/Mav
    ni=strcompress(jf,/remove_all)

    ;fn=Data_path+yr+'\'+month+'\'+dnm+'.'+ni+'m'  ;input filename
    openr,1,fn
    readf,1,DATAB  ;Raw signal
    AS0[JR,*]=DATAB[0,*];*(ht*1000)^2; PR2

     ;DATAB=read_binary(fn, DATA_TYPE=2)  ; DATAB  ;read binary file
    ENDFOR ; Jr
    for k=0,m-2,2 do begin
     As1[J,*]=As[k,*]
     As2[J,*]=As[k+1,*]

     ;As1[k,*]=As[k,*]
     ;As2[k,*]=As[k+1,*]
     J=J+1
    endfor; k



     close,1
      bk=min(DATAB[bnum-2000:bnum-1]);  treat background
      sg[Jr,*]=smooth(DATAB,10)-bk ;smooth signal

     PR2M[jr,*]=AS1[jr,*]*(z^2)

     if (Jr eq 0) then begin
        plot,PR2M[jr,*],ht,color=2,background=-2,yrange=[h1,h2],title='PR2_m',xtitle= 'pr2_m',ytitle='km';file 1',color=2
     endif
   ;endfor;   jr

;plot,V1[0:10,*],ht
 stop  ; section 1
;;;;;

 j2=0
FOR i=0 , m-m0, m0 do begin; average 5 profiles
For iy=0,bnum-1 do begin
  X[J2,iy]=MEAN(PR2M[i:i+m0-1,iy])

endfor  ;i
  j2=j2+1
endfor ; iy
;stop
;Part II Backscattering coefficient calculation  based on Fernald 1984
;5 files are averaged
 b1=round(h1/dz)
 b2=round(h2/dz)

 ;define arrays for inversion

 BTM=dblarr(n5,bnum)  ; ¤À¥À  denumerator of Fernald eq. (5) and (6)
 BTM1=dblarr(n5)  ; first term in BTM
 BTM2=dblarr(n5,bnum)  ;2nd term in BTM
 A=fltarr(bnum) ;A term in Fernald
 V1=fltarr(n5,bnum)

 beta_a=dblarr(n5,bnum)  ;backscattering coefficient of aerosol
  bratio=dblarr(n5,bnum)
 ;Initial condition

; evaluation of the second bottom term below
  For nj=0,n5-1  do begin  ;from starting file n1 to last file n2
   ;
   beta_a(nj,b2)=beta_r[b2];
   BTM1[nj]=X[nj,b2]/(beta_r[b2]+beta_a[nj,b2])
    ;while (BTM1[nj] eq 0) and (b2 GT 1) do begin
     ;
      ;BTM1[nj]=X[nj,b2]/(beta_r[b2]+beta_a[nj,b2])
    ; endwhile

    ; A[b2]=0
     ;BTM2[nj,b2]=0
   For k =b2-1 ,1,-1 do begin   ;calculation start from b2
     A[k]=(Sa-Sr)*(beta_r[k]+beta_r[k-1])*dz1000
     V1[nj,k]=X[nj,k]*exp(A[k])

     BTM2[nj,k]=Sa*(X[nj,k]+X[nj,k -1]*exp(A[k]))*dz1000

     BTM[nj,k]=BTM1[nj]+BTM2[nj,k]
     beta_a[nj,k]=(V1[nj,k])/(BTM[nj,k])-(beta_r[k]);
   Endfor  ;k

   endfor   ;nj
    maxa=max(beta_a[0,*])
    mina=min(beta_a[0,*])  ;
    beta_a=beta_a-mina     ;correction for negative beta
    plot,beta_a[0,0:b2],ht,yrange=[h1,h2],xrange=[0,5*maxa],background=-2,color=1,xtitle='beta_a',TITLE=FTITLE+FS
    oplot,beta_r,ht,color=150
      stop; section IIA

    For Nk=0,n5-1 do begin ;
         oplot,beta_a[Nk,0:b2]+Nk*maxa/10,ht,color=2  ;ht[100:b2-100]
      wait,1
    ENDFOR ;Nk
    stop
   out_path=data_Path+'\Aerosol_plots\'; lidarPro\output\yrmn"
   out_file0=OUT_path+dnm+'M_beta2009.png'
   write_png,out_file0,tvrd()

  READ,N,PROMPT='starting FILE NUMBER TO PLOT: '
   F3=strtrim(fix(n+n1),2)
   F4=strtrim(fix(n+n1+1),2)
  FS='                         file:'+F3+'_'+F4;used to print title
    plot,total(beta_a[N:N+5,0:b2],1)/5,ht,yrange=[h1,h2],xrange=[0,maxa/10],background=-2,color=1,$
    xtitle='1/m-sr',ytitle='km',TITLE=FS
    oplot,beta_a[N+1,0:b2],ht,color=2
    ;oplot,beta_r,ht,color=150
    stop
      ;out_path='f:\rsi\lidar\Fernald\test\'; lidarPro\output\yrmn"
      out_file1=OUT_path+dnm+'beta_compare.png'
      write_png,out_file1,tvrd()
       ;stop ;secion IIB
       ;bratio=1+beta_a[1,100:b2]/beta_r[100:b2]
      outdata1=out_path+dnm+'M_betaF.txt'
      hd=''
      hd1=size(beta_a)

      openw,2,outdata1
      hdA='total file, length'
      hdB=[n5,b2]
      printf,2,hdA
      printf,2,hdB
      printf,2,beta_a[*,0:b2]
      close,2
      stop
      bratio[0,0:b2]=1+smooth(beta_a[0,0:b2]/beta_r[0:b2],10)
     plot,bratio[0,0:b2],ht,xrange=[0,100],yrange=[h1,h2],background=-2,color=1,title=FTITLE+FS,xtitle='bacattering ratio 0',ytitle='km'

      ;bbratio=bratio
     ; stop  ;IIC
      sumratio=0
       For L=1,n5-1 do begin;  n2-n1 do begin
       bratio[L,0:b2]=1+smooth(beta_a[L,0:b2]/beta_r[0:b2],10)
       oplot,bratio[L,0:b2],ht,color=1  ;b2-100
       ;stop

       endfor
     stop

     abratio=total(bratio,1,/nan)/n5
     plot,abratio[0:b2],ht,color=4,background=-2,linestyle=2,thick=5,xtitle='ave m backscatt ratio',ytitle='km',TITLE=FTITLE+FS
     stop    ;Section III
      out_file2=out_path+fnm+'M_BK_ratio.png'
     write_png,out_file2,tvrd()
     stop
     end



