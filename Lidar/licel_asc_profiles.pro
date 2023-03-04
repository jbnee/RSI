pro licel_ASC_profiles
  ; based on betaM or betaD
erase
  close,/all
  dz=3.75;    ; for SR430 bin width
  year='';
  read,year,prompt='enter year as 2020'
  yr=strtrim(year,2);  remove white space
  dnm=''
    ;fnm=strmid(dnm,0,4)

  Read, dnm, PROMPT='Enter filename fnm as 0115ASC;'   ; Enter date+code
   month=strmid(dnm,0,2)
  bpath='D:\Lidar_data\';   systems\depolar\'
  fpath=bpath+yr+'\'

  fnm=fpath+dnm;
  fx=fnm+'\a*'  ;file path
  fls=file_search(fx)
  Sf=size(fls)
    PRINT,'NUM OF TOTAL FILES IN THIS DIRECTORY: ',SF
  ; STOP

  bnum=4000
   HT=dz*findgen(bnum)/1000.0

  read,ni,nf, prompt='Initial and file number as 1,99: '
  read,h1,h2,prompt='Height range in km as 1,5: '
  bn1=fix(h1*1000/dz)
  bn2=fix(h2*1000/dz)
  nx=nf-ni+1


  datab=fltarr(bnum)




 s1=strtrim(fix(ni),2)
 s2=strtrim(fix(nf),2)
 S='       file:'+s1+'_'+s2;used to print title
 stop
  ;define arrays
  DATAB=FLTARR(2,bnum)
  AS0=fltarr(NF,bnum) ;original As  Analog signal
  AS=fltarr(NF,bnum); treated AS signal
  AS1=fltarr(NF/2,bnum) ;PS1=fltarr(m/2,Nbin) ; parallel
  AS2=fltarr(NF/2,bnum) ; perpendicular
  AS12=fltarr(NF/2,bnum);
  ;sg=fltarr(NF/2,bnum)
  ;cnt_sig=fltarr(bnum)
  ;PR2M=fltarr(NF/2,bnum) ;average 5 PR2
 ; X=fltarr(NF/2,bnum); PR2

  ;read,h1,h2,prompt='height region as 1, 6 km  '
  ; input data



 ;;;;;;;;;;;;;;;;;;;; reading data below

  hd=''
  nc=0  ;file count

  FOR I=0,nf-ni-1 DO BEGIN ; open file to read
        Ix=I+ni
       OPENR,1,fls[Ix]

        FOR h=0,5 do begin ;;;read licel first 5 head lines
          readf,1,hd
         ; print,hd
        endfor   ;h

       READF,1, DATAB


       AS[nc,*]=DATAB[0,*];  Take analog data
       ;PS[j,*]=DATAB[1,*]; photon counting data
      close,1

      nc=nc+1

  ENDFOR; I

      close,1




   ;AS3=fltarr(NF/(2*m0),bnum)
    J=0;          count file Separate parall and perpendicular channels
    for k=0,NF-2,2 do begin; alternative PLL/PPD
     AS1[J,*]=AS[k,*]
     AS2[J,*]=AS[k+1,*]


     J=J+1
    endfor; k

  ;;;*******plot profiles;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; average process

     AS12=AS1+AS2;
    j2=0


  ;;;************* average M0 ********************
 read,M0,prompt='Number of files to average (eg 5) :'
 M5=fix(NF/(2*m0))
 AS1M=fltarr(m5,bnum)
 AS2m=fltarr(m5,bnum)


;FOR i5=1, NF/2-M0,M0 do begin; % average 5 profiles
  FOR I2=1,M5 DO BEGIN
      AS1m[i2-1,*]=total(AS1[i2*5-5:i2*5-1,*],1)/5;
      AS2m[i2-1,*]=total(AS2[i2*5-5:i2*5-1,*],1)/5;


 endfor;  I2


 ;ENDFOR ; i5

stop

;********************** AV 5 end *****************

    ;
  ; FOR i=0 , NF/2-1, m0 do begin; average 5 profiles

     ;For jy=0,bnum-1 do begin ;sum 5

      ; AS3[J2,jy]=MEAN(AS3[i:i+m0-1,jy])
     ; AS1[j2,jy]=(AS1[i,jy]+AS1[i+1,jy]+AS1[i+2,jy]+AS1[i+3,jy]+AS1[i+4,jy])/m0

    ;ENDFOR  ;jy
   ;j2=j2+1

    ;print,i,J2
   ;ENDFOR; i
;;;;;;;;;;;;;***********************;;;;;;;;;;;;;;;;;;;;;;;;
!p.multi=[0,1,1]
 ;plot_position1 = [0.1,0.15, 0.40,0.95]; plot_position=[0.1,0.15,0.95,0.45]
; plot_position2 = [0.6,0.15,  0.90,0.95]; plot_position2=[0.1,0.6,0.95,0.95]
AS1_mean=TOTAL(AS1m,1)/M0
 max1=max(AS1_MEAN)
AS2_mean=TOTAL(AS2m,1)/M0
 max2=max(AS2)
plot,AS1_mean/max1,Ht,color=2,background=-2,xrange=[0,5],yrange=[h1,h2],position=plot_position1

for L1=0,m5-1 do begin
oplot,AS1m[L1,bn1:bn2]/max1+L1/5.,ht[bn1:bn2],color=50
endfor
stop
window,1
plot,AS2_mean/max2,Ht,color=2,background=-2,yrange=[h1,h2],position=plot_position2
for L2=0,m5-1 do begin
oplot,AS2m[L2,bn1:bn2]/max2+L2/10.,ht[bn1:bn2],color=50
endfor

stop
;;;***** plot PPR2 profile *********************
P1=total(As1m,1);
P2=total(AS2m,1)
BK1=mean(P1[3500:3990])
BK2=mean(P2[3500:3990])
PR1=(P1-bk1)*Ht^2
PR1=PR1-min(PR1); remove negative
PR2=(P2-bk2)*Ht^2
PR2=PR2-min(PE2)
 plot,Pr2Ht,xrange=[0,500],yrange=[0.2,5],color=2,background=-2,title='total AS1/AS2'
 oplot,pr1,Ht,color=120
stop
close,/all

end