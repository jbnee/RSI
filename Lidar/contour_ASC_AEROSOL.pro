Pro Contour_ASC_AEROSOL
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
FNMD=''
;FNMD='0211ASC';  file name
read,FnmD,PROMPT='NAME OF THE FILE AS 0314ASC: '
read,h1,h2,prompt='Initial and final height as ,1,5 km:'
dnm=strmid(fnmd,0,4)
;h1=2;
;h2=8;
year='2021'
 path='D:\LiDAR_DATA\'+year+'\'
 ;path='F:\2021\'
 bpath=path+FNMD;  bpath='G:\0425B\'
  fx=bpath+'\a*'  ;file path
  fls=file_search(fx)
  Sf=size(fls)
    PRINT,'NUM OF TOTAL FILES IN THIS DIRECTORY: ',SF
  Fno=Sf[1]
 T0=strmid(fls[0],33,5)
 T9=strmid(fls[Fno-1],33,5)

  ; SEARCH files of the day, starting with 0
  JF=0

 T0=strmid(fls[0],41,5)

print,dnm,'hr',T0  ;starting time of the day of data


    nx=Sf[1]


    bn1=round(h1*1000./dz)  ;define range of interest bn1 is the lower bin number
    bn2=round(h2*1000./dz)  ;upper bin
    Nbin=bn2-bn1+1
   ;s1=strtrim(fix(ni),2)   ; starting file number
   ;s2=strtrim(fix(nf),2)   ;ending file number
   ;Sw ='      file:'+s1+'_'+s2;used to print title
    sigxm=fltarr(nx,Nbin);   signal count in with range bn2-bn1+1)
    ;=fltarr(nx,N)
    pr2m=fltarr(nx,Nbin)
    pr2d=fltarr(nx,Nbin)

     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    hd=''

   ; NF=sf[1]   ; number of files
    read,nf1,nf2,prompt='1st and last files to read as 1,300:'

   ; nf1=1         ;LICEL data format inital file number is 5 ignore first 5 data
   ; nf2=NF

     m=nf2-nf1+1  ;m is the number of total files for example 200 with 100 parallel 100 perpendicular
    DATAB=FLTARR(2,Nbin)
    Ps=fltarr(m,Nbin) ;Ps photon counting signal

    As=fltarr(m,Nbin) ;As  Analog signal

    close,/all
    J=0;nf1-1
   FOR I=nf1,nf2-1 DO BEGIN ; open file to read
      OPENR,1,fls[I]

      FOR h=0,5 do begin ;;;read licel first 5 head lines
        readf,1,hd
        ;print,hd
      endfor   ;h
;;;;;;;;;;;;;;;;;;;; reading data below
      READF,1, DATAB
      AS[J,*]=datab[1,*];*(ht*1000)^2; PR2
      PS[J,*]=datab[0,*];*(ht*1000)^2

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
     bk1=min(PS1[j,nbin-200:nbin-1])
     PS1[j,*]=PS1[j,*]-bk1
     ;PR2m[j,*]=PS1[j,*]*(ht*1000)^2;

     PS2[J,*]=Ps[k+1,*]
     bk2=min(PS2[j,nbin-200:nbin-1])
     PS2[j,*]=PS2[j,*]-bk2
     ;PR2D[j,*]=PS2[j,*]*(ht*1000)^2;

     ;As1[k,*]=As[k,*]
     ;As2[k,*]=As[k+1,*]
     J=J+1
    endfor; k
np=size(ps1);
ns=np[1]
;;;;;;;;;;;;;;;;;;;;;;line plots;;;;;;;;;;;;;;;;;;;;;;;
ht=ht[bn1:bn2]
!p.multi=[0,1,1]

;outPath='E:\aerosol_dust\taals_volcano\plots'

;outplot=outpath+'signal plot.png'
XC=dnm+'-  paralle/perpendicular polarization'
XA=FNMD+'Analog channel'
;h1=1.5
;h2=8

m2=floor(m/2)
meanPs1=total(Ps1,1)/m2;
meanPs2=total(Ps2,1)/m2
maxp=max(meanPs1)
!p.multi=[0,5,1]
plot,meanPs1,ht,color=2, background=1,xrange=[0,2*maxp],yrange=[h1,h2],xtitle='count',ytitle='km',$
   title='sum signal',charsize=1.2
oplot,meanPs2,ht,color=180; background=-2,xrange=[0,maxp],yrange=[h1,h2],position=pos2,xtitle='time (min)',ytitle='km',$
;title=XC,charsize=2
;write_png,outplot,tvrd()
;plot,A[0,*],ht,color=120,xrange=[0,50],yrange=[0,5],position=p2, xtitle='time (min)',ytitle='km',title='0425 analog channel'

IC=[1,m2-m2/2,m2-m2/4,m2-2]
for j=0,3 do begin
  plot,smooth(PS1[ic[j],*],20),ht,yrange=[h1,h2],color=2,background=-2,title='file'+ic[j]
  oplot,smooth(PS2[ic[j],*],20),ht,color=100

endfor; j

STOP
outplot='E:\RSI\outputs\'

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


  ;na=30 ;reset inital file for error data
  na=0
  x=indgen(m/2-na)
  y=dz*indgen(Nbin)/1000+h1
  CPPM=Ps[na:m2-1,*]  ;
  CPPM1=Ps1[na:m2-1,*]  ;chan 1 photon counting
  CPPM2=Ps2[na:m2-1,*]  ;chan 2  photon counting

 ; CPPD=A[0:m-1,*] ; analog


  col = 240 ; don't change it
  cmin=0;min(AZ);10 is arbitrary set the 5th file
  cmax1=1*max(CPPM1[m/4,*]);for high altitude  ;cmax=1*max(CPPM[m/2,100:1000]); for low altitude
  cmax2=1*max(CPPM2[m/4,*]);
  ctest=[cmax1,cmax2]
  cmax=min(ctest)  ; select the largest one

  nlevs_max =20 ; choose what you think is right
  cint = (cmax-cmin)/nlevs_max
  CLEVS = CMIN + FINDGEN(NLEVS_MAX)*CINT  ;findgen(nlevs_max+1
 ;CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
  clevs0 = clevs ; for plot the color bar

  NLEVS = N_ELEMENTS(CLEVS)+1 ;actual number of countour levels

    ;print,i0,' cmin,cmax',cmin,cmax,cint,nlevs

    C_INDEX=(FINDGEN(NLEVS)+1)*col/(NLEVS)
    c_index(NLEVS-1) = 1 ; missing data = white
p0=[0.1,0.15,0.90,0.95]
; plot_position1 = [0.1,0.15,0.93,0.49]; plot_position=[0.1,0.15,0.95,0.45]
; plot_position2 = [0.1,0.6,0.93,0.95]; plot_position2=[0.1,0.6,0.95,0.95]
 ; BAR_POSITION1=[0.97,0.2,0.98,0.45]
 ; BAR_POSITION2=[0.97,0.5,0.98,0.95]
BAR_0=[0.94,0.2,0.96,0.9]
!p.multi=[0,1,2]

pA =[0.1,0.15,0.90,0.45]


pB = [0.1,0.6,0.90,0.90]
;;;;;;;;;;;;separate two channels;;;;;;;;;;;;;;;;;;;;

   contour,CPPM1,x,y,xtitle='Time interval (min)',ytitle='Height (km)',yrange=[h1,h2],$
   LEVELS = CLEVS, /FILL, C_COLORS = C_INDEX ,/FOLLOW,charsize=1.4, position=pA,$
   title='P1_ channel'

   ;xyouts,500,5,'fn',color=1,charsize=2
   ;C_INDEX=C_INDEX*2.5
   contour,CPPM2,x,y,ytitle='Height (km)',yrange=[h1,h2],LEVELS = CLEVS, /FILL,$
    C_COLORS = C_INDEX,/FOLLOW,charsize=1.4, position=pB,$
    title='P2_'+dnm+' starting hr:'+T0

  ; xyouts,500,5,'fn',color=1,charsize=2


 ; plot a color bar, use the same clevs as in the contour


    zb = fltarr(2,nlevs)

   for k = 0, nlevs-1 do zb(0:1,k) = cmin + cint*k
     xb = [0,1]
     yb = cmin + findgen(nlevs)*cint
     xname = [' ',' ',' ']
     CONTOUR, zb, xb(0:1), yb(0:nlevs-1),position=BAR_0,$
      xrange=[0,1],/xstyle,xtickv=findgen(2),$
      xticks=1,xtickname=xname,yrange =[cmin,cmax],/YSTYLE, $
      LEVELS = CLEVS0,C_COLOR = C_INDEX, /FILL, ycharsize=0.7, $
      xcharsize=0.8,/noerase,title='signal'

 stop


 outfile='E:\RSI\outputs\';  path+'plots\'+dnm+'A_contour5km.png'
;note=''
;read,note,prompt='Add file name:'
WRITE_png,OUTfile,TVRD(/true)

stop

end
;**************** depolarization  ********************




