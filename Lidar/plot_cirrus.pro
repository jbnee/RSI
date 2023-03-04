Pro Plot_cirrus
;device, decomposed=0

!p.multi=[0,1,2]

 plot_position1 = [0.1,0.15,0.93,0.49]; plot_position=[0.1,0.15,0.95,0.45]
 plot_position2 = [0.1,0.6,0.93,0.95]; plot_position2=[0.1,0.6,0.95,0.95]

 read,year, prompt='year as 2000: ?  '
 yr=string(year,format='(I4.4)')
 month=''
 read,month,prompt='month:ja,fe,mr,ap,ma,jn....?DE   '
 bpath='d:\Lidar_systems\Lidarpro\Depolar\'
 fpath=bpath+yr+'\'+month+'\'
 ;path='d:\LidarPro\Depolar\2004\mr\mr041947.'  ;072150.' ;202312.'; 312023.'; mr192028.' ;mr312023.'
    dnm=''
 read,dnm,prompt='data filename as de062148'
  ;file_basename1='d:\LidarPro\Depolar\2004\ap\ap022014.' ;
 fnm=fpath+dnm+'.'

 read,ni,nf, prompt='Initial and file number as 1,99: '
 read,mav,prompt='how many files to add to average: '
 read,h1,h2, prompt='height range as,10,30:  '

  NX=nf-ni-1
  j=0
  T=findgen(8192)
  pr2m=fltarr(nx+1,2000)
  pr2d=fltarr(nx+1,2000)
  ht=3.0E8*160.E-9*T/2./1000.   ;convert ht to km
   ht1=ht[0:1999]; ht1{500]=12 km, ht[1000]=24 km
 FOR n=ni,nf do begin
   sn=strtrim(fix(n),2)
   fn1=fnm+strtrim(sn,2)+'M'; 'A'

   datab=read_binary(fn1,DATA_TYPE=2)
   sig=datab[0:1999]
   pr2m[j,*]=sig*ht^2
   x=findgen(nx)
   y=ht1
   while (j LE nx-1) do begin
   j=j+1
   endwhile
  ENDFOR; n
  SZ=size(pr2m)
  print,sz
   dz=0.024
   bn1=ceil(h1/dz)
   bn2=ceil(h2/dz)
;;;;;;below is the average;;;;
    G=indgen(mav)
    IG=ceil(Nx/mav)
    Apr2m=intarr(IG,2000)
    Apr2d=intarr(IG,2000)
    sum=intarr(IG,2000)
 ;stop
  For JG=0,IG-1  do begin
  sum1=0
 ; print,'JG: ',JG,sum1
  ;stop
    For J1=0,mav-1 do begin
     XJ=J1+JG*mav
     print,XJ,sum1
    ;while (XJ LT SZ(1)) do begin
     sum1= Pr2m[xJ,*]+sum1
    ;endwhile
     ; print,xj
    Endfor  ;J1

    Apr2m[JG,*]=smooth(sum1,10)/mav
    ;print,"-------------------"
   endfor;JG
;endfor; jj
plot,ht[bn1:bn2],Apr2m[0,bn1:bn2], xtitle='km',ytitle='pr2',color=2, background=-2, position=plot_position1

for JJ=1, IG-1 do begin
 oplot,ht[bn1:bn2],APR2m[jj,bn1:bn2]
endfor; jj

 stop

 k=0

 FOR nd=ni+1,nf do begin
   sn=strtrim(fix(nd),2)
   fn2=fnm+strtrim(sn,2)+'D'  ;'B'
   datab=read_binary(fn2,DATA_TYPE=2)
   sig2=datab[0:1999]
   sigd=smooth(sig2,10)
   pr2d[k,*]=sigd*ht^2

   x=findgen(nx)
   y=ht1

   k=k+1

  ENDFOR
  ;sum=0
For KG=0,IG-1 do begin
sum2=0
   For K1=0,mav-1 do begin
     XK=K1+KG*mav
     sum2=Pr2d[xK,*]+sum2

    endfor  ;J1
    Apr2d[KG,*]=smooth(sum2,10)/mav

  endfor;KG
  plot,ht[bn1:bn2],Apr2d[0,bn1:bn2],xtitle='km', ytitle='PR2',color=2, background=-2, position=plot_position2
 for KK=1, IG-1 do begin
 oplot,ht[bn1:bn2],APR2d[kk,bn1:bn2], color=2
endfor; kk
  stop

  DEVICE, DECOMPOSED=0
  ;fnmc=''
  ;read,fnm,prompt='filename to output'
  cntrname =bpath+'cirrus\'+yr+dnm+'.png'

WRITE_png, cntrname, TVRD(/TRUE)

 end



 ; read,nx,prompt='which file number to process such as 5';

 ; write_bmp,"d:\lidar systems\lidarpro\Rayleigh\1993\93se010044.bmp",tvrd()
;;;;Rayleigh backscattering coefficient
;;;;;;;; density of air is the polynomial fit of height determined from radiosonde

   ; density= 1.E25*(2.4498-0.22114*ht1+0.00701*ht1^2-7.75225E-5*ht1^3)  ;ht in km; in molec/m3
   ; beta_r=5.45E-32*(550./532.)^4*density  ;Rayleigh backscattering coefficient
   ; xsray=(8*3.1416/3.)*beta_r   ;Rayleigh cross section
   ;kext=xsray                   ;Rayleigh extinction
   ; transm=exp(-2*kext)             ;atmosph transmission
   ; y=dblarr(1024)
   ; y=(sig[0:600]*ht1[0:600]^2)/(transm*beta_r); bin 200 is 4.8 km
   ; plot,y,ht1,background=-2,color=2;xrange=[0,10000],yrange=[5,40],xtitle='Signal/channel',ytitle='km'
   ; stop
    ;wait,2
   ;  plot,y[0:200]/y[300],ht1,background=-2,color=2

   ; stop
    ; bratio=fltarr(2,1250)
    ; bratio[1,100:1249]=transpose(y[100:1249]/y[600])
    ; bratio[0,100:1249]=transpose(ht1[100:1249])
    ; openw,2,'d:\lidar systems\lidarpro\Rayleigh\1993\Bratio93se010044_14.txt'
    ; printf,2,bratio
    ; close,2

 ;close,1
;end

