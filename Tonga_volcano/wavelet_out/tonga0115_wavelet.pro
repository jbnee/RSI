pro Tonga0114_wavelet
device, decomposed=0

rgb = bytarr(3,256)
openr,2,'e:\rsi\hues.dat'
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




   close,/all
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;input data;;;;;;;;;;;;;;;


 fpath='e:\rsi\wavelet_lombscargle\'  ;sun_spot.txt'
  F1='E:\RSI\Tonga volcano 2020\As0115.txt'
  ;finm=fpath+datanm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
AS=fltarr(80,6000)
line=''

;openr,1,F1
;readf,1,line
A=read_ascii(F1)
B=A.(0)

sB=size(B)
V=rebin(B,80,6000)
Nlevel=6000
stop

T4am=Total(V[0:159,*],1) ;total data number for 0-4am
;stop
dz=3.75/1000.
Ht=indgen(6000)*dz  ;dkm=(km[N-1]-km[0])/N;
 wave = WAVELET(T4am,dz,PERIOD=period,COI=coi,/PAD,SIGNIF=signif)
     nscale = N_ELEMENTS(period)
     LOADCT,10
  power=abs(wave)^2;

pA =[0.1,0.15,0.90,0.90]

pB = [0.1,0.6,0.90,0.90]

BAR_0=[0.94,0.2,0.96,0.9]

;;call make_contour here
;contour_make,power,ht,period
stop
      CONTOUR,power,ht,period,ytickinterval=2,background=-2,yrange=[min(period),max(period)],$
       XSTYLE=1,XTITLE='Range ht',YTITLE='Period km',TITLE='T Wavelet',$
        Nlevels=20,/fill, position=PA
      ; /YTYPE, NLEVELS=25,/FILL       ;*** make y-axis logarithmic





 signif = REBIN(TRANSPOSE(signif),Nlevel,nscale)
 CONTOUR,ABS(wave)^2/signif,ht,period,/OVERPLOT,LEVEL=1.0,C_ANNOT='95%'
 PLOTS,Ht,coi,NOCLIP=0,color=90;     ;*** anything "below" this line is dubious
 close,1
stop
DEVICE, GET_DECOMPOSED=old_decomposed
DEVICE, DECOMPOSED=0
stop
 nlevs=20
 zb = fltarr(2,nlevs)

 for k = 0, nlevs-1 do zb(0:1,k) =  8.+1.0*nlevs*k
     xb = [0,1]
     zmax=max(zb);
     zmin=min(zb)
     a=(zmax-zmin)/(nlevs-1);
     b=zmin;  a/(nlevs-1)
     yb =0.025*(a*findgen(nlevs)+b)
     xname = ['','','']

 CONTOUR, zb, xb, yb(0:nlevs-1),Nlevels=20,/fill,position=bar_0,/noerase,$
 ycharsize=1,xcharsize=0.1;,xtickname=xname;,/Ytype
 ;Ytype: log scale
stop


 fpath='e:\rsi\tonga volcano\'
 outname='T01154am'
 read,outname,prompt='  filename as:wvlt****.png" ??  '
 f1 =fpath+outname+'.png'
WRITE_PNG, fpath+outname, TVRD(/TRUE)
stop





end