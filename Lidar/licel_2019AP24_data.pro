Pro Licel_2019AP24_data
; this is for ascii txt files converted from original lidar data
CLOSE,/ALL


 bpath='f:\Lidar_data\2019\0515B';\CH6_3sB'
;  bpath='G:\0425B\'
  fx=bpath+'\a*'
  fls=file_search(fx)
    nf=size(fls)
    PRINT,'NUM OF TOTAL FILES IN THIS DIRECTORY: ',NF
   ; STOP

  ; SEARCH files of the day, starting with 0
  JF=0
  ;READ,JF,PROMPT='STARTING FILE TO SEARCH: '
     ;data count J=0 is the name of the 1st file
  fi=fls[Jf]
  fi_date=strmid(fls[jf],33,2)
  nfday=where(strmid(fls,33,2) eq fi_date)

  S1=size(nfday)
  print,S1[1]
  ;stop
sdnm=strmid(fi,8,15)  ; change this for correct word count
month=strmid(sdnm,3,1)
;if (month eq 4) then MX='AP'
da=strmid(sdnm,4,2)
hr=strmid(sdnm,6,2)
minute=strmid(sdnm,9,2)
dnm='AP'+da+hr+minute  ; this is the file name

print,dnm
;stop
 N=2000
T=findgen(N)

ht=3.0E8*50.E-9*T/2./1000.+0.001   ;convert ht to km and remove 0 with bin resolution 50 ns
  FX=BPATH+'\a*';    e*'
  ;fx=bpath+'\t09726*';  yr+'\'+month+'\'+dnm+'.'
  ; read,h1,h2,prompt='Initial and final height as ,1,5 km:'



    nx=nf[1]
    h1=0.5
    h2=4.0
    n1=round(h1*1000./7.5)  ;channel number
    n2=round(h2*1000./7.5)  ;ch
   ;s1=strtrim(fix(ni),2)
   ;s2=strtrim(fix(nf),2)
   ;Sw ='      file:'+s1+'_'+s2;used to print title
    sigxm=fltarr(nx,N);n2-n1+1)
    ;=fltarr(nx,N)
    pr2m=fltarr(nx,N)
    pr2d=fltarr(nx,N)

     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    hd=''
    n1=0
    n2=nf[1]-1
   ;Read,n1,n2,prompt='starting and ending file number: '
     m=n2-n1+1
    DATAB=FLTARR(2,N)
    C=fltarr(m,N) ;photon counting signal
    A=fltarr(m,N) ; Analog signal
    ;ppm=fltarr(m,N)
    ;ppd=fltarr(m,N)
    close,/all
    J=0
   FOR I=n1,n2 DO BEGIN
    OPENR,1,fls[I]
    readf,1,hd
    READF,1, DATAB
    A[J,*]=datab[0,*]
    C[J,*]=datab[1,*]

    close,1
    J=J+1
   ENDFOR
   stop
!p.multi=[0,2,1]
p1 = [0.1,0.1,0.40,0.9]; plot_position=[0.1,0.15,0.95,0.45]
p2 = [0.6,0.1,0.90,0.9]

  ; film=dnm+'.'+strtrim(I,2)+'m'
outplot='F:\lidar_data\2019\0425B\out_puts\AEplot.png'
plot,C[0,*],ht,color=2, background=-2,xrange=[0,500],yrange=[0,5],position=p1,xtitle='time (min)',ytitle='km',title='0425 photon channel'
;plot,A[0,*],ht,color=120,xrange=[0,50],yrange=[0,5],position=p2, xtitle='time (min)',ytitle='km',title='0425 analog channel'

FOR k=0,M-1 DO BEGIN
;oplot,A[k,*]+k*5,ht, color=2
oplot,C[k,*]+k*1,ht,color=2

ENDFOR; k
stop
plot,A[0,*],ht,color=120,xrange=[0,50],yrange=[0,5],position=p2, title='0425 analog channel',xtitle='time (min)',ytitle='km'

FOR kA=0,M-1 DO BEGIN
oplot,A[kA,*]+kA*5,ht, color=2



ENDFOR; kA
PA=total(A,1)
oplot,Pa,ht,color=100
STOP

write_bmp,outplot,tvrd()
close,2
   ;;;;;;;;;;;;;;;;;plot contour;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
rgb = bytarr(3,256)
openr,2,'f:\rsi\hues.dat'
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
  n3=n2-n1
  L=size(datab)

  y=0.0075*indgen(L[2])
  CPPM=C[0:n3,*]
  CPPD=A[0:n3,*]


  col = 240 ; don't change it
  cmin=0;min(AZ);10 is arbitrary set the 5th file
  cmax=max(CPPM[1,20:200])/3;100000;60000
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
p0=[0.1,0.15,0.95,0.95]
; plot_position1 = [0.1,0.15,0.93,0.49]; plot_position=[0.1,0.15,0.95,0.45]
; plot_position2 = [0.1,0.6,0.93,0.95]; plot_position2=[0.1,0.6,0.95,0.95]
 ; BAR_POSITION1=[0.97,0.2,0.98,0.45]
 ; BAR_POSITION2=[0.97,0.5,0.98,0.95]
BAR_0=[0.9,0.2,0.95,0.95]
!p.multi=[0,1,1]
   contour,CPPM,x,y,xtitle='m channel time starting 19:30PM',ytitle='km',xrange=[0,n3-1],yrange=[h1,h2],LEVELS = CLEVS, /FILL,$
    C_COLORS = C_INDEX, color=2,/FOLLOW, position=p0,title='2019_0425'

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
out1='F:\lidar_data\2019\0425B\OUT_PUTS\AEROSOL_0425.png'
WRITE_png,OUT1,TVRD(/true)



end
