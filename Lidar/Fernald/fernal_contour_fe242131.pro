Pro Fernal_CONTOUR_fe242131
close,/all
; In the first part we will read data and plot;
; In the second part, we will process signal according to Fernald
;Part I Rayleigh calcution
 ; read,bnum, prompt='Enter total number bins (eg.4096)  '
   ;constants  for the program
   ;bT=160      ;160 ns for SR430 bin width

   ;ns=1.0E-9   ;nanosecond
   ;c=3.0E8     ;speed of light
    bnum= 4000  ;24 km
   dz=0.0075; km
   ;dz= bT*ns*(c/2)/1000  ;increment in height is dz=24 m
   ht=findgen(bnum)*dz  ; height in km
   dz1000=dz*1000 ;in meter
   z=ht*1000 ; in meter
  ;treat Rayleigh scattering

    bn=fltarr(bnum+1); bin array of 1250 for 1250*0.024=30km
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

     plot,beta_r,ht, background=-2,color=2,title='Rayleigh backscattering coefficient'$
     ,ytitle='km',xtitle='beta -m',position=plot_position1
     stop
  Sa=50; lidar ratio  ;for cirrus cloud
  Sr=8*!pi/3; lidar ratio for air
  kext=(8*3.1416/3.)*beta_r   ;Rayleigh extinction
 tau[bnum-1]=0
for j=bnum-2,0,-1 do begin
    tau[j]=tau[j+1]+(kext[j]+kext[j+1])*dz1000/2
    Tm[j]=exp(-2*tau[j])
 endfor
plot,tau,ht,color=2,background=-2,xtitle='opt,thick and transmission',xrange=[0,1],title='optical thickness',$
position=plot_position2

;xyouts,0.1,15, 'optical thickness'
oplot,Tm,ht,color=2; ,position=plot_position2,xrange=[0.75,1],ytitle='km',xtitle='opt,thickness';
xyouts,0.5,10,'atmospheric transmission'



stop
;Part 2 Read data
  close,/all

  Data_path="E:\lidar_data\";\Lidar_systems\LidarPro\DePolar\";  2003\jn022058\jn022058.4M""   ; AUR or SPR

  year=''
  ;Read,year,  prompt='Enter  Year as 2003: '
   year=2009
  yr=strtrim(year,2);  remove white space


  event=0
  ;RB=fltarr(16,30)  ; output file type
  ;dnm=''
  dnm='fe242131'
  fnm=strmid(dnm,0,4)
  ;Read, dnm, PROMPT='Enter filename dnm as ja162136;'   ; Enter date+code
   fnm=strmid(dnm,0,4)
  month=strmid(dnm,0,2)
  n1=20
  n2=100
 ; READ,n1, n2, PROMPT='Intial and final records;eg.10,100 129: '
  n1=fix(n1)
  n2=fix(n2)
  nx=n2-n1+1
  ;m0=5  ;number of data to average usually 5

  F1=strtrim(fix(n1),2)
  F2=strtrim(fix(n2),2)
  FS='                file:'+F1+'_'+F2;used to print title
  Ftitle=yr+dnm

  sg=fltarr(nx,bnum)

  cnt_sig=fltarr(bnum)
   sumsg=0
  PR2M=fltarr(n2-n1+1,bnum) ;average 5 PR2
  PR2D=fltarr(n2-n1+1,bnum)

  read,h1,h2,prompt='height region as 1, 6 km  '

   !p.multi=[0,1,2]
   plot_position1 = [0.1,0.15,0.90,0.49]; plot_position3=[0.1,0.15,0.95,0.45]
   plot_position2 = [0.1,0.6,0.90,0.95];

  For nm=0,nx-1  do begin  ;1st For ; automatically read as many files
     jf=n1+nm ;file index starting from n1
      ;multp=n2-n1+1/Mav
      ni=strcompress(jf,/remove_all)

    fn=Data_path+yr+'\'+month+'\'+dnm+'.'+ni+'m'              ;+Dtype ;
      openr,1,fn
      readf,1,cnt_sig

     close,1


     ; cnt_sig  ;read binary file
     cnt_sig=cnt_sig(0:bnum-1);
     bk=min(cnt_sig[bnum-500:bnum-1]);  treat background
     sg[nm,*]=smooth(cnt_sig,5)-bk ;smooth signal
          ;maxsg=max(sg)
        ; sumsg=sumsg+sg
     ;for mr=0:bnum-1 ; to remove negative
      if (min(sg[nm,*]) le 0) then sg[nm,*]=sg[nm,*]-min(sg[nm,*])

     ;endfor;mr

        PR2M[nm,*]=sg[nm,*]*(z^2)*Tm

       if (nm eq 0) then begin
        plot,PR2M[nm,*],ht,color=2,background=-2,yrange=[h1,h2],title='PR2_m &PR',$
        xtitle= 'pr2_m',ytitle='km', position=plot_position2 ;file 1',color=2
       endif else begin
         oplot,PR2M[nm,*],ht, color=2
       endelse

       endfor  ;nm

      stop  ; section 1
;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;Perpendicular channel;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 sgd=fltarr(nx,bnum)
  sigd=fltarr(bnum)
 k=0

 FOR nd=0,nx-1 do begin
    jd=n1+nd ;file index starting from n1
      ;multp=n2-n1+1/Mav
      ni=strcompress(jd,/remove_all)



   ;sn=strtrim(fix(nd),2)
   fn2=Data_path+yr+'\'+month+'\'+dnm+'.'+ni+'d'              ;+Dtype ;

    openr,2,fn2
    readf,2,sigd

    close,2


     ; cnt_sig  ;read binary file
     cnt_sigd=sigd[0:bnum-1];

     bk2=min(cnt_sigd[bnum-500:bnum-1]);
     sgd[nd,*]=smooth(cnt_sigd,5)-bk2

    if (min(sgd[nd,*]) le 0) then sgd[nd,*]=sgd[nd,*]-min(sgd[nd,*])

    pr2d[nd,*]=sgd[nd,*]*(Z^2)*Tm

    if (nd eq 0) then begin
        plot,PR2d[nd,*],ht,color=2,background=-2,yrange=[h1,h2],xtitle= 'pr2_d',ytitle='km',$
        position=plot_position1;file 1',color=2
     endif else begin
       oplot,PR2d[nd,*],ht, color=2
     endelse


    ; k=k+1
   close,2
  ENDFOR  ;nd

stop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;Fernald inversion;  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
m0=2;5
;average 5 profiles
 n5=nx/m0

 X=fltarr(n5,bnum); PR2

 J2=0
FOR i=0,nx-m0,m0 do begin; average 2, 5 profiles

For iy=0,bnum-1 do begin
   X[J2,iy]=mean(PR2M[i:i+m0-1,iy]+PR2D[i:i+m0-1,iy])

endfor  ;iy
  X[J2,*]=smooth(X[J2,*],10)
  J2=J2+1
endfor  ;i
;stop

;Part III Backscattering coefficient calculation  based on Fernald 1984
;5 files are averaged
lo_bin=round(h1/dz)
hi_bin=round(h2/dz)


 BTM=dblarr(n5,bnum)  ; ¤À¥À  denumerator of Fernald eq. (5) and (6)
 BTM1=dblarr(n5)  ; first term in BTM
 BTM2=dblarr(n5,bnum)  ;2nd term in BTM
 A=fltarr(bnum) ;A term in Fernald
 V1=fltarr(n5,bnum)
   ; sumbtm2=fltarr(n5)
 beta_a=dblarr(n5,bnum)  ;backscattering coefficient of aerosol
 bratio=dblarr(n5,bnum)
 ;Initial condition
  BTM2[*,bnum-1]=0; Sa*(X[*,0]+X[*,0])*EXP(A[0])*dz
  BTM[*,bnum-1]=0; BTM1[*,0]+BTM2[*,0]
  beta_a(*,hi_bin)=0;   10*beta_r(hi_bin-1)  ;initial condition at top  =beta_a
 For nj=0,n5-1  do begin  ;from starting file n1 to last file n2
   b2=hi_bin
   BTM1[nj]= X[nj,b2]/(beta_r[b2]+beta_a[nj,b2])
    while (BTM1[nj] eq 0) do begin
      b2=b2-1
      BTM1[nj]=X[nj,b2]/(beta_r[b2]+beta_a[nj,b2])
    endwhile

    b2=hi_bin
   For k =b2-1 ,1,-1 do begin   ;calculation start from b2
     A[k]=(Sa-Sr)*(beta_r[k]+beta_r[k-1])*dz1000
     V1[nj,k]=X[nj,k]*exp(A[k])

     BTM2[nj,k]=Sa*(X[nj,k]+X[nj,k -1]*exp(A[k]))*dz1000

     ;BTM[nj,k]=BTM1[nj]+BTM2[nj,k]
    ; beta_a[nj,k]=(V1[nj,k])/(BTM[nj,k])-(beta_r[k]);
   Endfor  ;k
   endfor   ;nj
   stop
   BTM1=smooth(BTM1,5)


   for ns=0,n5-1  do begin
   BTM[ns,*]=BTM1[ns]+BTM2[ns,*]
   beta_a[ns,*]=V1[ns,*]/BTM[ns,*]-beta_r[*]
   endfor;ns
    Megam=1.0e-6  ; expressed in mega-meter
    beta_a=beta_a/Megam
    maxa=max(beta_a[n5/2,*])
    minbeta=min(beta_a) ;mean beta
    beta_a=beta_a-minbeta
     meanbeta=total(beta_a,1)/n5
    ;beta_a=beta_a-mbeta     ;correction for negative beta

    plot,beta_a[0,0:b2],ht,yrange=[h1,h2],xrange=[0,maxa*2],background=-2,color=2,charsize=1.3,charthick=1.5,$
    xtitle='beta_a (1/Mm-sr)',ytitle='Height (km)',TITLE=FTITLE+FS
    oplot,beta_r,ht,color=150
      stop; section IIA

    For nk=0,n5-1 do begin
         oplot,beta_a[nk,0:b2]+nk*5,ht,color=2  ;ht[100:b2-100]

    ENDFOR ;nk
   ;

    oplot,meanbeta,ht,color=100,thick=2
    out_path='E:\RSI\lidar\Fernald\2020\'; Fernald_out\'; lidarPro\output\yrmn"
    out_plot1=OUT_path+fnm+'M_beta'+'.png'
   ;  write_png,out_plot1,tvrd()

   stop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;; contour plot;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ERASE,COLOR=-2
close,/all
device, decomposed=0


;!p.background=255
; loadct,39
plot,[0,10],[-1,1],COLOR = 0
plot,[0,1],xrange=[0,20],yrange=[-2,2],/nodata,COLOR = 0
oplot,[0,20],[1.5,1.5],COLOR = 50

;
;-----------------------------
;start with a colour table, read in from an external file hues.dat
rgb = bytarr(3,256)
openr,2,'E:\RSI\hues.dat'
readf,2,rgb
close,2
free_lun,2
r=bytarr(256)
g = r
b = r
r(0:255) = rgb(0,0:255)
g(0:255) = rgb(1,0:255)
b(0:255) = rgb(2,0:255)
tvlct,r,g,b
!P.BACKGROUND= 1 ; 0 = black, 1 = white
!P.COLOR=2 ;blue labels

 col = 240 ; don't change it

  cmax=6*max(beta_a[1,5:50]);400;1500;500;./2
  cmin=1.85;20.; cmax/50; cmax/10;min(pr2m[nf-ni-nx/2,0:200])

  nlevs_m=20;0.
  ;nlevs_max =20 ; choose what you think is right
 cint1 = (cmax-cmin)/nlevs_m
 CLEVS = CMIN + FINDGEN(NLEVS_M+1)*CINT1
 ;CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
 clevs0 = clevs ; for plot the color bar

 NLEVS1 = N_ELEMENTS(CLEVS)+1 ;actual number of countour levels

 col = 240 ; don't change it
 C_INDEX=(FINDGEN(NLEVS1)+1)*col/(NLEVS1)
 c_index(NLEVS1-1) = 1 ; missing data = white

 plot_position1 = [0.1,0.15,0.90,0.49]; plot_position=[0.1,0.15,0.95,0.45]
 plot_position2 = [0.1,0.6,0.90,0.95];
 plot_position3=[0.1,0.15,0.90,0.95]
 BAR_POSITION3=[0.93,0.2,0.95,0.95]
 ;BAR_POSITION2=[0.97,0.7,0.99,0.95]

 ;f1=string(ni,format='(I3.3)')
 ;f2=string(nf,format='(I3.3)')
 ;f3=f1+'--'+f2
 s1=strtrim(fix(n1),2)
 s2=strtrim(fix(n2),2)
 S='                                       file:'+s1+'_'+s2;used to print title
 x=findgen(n5)
 window,1
 !p. multi=[0,1,1]
 contour,beta_a(*,0:b2),x,ht(0:b2),xtitle='m channel time',ytitle='km',yrange=[h1,h2],LEVELS = CLEVS, /FILL,$
    C_COLORS = C_INDEX, color=2,/FOLLOW,title=S,position=plot_position3
; xyouts,1.5*max(x),0.2*max(y),f3,/device
 ;stop
 ; plot a color bar, use the same clevs as in the contour

   ; nlevs=40
    zb = fltarr(2,nlevs1)
    for k = 0, nlevs1-1 do zb(0:1,k) = cmin + cint1*k
     xb = [0,1]
     yb = cmin + findgen(nlevs1)*cint1
     xname = [' ',' ',' ']
     CONTOUR, zb, xb(0:1), yb(0:nlevs1-1),position=BAR_POSITION3,$
      xrange=[0,1],/xstyle,xtickv=findgen(2),$
      xticks=1,xtickname=xname,yrange =[cmin,cmax],/YSTYLE, $
      LEVELS = CLEVS0,C_COLOR = C_INDEX, /FILL, ycharsize=0.7, $
      xcharsize=0.8,/noerase
stop


 OPATH3='E:\RSI\lidar\Fernald\2020\'
    cname =opath3+dnm+'beta_ALLb.png'

WRITE_png,cname,TVRD(/TRUE)

stop
end