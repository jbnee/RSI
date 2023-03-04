PRO NORMALIZATIN_LIDAR
 ;
   ns=1.0E-9   ;nanosecond
   c=3.0E8     ;speed of light

   ;;;;;;;INPUT SYSTEM PARAMETERS
  ; FOR st430 USE following data set

      BW=160.0  ;DZ=25 M
      bnum=1000  ; GIVE HEIGHT OF 24 KM
  ; For LICEL USE THE FOLLOWING
   ;   BW=50        ;DZ=7.5 M
    ;  bnum=4000     HEIGHT TO 30 KM
   ;;;;;;;;;;;;;;;;;;;;;;;;;
   dz= BW*ns*(c/2)/1000  ;increment in height in km
   ht=findgen(bnum)*dz  ; height in km
   dz1000=dz*1000 ;in meter

   ;;;;;;;;;;;;;;READ DATA;;;;;;;;;;;;;;
   ;T=findgen(bnum)
    READ,YEAR,PROMPT='INPUT YEAR AS 2005:'
 yr=string(year,format='(I4.4)')
;file_basename1='f:\Lidar_data\2009\ja\';  \se\se010044.'
 dnm=''
  Read, dnm, PROMPT='Enter filename dnm as ja152233;'   ; Enter date+code
  month=strmid(dnm,0,2)
  fnm=strmid(dnm,0,4);

read,n1,n2, prompt='Initial and file number as 1,99: '

read,h1,h2, prompt='height range in km 1,6 km,,,,'
bn1=round(h1/dz)  ;STARTING BIN
bn2=round(h2/dz)  ;ENDING BIN
dbn=bn2-bn1  ;        ;BIN RANGE
  nx=n2-n1+1          ;NUMBER OF FILES
 s1=strtrim(fix(n1),2)
 s2=strtrim(fix(n2),2)
 S='                                       file:'+s1+'_'+s2

  pr2m=fltarr(nx,bnum)
  Npr2m=fltarr(nx,bnum) ; NORMALIZED PR2M
  pr2d=fltarr(nx,bnum)
  Npr2d=fltarr(nx,bnum)  ;NORMALIZED PR2D

   bk1=fltarr(nx)
   bk2=fltarr(nx)

 ;  !P.multi=[0,1,2]
 ;  P1 = [0.1,0.15,0.98,0.49]; plot_position=[0.1,0.15,0.95,0.45]
 ;  P2 = [0.1,0.6,0.98,0.94]; plot_position2=[0.1,0.6,0.95,0.95]

   ;!P.MULTI = [0,2,2]
   ; plot_position1 = [0.1,0.15,0.48,0.45]; plot_position=[0.1,0.15,0.95,0.45]
   ;plot_position2 = [0.52,0.15,0.98,0.45]; plot_position2=[0.1,0.6,0.95,0.95]
  ; plot_position3=[0.1,0.6,0.48,0.94]
   ;plot_position4=[0.52,0.6,0.98,0.94]

   cnt_sig1=fltarr(2*bnum)
   cnt_sig2=fltarr(2*bnum)
   fbk=fltarr(NX)  ;   normalization file
   sig1=fltarr(NX,bnum)
   sig2=fltarr(NX,bnum)
   bk1=fltarr(NX,bnum)  ; background
   bk2=fltarr(NX,bnum)
   ;sig2=fltarr(nx-1,bnum)
   data_path='f:\lidar_data\
   out_path='f:\lidar_data\TEST\'
   close,/all



;;;;;;;;;;;;NORMALIZATION OF D/M SIGNALS ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   For NJ=0,nx-1  do begin  ;1st For ; automatically read as many files
     jf=n1+NJ ;file index starting from n1
      ni=strcompress(fix(jf),/remove_all)
    fn1=Data_path+yr+'\'+month+'\'+dnm+'.'+ni+'m'
    fn2=Data_path+yr+'\'+month+'\'+dnm+'.'+ni+'d'

    openr,1,fn1;
     ; readf,1,cnt_sig1;[NJ,*]  ; LICEL ASCII M FILE
     ; readf,1,cnt_sig2         ; LICEL D FILE
     cnt_sig1=read_binary(fn1, DATA_TYPE=2)  ; SR430 binary M fILE
     CNT_SIG1=CNT_SIG1[0:BNUM-1]

     cnt_sig2=read_binary(fn2, DATA_TYPE=2)  ; SR430 binary M fILE
     CNT_SIG2=CNT_SIG2[0:BNUM-1]

    close,1

    bk1[NJ]=mean(cnt_sig1[bnum-200:bnum-1]);m-BACKGROUND TAKE LAST 200 DATA
    mn1=mean(bk1)                          ;TAKE MEAN
    bk2[NJ]=mean(cnt_sig2[bnum-200:bnum-1]) ;D-BACKGROUND
    mn2=mean(bk2)                            ;TAKE MEAN
    fbk[NJ]=(mn2/mn1)/0.014;;;NORMALIZATION FACTOR 10:12 KM,0.014 IS THE RAYLEIGH

    sig1[NJ,BN1:BN2-1]=cnt_sig1[bn1:bn2-1]-bk1[NJ]

    sig2[NJ,BN1:BN2-1]=cnt_sig2[bn1:bn2-1]-bk2[NJ]
   ENDFOR ; NJ
   STOP
   WINDOW,0,XSIZE=400,YSIZE=400,TITLE='PARALLEL'

   FOR I1=0,NX-1 DO BEGIN
     IF (I1 EQ 0) THEN BEGIN
       PLOT,SIG1[I1,BN1:BN2-1],HT,COLOR=2,BACKGROUND=-2 ,YRANGE=[H1,H2],TITLE='M CHANNEL'

     ENDIF ELSE BEGIN
       OPLOT, SIG1[I1,BN1:BN2-1],HT, COLOR=24;

    ENDELSE

   ENDFOR ;I1
   STOP
   WINDOW,1,XSIZE=400,YSIZE=400,TITLE='PERPENDICULAR'
   FOR I2=0,NX-1 DO BEGIN

     IF (I2 EQ 0) THEN BEGIN

       PLOT,SIG2[0,BN1:BN2-1],HT,COLOR=2,BACKGROUND=-2, YRANGE=[H1,H2],TITLE='d channel'

     ENDIF ELSE BEGIN

       OPLOT, SIG2[I2,BN1:BN2-1],HT, COLOR=100;,POSITION=P2

    ENDELSE
   ENDFOR ;I2

   STOP
       ;pr2m[NJ,bn1:bn2-1]=smooth(sig1,10)*ht^2

    ;pm=where(pr2m[NJ,bn1:bn2] LT 0)

    ;pr2d[NJ,bn1:bn2-1]=smooth(sig2,10)*ht^2
    ;pd=where(pr2d[NJ,bn1:bn2] LT 0)
    ;print,NJ,PM,PD

stop
; !P.multi=[0,1,1]
     WINDOW,3,XSIZE=400,YSIZE=400,TITLE='NORMALIZATION'
    plot,fbk,COLOR=2,BACKGROUND=-2,XRANGE=[0,NX-1]
    PRINT,'MEAN NORMALIZATION FBK: ',MEAN(FBK[0:NX-1])
    stop
    end