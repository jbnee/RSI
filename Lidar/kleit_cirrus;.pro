Pro Kleit_cirrus
; In the first part we will read data and plot;
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
   dht=bT*ns*c/2  ;increment in height is dht=24 m

  close,/all
  Data_path="D:\Lidar_systems\LidarPro\Rayleigh\";  2003\jn022058\jn022058.4M""   ; AUR or SPR

  yrmn='';   year\month
  Read,yrmn, prompt='Enter director Year, month as 2003\JN\:  '
  dirnm=data_path+yrmn
   out_path="D:\lidar_systems\lidarPro\output\yrmn"

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
  read,h1,h2,prompt='Height range from h1 to h2:  '
  bin1=ceil(h1/0.024)
  bin2=ceil(h2/0.024)

  ;binN=bnum;   The total number of bins of data considered here for 30 km
  ;ht=(dht/1000)*findgen(bnum);   Height in km
  ht1=findgen(1250)*0.024
  ht=ht1[bin1:bin2]
   ;Rkm=3.0E5*bT*1.E-9*c/2.   ;Range in km
  ; cnt_sig=uintArr(bnum);uintarr(bnum); bytarr(bnum)
   sg=fltarr(n2-n1+1,bnum)
   multp=0
   sumsg=0
  For Jr=1,n2-n1+1  do begin  ;1st For ; automatically read as many files
     jf=n1+jr-1
     multp=multp+Jr*100
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
     plot,sg[jr-1,*],ht1,background=-2, color=3,yrange=[10,30];,xrange=[1,50000]
     ;xyouts,2000,15,'file 1',color=2
     endif else begin
     oplot,sg[jr-1,*]+multp,ht1,color=2;
     xyouts,500,25,'Signal Files',color=2
   endelse
   endfor
 stop  ; section 1

;
;Part II Backscattering coefficient calculation below 30 km (1250 bin)
; based on Fernald 1984

    Sa=30; lidar ratio  ;for aerosol
    Sr=8*!pi/3; lidar ratio for air
    IZ1= 1000           ;top beam at 30 km which is 1250
   X=fltarr(n2-n1+1,Iz1+1) ;PR2
   x1=fltarr(n2-n1+1)
   beta1=fltarr(n2-n1+1)
   Integ_r=fltarr(1251)
   Int_X=fltarr(n2-n1+1,1251)
   A=fltarr(1251)
   bottom=fltarr(1251)
   density=fltarr(bnum+1);air density
   beta_r=dblarr(bnum+1) ;backscattering coefficient of air
   beta_a=dblarr(n2-n1+1,1251)  ;backscattering coefficient of aerosol
   bratio=fltarr(n2-n1+1)

;;;;;;;; density of air is the polynomial fit of height determined from radiosonde
    density= 1.E25*(2.4498-0.22114*ht1+0.00701*ht1^2-7.75225E-5*ht1^3)  ;ht in km; in molec/m3
    beta_r=5.45E-32*(550./532.)^4*density  ;Rayleigh backscattering coefficient

 ;;;;;;;;;integral of A:beta_a;;;;;;;;;;;;;;;;

   For na=1,1000 do begin  ;integral of beta_r from z1 (30 km) to Z (10km)
     ;na=0 correspond to 30 km, na=1249 to 0 km
    ;Integ_r=qsimp('b_Rayleigh',Iz1-1,Iz1-na)*24
     Integ_r[na]=24*(beta_r[iz1-na]+beta_r[iz1-na+1])/2  ;na=0 for 30 km and downward
     A[na]=-2*(Sa-Sr)*Integ_r[na]
   endfor
 stop
    ;;;;;;;Integral of X
    For nj=0,n2-n1  do begin  ;file of starting file n1 to last file n2
       x1[nj]=sg[nj,Iz1]*(ht1[Iz1]^2)
       beta1[nj]=.5*beta_r[iz1]
      For Iz=Iz1,100,-1 do begin   ;calculation start from Izt=30 km
        ;ht=0.024*Iz
        X[nj,Iz]= sg[nj,Iz]*(ht1[Iz]^2)*exp(-A[Iz]);  ^2/TO3   ;PR^2

        Int_X[nj,Iz]=(0.024/2.)*(x[nj,Iz]+x[nj,Iz-1]);integration

       bottom[Iz]=(x1[nj]/beta1[nj])-2*Sa*Int_X[nj,Iz]
       beta_a[nj,Iz]=X[nj,Iz]/bottom[Iz]
      ;print,nj,iz,beta_a[nj,Iz]
      ;plot,beta_a[nj,*],ht,background=-2,color=1
      ;wait,1
     endfor  ;integral of z from z1 to z

    endfor   ;nj
    ;stop

    ;plot,beta_a[0,100:izt-100],ht[100:1150],background=-2,color=1,xtitle='beta_a'

    ;plot,beta_a[0,100:iz1],ht[100:iz1],background=-2,color=1,xtitle='beta_a'
    plot,beta_a[0,bin1:bin2],ht,background=-2,color=1,xtitle='beta_a'
;;;;;;*****************************************************
  stop; section III

     For k=0,n2-n1 do begin

      ; oplot,beta_a[k,100:iz1],ht[100:Iz1],color=2
       oplot,beta_a[k,bin1:bin2],ht,color=2
      endfor ;k


      stop  ;IIC
      sumratio=0

       For L=0,n2-n1 do begin
          ratio=1+beta_a[L,0:1249]/beta_r[0:1249]
           if (L eq 0) then begin
               plot,ratio,ht,background=-2,color=2
           endif else begin
              oplot, ratio+10*L,ht, color=3
           endelse
           sumratio=sumratio+ratio
       endfor
       stop ;secion IIB



     oplot,sumratio/(n2-n1+1),ht,color=1
     stop    ;Section III
    ; write_bmp,out_file,tvrd()
     end

