Pro LicelAerosol

path='d:\Lidar systems\Raman lidar\20090314\Licel0314\'
close,/all
fd=''
fn=''
T=findgen(4000)
  sig1=fltarr(4000)
;ht=7.5*T
;  ht=3.0E8*160.E-9*T/2./1000.+0.001   ;convert ht to km and remove 0
   ht1=7.5*T/1000  ; ht in km with resoluton 7.5m
read,h1,h2,prompt='Initial and final height as ,1,5 km:'
read,fd,prompt='data file such as mr182309'
fx=path+fd+'.'
read,ni,nf, prompt='Initial and last file number as 1,99: '
  nx=nf-ni+1
 s1=strtrim(fix(ni),2)
 s2=strtrim(fix(nf),2)
 S='                                       file:'+s1+'_'+s2;used to print title
sigx=fltarr(nx,4000)
sigxd=fltarr(nx,4000)
  pr2m=fltarr(nx,4000)
  pr2d=fltarr(nx,4000)

   !P.MULTI = [0,1,2]
   plot_position1 = [0.1,0.15,0.98,0.49]; plot_position=[0.1,0.15,0.95,0.45]
  plot_position2 = [0.1,0.6,0.98,0.94]; plot_position2=[0.1,0.6,0.95,0.95]

   ;fn1=fx+ '1m'
  fn1=fx+strtrim(fix(ni),2)+'m'
   ; datab=read_binary(fn1,DATA_TYPE=2)
 ;  stop
  openr,1,fn1
  readf,1,sig1

   ; sig=datab[0:999]
    ;pr2m[j,*]=smooth(sig,10)*ht^2
     sigsm=smooth(sig1,10)
     maxa=max(sigsm)
    ;maxa=max(Pr2m[j,*])
     mina=min(sigsm)
    dv=maxa/nx
   ;plot,pr2m[j,*],ht1,background=-2,color=2,position=plot_position1,xrange=[0,1*maxa],yrange=[h1,h2],xtitle='m channel',ytitle='km' ,title=S
    plot,sigsm-mina,ht1,background=-2,color=2,xrange=[0, maxa],yrange=[h1,h2],xtitle='m channel',ytitle='km' ,$
    position=plot_position1,title=S
    close,1
    stop
  ;free_lun,u
  ;get_lun, u
  j=0
FOR n1=ni+1,nf do begin

   sn=strtrim(fix(n1),2)
  ;ln=strlen(sn)

   fn1=fx+strtrim(sn,2)+'M'

   openr,2,fn1;/get_lun
   readf,2,sig1
   sigsm=smooth(sig1,10)
   ;datab=read_binary(fn,DATA_TYPE=2)
   sigx[j,*]=sigsm[0:3999]-mina


   ;pr2m[j,*]=sig*ht^2
   ;oplot,sig+50*j,ht1, color=2 ;background=-2,color=1,xtitle='Signal/channel',ytitle='km'
   oplot,sigx[j,*]+ 2*dv*j,ht1,color=2;
   j=j+1
  ;xyouts,1000+300*n,30,n,color=1,charsize=1

  close,2
  ENDFOR
  ;free_lun,u
 ; close,lun
  close,/all

  stop
 ; plot d channel below

  sig2=fltarr(4000)
  sigsm2=fltarr(4000)
 fn2=fx+strtrim(fix(ni),2)+'D'
 openr,2,fn2
 readf,2,sig2
  sigsm2=smooth(sig2,10)
  maxb=max(sigsm2)
  minb=min(sigsm2)
  dv=maxb/nx

   ;plot,pr2m[j,*],ht1,background=-2,color=2,position=plot_position1,xrange=[0,1*maxa],yrange=[h1,h2],xtitle='m channel',ytitle='km' ,title=S
    plot,sigsm2-minb,ht1,background=-2,color=2,xrange=[minb, maxb],yrange=[h1,h2],xtitle='d channel',ytitle='km' ,$
    position=plot_position2,title=fd
    close,2
   J2=1
    stop
FOR n2=ni+1,nf do begin

   sn=strtrim(fix(n2),2)
  ;ln=strlen(sn)
   fn2=fx+strtrim(sn,2)+'d'
   ;get_lun,u2
   openr,3,fn2;/get_lun
   readf,3,sig2
   sigsm2=smooth(sig2,10)
   ;datab=read_binary(fn,DATA_TYPE=2)
   sigxd[j2,*]=sigsm2[0:3999]-minb


   ;pr2m[j,*]=sig*ht^2
   ;oplot,sig+50*j,ht1, color=2 ;background=-2,color=1,xtitle='Signal/channel',ytitle='km'
   oplot,sigxd[j2,*]+2*dv*j2,ht1,color=2;
   j2=j2+1
  ;xyouts,1000+300*n,30,n,color=1,charsize=1
  ;free_lun,u2
   close,3
  ENDFOR
  ;
  stop

  write_bmp,"d:\lidar systems\Raman lidar\"+fd+".bmp",tvrd()
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
