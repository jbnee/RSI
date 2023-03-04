Pro Raman_Licel
;Note:  Raman data has no d channel
;path='d:\LidarPro\Raman2009\MR0314\'
close,/all


fnm=''

read,fnm,prompt='data file such as mr142041'
mn=strmid(fnm,0,2)
;read,mn,prompt='input month:  as mr,ap,..'
bpath='f:\lidar_data\2008_9_Raman\MCA_N2\2009\'
;bpath='f:\lidar_data\2008_9_Raman\MCA_H2O\2008\'
read,ni,nf, prompt='Initial and last file number as 1,10 (max 10) '

read,h1,h2,prompt='Initial and final height as ,1,10 km:'

fx=bpath+mn+'\'+fnm+'.'
T=findgen(4000)
sig1=fltarr(4000)
;ht=7.5*T
;  ht=3.0E8*160.E-9*T/2./1000.+0.001   ;convert ht to km and remove 0
   ht1=24*T/1000  ; ht in km with resoluton 24 m; licel 7.5m
  nx=nf-ni+1
 s1=strtrim(fix(ni),2)
 s2=strtrim(fix(nf),2)
 S=fnm+'                                       file:'+s1+'_'+s2;used to print title
sigxm=fltarr(nx,2000)
sigxd=fltarr(nx,2000)
  pr2m=fltarr(nx,2000)
  pr2d=fltarr(nx,2000)

   !P.MULTI = [0,1,2]
   plot_position1 = [0.1,0.15,0.98,0.49]; lower part plot_position=[0.1,0.15,0.95,0.45]
  plot_position2 = [0.1,0.6,0.98,0.94]; upper part; plot_position2=[0.1,0.6,0.95,0.95]

  fn1=fx+strtrim(fix(ni),2)+'m'
  ;

  dataM=read_binary(fn1,DATA_TYPE=2);reading SR430
    sig1=dataM[0:1999]

    ;pr2m[j,*]=smooth(sig1,10)*ht^2
     sigsm=smooth(sig1,10)
     maxa=max(sigsm)
    ;maxa=max(Pr2m[j,*])
     mina=min(sigsm)
    dv=maxa/nx
   ;plot,pr2m[j,*],ht1,background=-2,color=2,position=plot_position1,xrange=[0,1*maxa],yrange=[h1,h2],xtitle='m channel',ytitle='km' ,title=S

    plot,sigsm-mina,ht1,background=-2,color=2,xrange=[mina,10*maxa],yrange=[h1,h2],xtitle='Raman channel',ytitle='km' ,$
    position=plot_position1,title=S
    close,1
    stop
    sigxm[0,*]=sigsm-mina
  ;free_lun,u
  ;get_lun, u

  j=1
  sum_m=0

FOR n1=ni+1,nf do begin

   sn=strtrim(fix(n1),2)
  ;ln=strlen(sn)

   fn1=fx+strtrim(sn,2)+'m'
 ;;;;;;reading licel files
  ; openr,2,fn1;/get_lun
  ; readf,2,sig1
 ;;;;;;;;;;licel end
   dataD=read_binary(fn1,DATA_TYPE=2);reading SR430
    sig2=dataD[0:1999]
   sigsm=smooth(sig2,10)-mina  ;smooth sig2

   sigxm[j,*]=sigsm[0:1999]
   sum_M=sum_m+sigxm[j,*]

   ;pr2m[j,*]=sig*ht^2
   ;oplot,sig+50*j,ht1, color=2 ;background=-2,color=1,xtitle='Signal/channel',ytitle='km'
  ; oplot,sigxm[j,*]+ 0.5*dv*j,ht1,color=2;
   oplot,sigxm[j,*]+j*nf*50,ht1,color=2
  ; wait,2
   j=j+1
  ;xyouts,1000+300*n,30,n,color=1,charsize=1
    close,2
  ENDFOR
  stop
 ;!P.MULTI = [0,1,1]
  plot,Sum_M,ht1,color=2,xrange=[mina, nx*maxa],yrange=[h1,h2],xtitle='sum Ramam channel',ytitle='km' ,$
    position=plot_position2,title=S
    opath=bpath+'output\'
stop
    m_file=opath+fnm+'M_Raman.txt'
    m_image=opath+fnm+'_M_Raman.bmp'
    openw,3,m_file
    printf,3,sum_m
    write_bmp,m_image,tvrd()
   close,3
  ;free_lun,u
 ; close,lun
  close,/all




 stop
 end
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
