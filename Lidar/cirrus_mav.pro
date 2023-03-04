
Pro cirrus_mAV
;plot only m file: parallel polarization
;Average for 5 profiles -----------------------------
;start with a colour table, read in from an external file hues.dat

;path='d:\Lidar systems\Raman lidar\20090314\H2O\
; path='d:\Lidar systems\Rayleigh\2001\se\'; se120212
;openr,1,"d:\LidarPro\DATA\Rayleigh\1999\FE\Fe092341.2R"
 read,year, prompt='year as 2003: ?  '
 yr=string(year,format='(I4.4)')
 month=''
 read,month,prompt='month:ja,fe,mr,ap,ma,jn....? '
 bpath='d:\Lidar systems\Rayleigh\'
 fpath=bpath+yr+'\'+month+'\'
 ;path='d:\LidarPro\Depolar\2004\mr\mr041947.'  ;072150.' ;202312.'; 312023.'; mr192028.' ;mr312023.'
dnm=''
 read,dnm,prompt='data filename as mr022018    ???'
 ;file_basename1='d:\LidarPro\Depolar\2004\ap\ap022014.' ;
 fnm=fpath+dnm+'.'
;資料夾輸入:
;file_basename1='d:\LidarPro\Data\2002mr\';mr312023.'  ;072150.' ;202312.'; 312023.'; mr192028.' ;mr312023.'

fn1=''
; 資料檔輸入
;read,fd,prompt='data file such as mr182309'
;fx=path+fd+'.'
read,ni,nf, prompt='Initial and last file number as 1,99: '
  nx=nf-ni+1
 s1=strtrim(fix(ni),2)
 s2=strtrim(fix(nf),2)
 S='                                       file:'+s1+'_'+s2
;read,h1,h2,prompt='Initial and final height as ,1,5 km:'
  h1=10
  h2=20
  T=findgen(1000)
  pr2m=fltarr(nx,1000)
  pr2d=fltarr(nx,1000)
  ht=3.0E8*160.E-9*T/2./1000.   ;convert ht to km
   ht1=ht[0:999]
  ; !P.MULTI = [0,1,2]
  ; plot_position1 = [0.1,0.15,0.98,0.49]; plot_position=[0.1,0.15,0.95,0.45]
  ; plot_position2 = [0.1,0.6,0.98,0.94]; plot_position2=[0.1,0.6,0.95,0.95]
    j=0
   ;fn1=fnm+strtrim(sn,2)+'m'
    fn1=fnm+strtrim(fix(ni),2)+'m'
    datab=read_binary(fn1,DATA_TYPE=2)
    ; datab=read_ascii(fn1)
    sig=datab[0:999]
    pr2m[j,*]=smooth(sig,10)*ht^2
    maxa=max(Pr2m[j,*])

    dv=maxa/nx
    plot,pr2m[j,*],ht1,background=-2,color=2,xrange=[0,2*maxa],yrange=[h1,h2],xtitle='m channel',ytitle='km' ;title=S

   ;stop
   j=1

   FOR n=ni+1,nf do begin

   sn=strtrim(fix(n),2)
  ;ln=strlen(sn)

   fn1=fnm+strtrim(sn,2)+'m'

   datab=read_binary(fn1,DATA_TYPE=2)
   sig1=datab[0:1999]
   sig=smooth(sig1,10)
   pr2m[j,*]=sig*ht^2
   ;oplot,sig+50*j,ht1, color=2 ;background=-2,color=1,xtitle='Signal/channel',ytitle='km'
  ; oplot,pr2m[j,*]+dv*j,ht1,color=2;
   j=j+1
  ;xyouts,1000+300*n,30,n,color=1,charsize=1
  ENDFOR
  Tpr2m=transpose(Pr2m)
  stop
  ;Av5pr2m=total(Tpr2m,2)/5.
  n5=round((nf-ni+1)/5)
  AV5=fltarr(n5,1000)
  k5=0
  for k=0,n5-1 do begin
  ; k5=k/5
   AV5[k5,*]=(Tpr2m[*,k]+Tpr2m[*,k+1]+Tpr2m[*,k+2]+Tpr2m[*,k+3]+Tpr2m[*,k+4])/5.
   oplot, AV5[k5,*]+500*k5,ht1, color=2
   k5=k5+1
  endfor

 ;;;;;;;;;;;;;;d file;;;;;;;;;;;;;;;;;;
stop
plotname =bpath+'cirrus_plot\'+dnm+'.bmp'
WRITE_bmp, plotname, TVRD()
end



 ; write_bmp,"d:\lidarPro\depolar\filename.bmp",tvrd()
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

