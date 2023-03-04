 Pro Klett_slope1
; In the first part we will read data and plot;
; In the second part, we will process signal according to slope method in Klett 81
;Part I read data
 ; read,bnum, prompt='Enter total number bins (eg.4096)  '
  bnum=4096  ;bin number wanted
  bn=fltarr(bnum); bin array of 1250 for 1250*0.024=30km
  ITz1=fltarr(bnum)
  ITz2=fltarr(bnum)
  beta_r=fltarr(bnum) ;Rayleigh backscattering coefficient
  ht=fltarr(bnum)
  ;constants  for the program
   bT=160      ;160 ns for SR430 bin width
   ns=1.0E-9   ;nanosecond
   c=3.0E8     ;speed of light
   dht=bT*ns*c/2  ;  increment in height is dht=24 m

  close,/all
  Data_path="D:\Lidar systems\LidarPro\Rayleigh\";  2003\jn022058\jn022058.4M""   ; AUR or SPR

  yrmn='';   year\month
  Read,yrmn, prompt='Enter director Year, month as 2003\JN\:  '
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
  ht=dht*findgen(bnum)/1000.  ;heitht in km
  htm=ht*1000; ht in meter
   ;Rkm=3.0E5*bT*1.E-9*c/2.   ;Range in km
  ; cnt_sig=uintArr(bnum);uintarr(bnum); bytarr(bnum)
   sg=fltarr(n2-n1+1,bnum)
   fmultp=0
   sumsg=0
  For Jr=1,n2-n1+1  do begin  ;1st For ; automatically read as many files
    jf=n1+jr-1
     fmultp=fmultp+Jr*100  ;multiplier factor
    ni=strcompress(jf,/remove_all)
     ; ni=strcompress(Jr,/remove_all)

    fn=dirnm+filecode+'.'+ni+'m'                                   ;+Dtype ;
    out_file=data_path+'out_'+ni+'.'+'bmp'
     ;openr,1,data_file;

    cnt_sig=read_binary(fn, DATA_TYPE=2)  ; cnt_sig  ;read binary file
    close,1

    bk=median(cnt_sig[bnum-500:bnum-1]);  the last 500 bin data as the background
    sg[Jr-1,*]=smooth(cnt_sig,5)-bk  ;   smooth signal
        ;sg[Jr-1,*]=LEEFILT(cnt_sig,5)-bk ;use LEE filter
         ; sumsg=sumsg+sg

     if (Jr eq 1) then begin
     plot,sg[jr-1,*],ht,background=-2, color=3,zrange=[0,10000],yrange=[10,20]; plot the first profile
     ;xyouts,2000,15,'file 1',color=2
     endif else begin
     oplot,sg[jr-1,*]+fmultp,ht,color=2;   plot the rest files
     xyouts,10000,25,'Signal Files',color=2
   endelse
   endfor

 stop  ; 1 section 1

; Rayleigh coefficient
;;;;;;;; density of air is the polynomial fit of height determined from radiosonde
   ;1atm=1013.0 hPa ;density=(P(hpa)*100*6.023E23/(8.314*295)
  ; pr= 1005.99-0.112231*htm +4.99520e-006*htm^2-1.07087e-010*htm^3+ (9.60139e-016)*htm^4; pressure from radiosonde
   ;density=pr*100*6.023E23/(8.314*298)
    density= 1.E25*(2.4498-0.22114*ht+0.00701*ht^2-7.75225E-5*ht^3)  ;ht in km; in molec/m3
    beta_r=5.45E-32*(550./532.)^4*density  ;Rayleigh backscattering coefficient

   ;stop
;Part II SLOPE method here Backscattering coefficient calculation below 30 km (1250 bin)
;
    Sa=30.  ;lidar ratio
    IZ1= 1250             ;top beam at 30 km which is 1250
   X=fltarr(n2-n1+1,Iz1+1) ;  PR2
   XX=fltarr(IZ1+1)
   beta_a=fltarr(n2-n1+1,IZ1+1)
   beta0=beta_r[IZ1]
   A=fltarr(1251)
   bottom=fltarr(1251)
   z=htm[0:1250]
   ;dsdz=fltarr(n2-n1+1)
stop  ;2
  ;;;;;;slope differential
  ;;;;;;;differential of X
    For nj=0,n2-n1  do begin  ;file of starting file n1 to last file n2
      For m=0,Iz1 do begin  ; start to do one profile
       X[nj,m]=sg[nj,m]*(z[m]^2)/sg[nj,IZ1]*(z[IZ1]^2); PR^2
       ;beta_a[nj]=.5*beta_r[iz1]   ;initial condition to set beta_a

      endfor ;m
      XX[0:Iz1]=x[nj,0:Iz1]   ; profile of PR^2 for njth file
      ;dsdz=deriv(z,xx)
      beta_a[nj,*]=smooth(abs(-1./(2.*SA*(deriv(z,xx))))/beta0,5)

      endfor   ;nj
      plot,beta_a[0,100:iz1],ht[100:iz1],background=-2,color=1,xtitle='beta_a'
;;;;;;*****************************************************
  stop; section III

     For k=0,n2-n1 do begin

       oplot,beta_a[k,100:iz1],ht[100:Iz1],color=2

      endfor ;k

 ;;;;;;;;;integral of A:beta_a;;;;;;;;;;;;;;;;


      sumratio=0

       For L=0,n2-n1 do begin
          ratio=1+beta_a[L,0:1250]/beta_r[0:1250]
           if (L eq 0) then begin
               plot,ratio,ht,background=-2,color=2,xrange=[0,10],yrange=[15,20]
           endif else begin
              oplot, ratio+L,ht, color=3
           endelse
           sumratio=sumratio+ratio
       endfor
       stop ;secion IIB



     oplot,sumratio/(n2-n1+1),ht,color=4
     stop    ;Section III
    ; write_bmp,out_file,tvrd()
     end

