Pro overlap_dho
; In the first part we will read data and plot;
; In the second part, we will process signal according to Fernald
;Part I read data
 ; read,bnum, prompt='Enter total number bins (eg.4096)  '
  bnum=600
  p=fltarr(5,bnum); bin array of 1250 for 1250*0.024=30km
  ht=findgen(bnum)*50
  pr2=fltarr(bnum)
  t=fltarr(bnum) ;Rayleigh backscattering coefficient


  close,/all
  bpath='f:\RSI\Lidar\';T0805.txt;  2003\jn022058\jn022058.4M""   ; AUR or SPR
   fnm=bpath+'T0805.txt'
 ; bpath="f:\lidar_data\2015\Jn\0602\2037.txt"

  ;out_path=bpath+'out.txt'; "f:\lidar systems\lidarPro\output\"

   openr,1,fnm
   headx=''
   readf,1,headx
   print,headx
  readf,1,p
  close,1
  s1=p[0,*];*ht^2
  s2=p[1,*]
  s3=p[2,*]
  s4=p[3,*]
  s5=p[4,*]
  plot,s1,ht,color=2,background=-2,yrange=[0,10000];xrange=[0,1E9]


   stop
   ; fitting polynomial above z1
   z1=5  ;km
   binz1=5/0.05;
   x=ht[100:400]
   x2=x^2
   y=s1[100:400]; take 5-20 km
   oplot,y,x,color=2;background=-2
   stop
   scoeff=poly_fit(x,y,5)
   ;x1=ht[0:500]
   ;sfit=scoeff[0]+scoeff[1]*x+scoeff[2]*x1^2+scoeff[3]*x1^3+scoeff[4]*x1^4+scoeff[5]*x1^5
   sfit=scoeff[0]+scoeff[1]*x+scoeff[2]*x^2+scoeff[3]*x^3+scoeff[4]*x^4+scoeff[5]*x^5
    sfit0=scoeff[0]+scoeff[1]*ht+scoeff[2]*ht^2+scoeff[3]*ht^3+scoeff[4]*ht^4+scoeff[5]*ht^5
   oplot,sfit,x,psym=2,color=3
   stop
   ;;;;something wrong here
   G=s1/Sfit0; exp((s1[0:200]-sfit[0:200])/sfit[0:200])
   plot,G,ht[0:400]/1000,xrange=[-1,2],yrange=[0,10],color=2,background=-2,xtitle='Overlap',ytitle='km',charsize=1.5
   stop
   outfile=bpath+'overlap.bmp'
   write_bmp,outfile,tvrd()

     end

