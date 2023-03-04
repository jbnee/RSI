Pro contour_beta_aerosol
device, decomposed=0

;!p.multi=[0,1,2]
!p.background=255
 loadct,39
;plot,[0,10],[-1,1],COLOR = 0
;plot,[0,1],xrange=[0,20],yrange=[-2,2],/nodata,COLOR = 0
;oplot,[0,20],[1.5,1.5],COLOR = 50

;stop
;-----------------------------
;start with a colour table, read in from an external file hues.dat
rgb = bytarr(3,256)
openr,2,'F:\rsi\hues.dat'
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


;openr,1,"d:\LidarPro\DATA\Rayleigh\1999\FE\Fe092341.2R"
;fn="D:\Lidar systems\lidarPro\Rayleigh\1993\se\se112342.';se010044.10m"
bpath='f:\Lidar_data\test\'
  close,/all
 ; bpath='d:\Lidar_files\depolar\output2\' ;data file location
 ;fpath=bpath+yr+'\'+month+'\'
 ;path='d:\LidarPro\Depolar\2004\mr\mr041947.'  ;072150.' ;202312.'; 312023.'; mr192028.' ;mr312023.'
  fnm=''
 ;read,dnm,prompt='data filename as mr12_depolar.txt'
 ;file_basename1='d:\LidarPro\Depolar\2004\ap\ap022014.' ;
 fnm1=''
 fnm2=''
  read,fnm1,prompt='file name mr18beta_m.txt:  '
  read,fnm2,prompt='2 file name mr18beta_d.txt
  file1=bpath+fnm1
  file2=bpath+fnm2
  read,n1,n2, prompt='array size as 20x1000: '
  read,h1,h2, prompt='height range as,10,30:  '
  dz=0.024
  bn1=round(h1/dz)
  bn2=round(h2/dz)
  Nbin=bn2-bn1+1
  z=dz*indgen(n2)
  ht=z[bn1:bn2]
  Beta_M=fltarr(n1,n2)
  Beta_D=fltarr(n1,n2)
   openr,1,file1
   readf,1,beta_M
   close,1
   openr,1,file2
   readf,1,beta_D

    close,1

  ;;;;;
  beta1=beta_m[*,bn1:bn2]
  beta2=beta_d[*,bn1:bn2]

  x=INDGEN(n1)
  y=ht

   STOP

 !P.multi=[0,1,2]
 p1 = [0.1,0.15,0.85,0.5];
 ;
 p2 = [0.1,0.6,0.85,0.95];
;


  BAR_POSITION1=[0.97,0.2,0.99,0.5]
  BAR_POSITION2=[0.97,0.6,0.99,0.95]

maxm=max(beta1[0,*])
erase

plot,beta1[0,*]/maxm,ht,color=2,background=-2,xrange=[1,10],yrange=[h1,h2],xtitle='backscatter coeff 1/Mm',ytitle='km',$
 position=p1

   ;
FOR k1=0,n1-1 do begin
 oplot,beta1[k1,*]+k1*.2,ht,color=2
endfor

maxd=max(beta2[0,*])
plot,beta2[0,*]/maxd,ht,color=2,background=-2,xrange=[1,50],xtitle='backscatter coeff 1/Mm',ytitle='km',$
 position=p2

   ;
FOR k2=0,n1-1 do begin
 oplot,beta2[k2,*]+k2*2,ht,color=2
endfor

stop


  col = 240 ; don't change it
  ;cmin=0;min(AZ);10 is arbitrary set the 5th file
  cmax=2*max(beta_m[0,10:100])
  cmin=0;cmax/20.;
  nlevs_max =100.  ; choose what you think is right

  cint = (cmax-cmin)/nlevs_max
  CLEVS = CMIN + FINDGEN(NLEVS_MAX+1)*CINT
 ;CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
  clevs0 = clevs ; for plot the color bar

  NLEVS = N_ELEMENTS(CLEVS)+1 ;actual number of countour levels
    C_INDEX=(FINDGEN(NLEVS)+1)*col/(NLEVS)
    c_index(NLEVS-1) = 1 ; missing data = white
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



 CONTOUR,Beta1,x,y,xtitle='m channel time',ytitle='km',yrange=[h1,h2],LEVELS = CLEVS, /FILL,$
    C_COLORS = C_INDEX, color=2,/FOLLOW,position=p1,title=fnm


 ; plot a color bar, use the same clevs as in the contour

   ; nlevs=40
    zb = fltarr(2,nlevs)

   for k = 0, nlevs-1 do zb(0:1,k) = cmin + cint*k
     xb = [0,1]
     yb = cmin + findgen(nlevs)*cint
     xname = [' ',' ',' ']

   CONTOUR, zb, xb(0:1), yb(0:nlevs-1),position=BAR_POSITION1,$
      xrange=[0,1],/xstyle,xtickv=findgen(2),$
      xticks=1,xtickname=xname,yrange =[cmin,cmax],/YSTYLE, $
      LEVELS = CLEVS0,C_COLOR = C_INDEX, /FILL, ycharsize=0.7, $
      xcharsize=0.8,/noerase

 stop
 ;;;;;;;;;;;;;;

  col = 240 ; don't change it
  cmin=0;min(AZ);10 is arbitrary set the 5th file
  cmax=2*max(beta_d[0,10:100])
  nlevs_max=40
  ;nlevs_max = 20 ; choose what you think is right
  cint = (cmax-cmin)/nlevs_max
  CLEVS = CMIN + FINDGEN(NLEVS_MAX+1)*CINT
 ;CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
  clevs0 = clevs ; for plot the color bar

  NLEVS = N_ELEMENTS(CLEVS)+1 ;actual number of countour levels
    C_INDEX=(FINDGEN(NLEVS)+1)*col/(NLEVS)
    c_index(NLEVS-1) = 1 ; missing data = white
 ;;;;;;;;;;;;;;;;;;;;;;;;
 beta2=beta_d[*,bn1:bn2]

 CONTOUR,Beta2,x,y,xtitle='d channel time',ytitle='km',yrange=[h1,h2],LEVELS = CLEVS, /FILL,$
    C_COLORS = C_INDEX, color=2,/FOLLOW,position=p2
  xyouts,500,5,'fn',color=1,charsize=2

 ; plot a color bar, use the same clevs as in the contour

    nlevs=40
    zb = fltarr(2,nlevs)

   for k = 0, nlevs-1 do zb(0:1,k) = cmin + cint*k
     xb = [0,1]
     yb = cmin + findgen(nlevs)*cint
     xname = [' ',' ',' ']

  CONTOUR, zb, xb(0:1), yb(0:nlevs-1),position=BAR_POSITION2,$
      xrange=[0,1],/xstyle,xtickv=findgen(2),$
      xticks=1,xtickname=xname,yrange =[cmin,cmax],/YSTYLE, $
      LEVELS = CLEVS0,C_COLOR = C_INDEX, /FILL, ycharsize=0.7, $
      xcharsize=0.8,/noerase

 stop

 cntrname =bpath+fnm+'_BETA.png'

WRITE_PNG, cntrname, TVRD(/TRUE)
stop
end

