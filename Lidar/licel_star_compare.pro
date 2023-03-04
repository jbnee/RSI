Pro Licel_star_compare
; this is for ascii txt files converted from original lidar data
;;;two channel data with even and odd number separately for one of 2 channels
;;;;can be expand to 5 channels
CLOSE,/ALL
ERASE
NBin=6000; total bin number  6000x3.75=22.5 km
T=findgen(NBin)   ; define time
fq=40.0e6 ;  20 or 40 MHz
BT=1/fq ; bin width
v=3.0E8; speed of light
dz=v*BT/2  ;this derive height resolution  3.75m
ht=dz*T/1000.+0.0001   ;convert ht to km and remove 0 as base
yr=''
read,yr,prompt='Year of data: '

FNMD='';  file name
read,FnmD,PROMPT='NAME OF THE FILE AS 0514B: '
read,h1,h2,prompt='Initial and final height as ,1,5 km:'

 path='E:\Lidar_data\'+yr+'\'
 bpath=path+FNMD;  bpath='G:\0425B\'
  fx=bpath+'\a*'  ;file path
  fls=file_search(fx)
   Sf=size(fls)
    PRINT,'NUM OF TOTAL FILES IN THIS DIRECTORY: ',SF
   ; STOP

  ; SEARCH files of the day, starting with 0
  JF=0

da=strmid(fnmd,0,4)

print,da  ;day of data


    nx=Sf[1]


    bn1=round(h1*1000./dz)  ;define range of interest bn1 is the lower bin number
    bn2=round(h2*1000./dz)  ;upper bin
   ;s1=strtrim(fix(ni),2)   ; starting file number
   ;s2=strtrim(fix(nf),2)   ;ending file number
   ;Sw ='      file:'+s1+'_'+s2;used to print title
    sigxm=fltarr(nx,Nbin);   signal count in with range bn2-bn1+1)
    ;=fltarr(nx,N)
    pr2m=fltarr(nx,Nbin)
    pr2d=fltarr(nx,Nbin)

     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    hd=''

    NF=sf[1]   ; number of files
    nf1=4         ;LICEL data format inital file number is 5 ignore first 5 data
    nf2=NF-1
   ;Read,nf1,nf1,prompt='starting and ending file number: '
     m=nf2-nf1+1  ;m is the number of total files for example 200 with 100 parallel 100 perpendicular
    DATAB=FLTARR(2,Nbin)
    Ps=fltarr(m,Nbin) ;Ps photon counting signal

    As=fltarr(m,Nbin) ;As  Analog signal

    close,/all
    J=0;nf1-1
   FOR I=nf1-1,nf2-1 DO BEGIN ; open file to read
    OPENR,1,fls[I]

      FOR h=0,5 do begin ;;;read licel first 5 head lines
        readf,1,hd
        print,hd
      endfor   ;h
;;;;;;;;;;;;;;;;;;;; reading data below
    READF,1, DATAB
    AS[J,*]=datab[0,*]*(ht*1000)^2; PR2
    PS[J,*]=datab[1,*]*(ht*1000)^2

    close,1
    J=J+1
   ENDFOR;   I
   stop   ;check error
   ;;;;;;;;;;;;;;;;;;;separate two channel data;;;;;;;;;;;;;;;;;;;
    PS1=fltarr(m/2,Nbin) ; parallel
    PS2=fltarr(m/2,Nbin) ;perpendicular
    J=0;          count file
    for k=0,m-2,2 do begin
     Ps1[J,*]=Ps[k,*]
     Ps2[J,*]=Ps[k+1,*]

     ;As1[k,*]=As[k,*]
     ;As2[k,*]=As[k+1,*]
     J=J+1
    endfor; k

;;;;;;;;;;;;;;;;;;;;;;line plots;;;;;;;;;;;;;;;;;;;;;;;

;!p.multi=[0,1,1]
;pos1 = [0.1,0.1,0.45,0.9]; plot_position=[0.1,0.15,0.95,0.45]


;pos2 = [0.55,0.1,0.90,0.9]
;p3=[0.4,0.1,0.65,0.9] ;middle position
  ; film=dnm+'.'+strtrim(I,2)+'m'

outpath=path+'outputS\'
outplot=outpath+'signal plot.png'
XC=da+'-  paralle/perpendicular polarization'
XA=FNMD+'Analog channel'
;h1=1.5
;h2=8
m2=round(m/2)
meanPs1=total(Ps1,1)/m2;
meanPs2=total(Ps2,1)/m2
maxp=max(meanPs1)
;plot,meanPs1,ht,color=2, background=-2,xrange=[0,maxp],yrange=[h1,10],xtitle='count',ytitle='km',$
;   title=XC,charsize=2
;oplot,meanPs2,ht,color=180; background=-2,xrange=[0,maxp],yrange=[h1,h2],position=pos2,xtitle='time (min)',ytitle='km',$
;title=XC,charsize=2
;write_png,outplot,tvrd()
;plot,A[0,*],ht,color=120,xrange=[0,50],yrange=[0,5],position=p2, xtitle='time (min)',ytitle='km',title='0425 analog channel'

;STOP

;write_bmp,outplot,tvrd()
close,2
   ;;;;;;;;;;;;;;;;;plot contour;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
rgb = bytarr(3,256)
openr,2,'E:\RSI\hues.dat'
readf,2,rgb
close,2
free_lun,2
device, decomposed=0
 !p.background=255
 loadct,39
;
r=bytarr(256)
g = r
b = r
r(0:255) = rgb(0,0:255)
g(0:255) = rgb(1,0:255)
b(0:255) = rgb(2,0:255)
tvlct,r,g,b
!P.BACKGROUND= 1 ; 0 = black, 1 = white
!P.COLOR=2 ;blue labels


  ;na=30 ;reset inital file for error data
  na=0
  x=indgen(m/2-na)
  y=dz*indgen(Nbin)/1000
  CPPM=Ps[na:m-1,*]  ;
  CPPM1=Ps1[na:m2-1,*]  ;chan 1 photon counting
  CPPM2=Ps2[na:m2-1,*]  ;chan 2  photon counting

 ; CPPD=A[0:m-1,*] ; analog


  col = 240 ; don't change it
  cmin=0;min(AZ);10 is arbitrary set the 5th file
  cmax=2*max(CPPM[m/2,bn1:bn2]);for high altitude
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
BAR_0=[0.97,0.4,0.99,0.9]
!p.multi=[0,1,2]

pA =[0.1,0.15,0.95,0.45]


pB = [0.1,0.6,0.95,0.90]
;;;;;;;;;;;;separate two channels;;;;;;;;;;;;;;;;;;;;

WINDOW,0
   contour,CPPM1,x,y,xtitle='|| channel time starting 18:04PM',ytitle='km',xrange=[0,100],yrange=[0,h2],LEVELS = CLEVS, /FILL,$
    C_COLORS = C_INDEX, color=2,/FOLLOW,charsize=1.4, position=pA,title=da+'Parallel polarization'

   ;xyouts,500,5,'fn',color=1,charsize=2

   contour,CPPM2,x,y,ytitle='km',xrange=[0,100],yrange=[0,h2],LEVELS = CLEVS, /FILL,$
    C_COLORS = C_INDEX, color=2,/FOLLOW,charsize=1.4, position=pB,title=da+'Perpendicular polarization

  ; xyouts,500,5,'fn',color=1,charsize=2


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
      xcharsize=0.8,/noerase,title='cc'
fx=da+'_1.Png'

out2=path+'contour\'+fx
WRITE_png,OUT2,TVRD(/true)

 stop
;;;;This part to find star scattering and compared with lidar
READ, XN,PROMPT='Estimate channel number to plot: '
window,1
;!p.multi=[0,1,1]
!p.multi=[0,2,1]
SM_C1=SMOOTH(CPPM1,50)
SM_C2=SMOOTH(CPPM2,50)
Axm1=max(SM_C1[*,100:2000])
Axm2=max(SM_C2[*,100:2000])
PLOT,SM_C1[xn,0:2000],HT,XRANGE=[0,AXM1],xtitle='count',ytitle='km',$
 TITLE='PARALLEL ',position=PA,charsize=1.4

;stop
for n1=0,3 do begin
OPLOT,SM_C1[xn+n1,0:2000],HT,COLOR=n1*50
WAIT,2
;OPLOT,SMOOTH(SM_C1[xn+2,0:2000],20),HT,COLOR=30
endfor
PLOT,SM_C2[xn,0:2000],HT,XRANGE=[0,AXM2],TITLE='Perpendicular ',$
xtitle='count',ytitle='km',position=PB

for n2=0,3 do begin
OPLOT,SM_C1[xn+n2,0:2000],HT,COLOR=n2*50
;WAIT,2
;OPLOT,SMOOTH(SM_C1[xn+2,0:2000],20),HT,COLOR=30
endfor
stop
 out3='E:\lidar_data\2020\contour\'+da+'starX.bmp'

WRITE_BMP,OUT3,TVRD(/true)
stop
end
