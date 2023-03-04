Pro Licel_2019_Analog
; this is for ascii txt files converted from original lidar data
CLOSE,/ALL
erase,-2
NBin=6000; total bin number
T=findgen(NBin)
fq=40.0e6 ;  20 or 40 MHz
BT=1/fq ; bin width
v=3.0E8; speed of light
dz=v*BT/2  ;height resolution
ht=dz*T/1000.+0.0001   ;convert ht to km and remove 0 with bin resolution 50 ns


FNMD='';
read,FnmD,PROMPT='NAME OF THE FILE AS 0514B: '
read,h1,h2,prompt='Initial and final height as ,1,5 km:'

 path='F:\Lidar_data\2019\'
 bpath=path+FNMD;  bpath='G:\0425B\'
  fx=bpath+'\a*'
  fls=file_search(fx)
   Sf=size(fls)
    PRINT,'NUM OF TOTAL FILES IN THIS DIRECTORY: ',SF
   ; STOP

  ; SEARCH files of the day, starting with 0
  JF=0
  ;READ,JF,PROMPT='STARTING FILE TO SEARCH: '
     ;data count J=0 is the name of the 1st file
  fi=fls[Jf]
  fi_date=strmid(fls[jf],29,2)
  nfday=where(strmid(fls,33,2) eq fi_date)

  S1=size(nfday)

  print,S1[1]
  ;stop
sdnm=strmid(fi,8,15)  ; change this for correct word count
month=strmid(sdnm,28,1)
;if (month eq 4) then MX='AP'
da=strmid(sdnm,29,2)
hr=strmid(sdnm,33,2)
minute=strmid(sdnm,35,2)
dnm='MA'+da+hr+minute  ; this is the file name

print,dnm


    nx=Sf[1]
   ; h1=0.5
    ;h2=4.0
    ;read,h1,h2,prompt='height region as 0,8 in km: '
    bn1=round(h1*1000./dz)  ;lower bin number
    bn2=round(h2*1000./dz)  ;upper bin
   ;s1=strtrim(fix(ni),2)
   ;s2=strtrim(fix(nf),2)
   ;Sw ='      file:'+s1+'_'+s2;used to print title
    sigxm=fltarr(nx,Nbin);bn2-bn1+1)
    ;=fltarr(nx,N)
    pr2m=fltarr(nx,Nbin)
    pr2d=fltarr(nx,Nbin)

     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    hd=''

    NF=sf[1]
    nf1=4 ;inital file number is 5 ignore first 5 data
    nf2=NF-1
   ;Read,nf1,nf1,prompt='starting and ending file number: '
     m=nf2-nf1+1
    DATAB=FLTARR(2,Nbin)
    ;P=fltarr(m,Nbin) ;photon counting signal
    A=fltarr(m,Nbin) ; Analog signal
    ;ppm=fltarr(m,N)
    ;ppd=fltarr(m,N)
    close,/all
    J=0;nf1-1
   FOR I=nf1-1,nf2-1 DO BEGIN
    OPENR,1,fls[I]

   FOR h=0,5 do begin
    readf,1,hd
    print,hd
   endfor

    READF,1, DATAB
    A[J,*]=datab[0,*]*(ht*1000)^2; PR2
   ; P[J,*]=datab[1,*]*(ht*1000)^2

    close,1
    J=J+1
   ENDFOR
   stop


!p.multi=[0,3,1]
p1 = [0.1,0.1,0.35,0.9]; plot_position=[0.1,0.15,0.95,0.45]


p2 = [0.7,0.1,0.90,0.9]
p3=[0.4,0.1,0.65,0.9] ;middle position
  ; film=dnm+'.'+strtrim(I,2)+'m'

outpath=path+'output\'
outplot=outpath+'AEplot.png'
;XC=FNMD+' photon channel'
XA=FNMD+'Analog channel'
;h1=1.5
;h2=8

plot,A[nf1,*]/1.e6,ht,color=2, background=-2,xrange=[0,500],yrange=[h1,h2],position=p1,xtitle='time (min)',ytitle='km',$
title=XC,charsize=2
;plot,A[0,*],ht,color=120,xrange=[0,50],yrange=[0,5],position=p2, xtitle='time (min)',ytitle='km',title='0425 analog channel'

FOR k=0,M-1 DO BEGIN
oplot,A[k,*]+k*5,ht, color=2
;oplot,P[k,*]/1.e6+k*10,ht,color=2

ENDFOR; k

meanA=total(A,1)/m

plot,meanA,ht,color=2, background=-2,yrange=[h1,h2],position=p3,xtitle='Intensity',ytitle='km',charsize=2
maxA=max(A[0,*])
plot,A[0,*]/1.e6,ht,color=120,background=-2,xrange=[0,maxA/10],yrange=[0,5],position=p2,$
title=XA,xtitle='time (min)',ytitle='km',charsize=2

FOR kA=0,M-1 DO BEGIN
oplot,A[kA,*]/1.e6+kA*2,ht, color=2

ENDFOR; kA
PA=(total(A,1)/m) ;
oplot,Pa,ht,color=100,thick=2
STOP

;write_bmp,outplot,tvrd()
close,2
   ;;;;;;;;;;;;;;;;;plot contour;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
rgb = bytarr(3,256)
openr,2,'F:\RSI\hues.dat'
readf,2,rgb
close,2
free_lun,2
device, decomposed=0
 !p.background=255
 loadct,39
  window,1
r=bytarr(256)
g = r
b = r
r(0:255) = rgb(0,0:255)
g(0:255) = rgb(1,0:255)
b(0:255) = rgb(2,0:255)
tvlct,r,g,b
!P.BACKGROUND= 1 ; 0 = black, 1 = white
!P.COLOR=2 ;blue labels

  x=indgen(m)
  nf3=nf2-nf1

  y=dz*indgen(Nbin)/1000
  ;CPPM=P[0:nf3,*]
  CPPA=A[0:nf3,*]


  col = 240 ; don't change it
  cmin=0;min(AZ);10 is arbitrary set the 5th file
  cmax=1*max(CPPM[m/2,bn1:bn2]);for high altitude
  ;cmax=1*max(CPPM[m/2,100:1000]); for low altitude
  nlevs_max=40
  nlevs_max = 20 ; choose what you think is right
  cint = (cmax-cmin)/nlevs_max
  CLEVS = CMIN + FINDGEN(NLEVS_MAX+1)*CINT
 ;CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
  clevs0 = clevs ; for plot the color bar

  NLEVS = N_ELEMENTS(CLEVS)+1 ;actual number of countour levels

    ;print,i0,' cmin,cmax',cmin,cmax,cint,nlevs

    col = 240 ; don't change it
    C_INDEX=(FINDGEN(NLEVS)+1)*col/(NLEVS)
    c_index(NLEVS-1) = 1 ; missing data = white
p0=[0.1,0.15,0.90,0.95]
; plot_position1 = [0.1,0.15,0.93,0.49]; plot_position=[0.1,0.15,0.95,0.45]
; plot_position2 = [0.1,0.6,0.93,0.95]; plot_position2=[0.1,0.6,0.95,0.95]
 ; BAR_POSITION1=[0.97,0.2,0.98,0.45]
 ; BAR_POSITION2=[0.97,0.5,0.98,0.95]
BAR_0=[0.97,0.2,0.99,0.94]
!p.multi=[0,1,1]

   contour,CPPA,x,y,xtitle='m channel time starting 19:30PM',ytitle='km',xrange=[0,nf3-1],yrange=[5,h2],LEVELS = CLEVS, /FILL,$
    C_COLORS = C_INDEX, color=2,/FOLLOW, position=p0,title=XC

   xyouts,500,5,'fn',color=1,charsize=2

 ; plot a color bar, use the same clevs as in the contour

    nlevs=40
    zb = fltarr(2,nlevs)

   for k = 0, nlevs-1 do zb(0:1,k) = cmin + cint*k
     xb = [0,1]
     yb = cmin + findgen(nlevs)*cint
     xname = [' ',' ',' ']
     CONTOUR, zb, xb(0:1), yb(0:nlevs-1),position=BAR_0,$
      xrange=[0,1],/xstyle,xtickv=findgen(2),$
      xticks=1,xtickname=xname,yrange =[cmin,cmax],/YSTYLE, $
      LEVELS = CLEVS0,C_COLOR = C_INDEX, /FILL, ycharsize=0.7, $
      xcharsize=0.8,/noerase

 stop
out2=outpath+'\High cloud_0515.png'
WRITE_png,OUT2,TVRD(/true)

stop

end
