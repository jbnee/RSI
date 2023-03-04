Pro Licel_plot_AS_channel
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

FNMD='';  file name
year=''
read,year,prompt='Input year of data as 2019:'
read,FnmD,PROMPT='NAME OF THE FILE AS 0415ASC: '
read,h1,h2,prompt='Initial and final height as ,1,5 km:'

path='E:\LiDAR_DATA\'+year+'\ASC\';
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
    nf1=1;4         ;LICEL data format inital file number is 5 ignore first 5 data
    nf2=NF-1
   ;Read,nf1,nf1,prompt='starting and ending file number: '
     m=nf2-nf1+1  ;m is the number of total files for example 200 with 100 parallel 100 perpendicular
    DATAB=FLTARR(2,Nbin)
    PS=fltarr(m,Nbin) ;Ps photon counting signal
    PSB=fltarr(m); background
    AS0=fltarr(m,Nbin) ;original As  Analog signal
    AS=fltarr(m,Nbin); treated AS signal
    BAS=fltarr(m);  AS background
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
    AS0[J,*]=datab[0,*];*(ht*1000)^2; PR2

    BAS[j]=min(datab[0,5500:5999]); background
     ; PS[J,*]=datab[1,*];*(ht*1000)^2
     ; PSB[j]=mean(datab[1,5000:5900]); background
     ; PS[j,*]=PS[j,*]-PSB[j]
    AS[j,*]=AS0[j,*]; -BAS[j]*0.95  ;remove background
    close,1
    J=J+1
   ENDFOR;

   ;stop   ;check error
   ;;;;;;;;;;;;;;;;;;;separate two channel data;;;;;;;;;;;;;;;;;;;
   ; PS1=fltarr(m/2,Nbin) ; parallel
   ; PS2=fltarr(m/2,Nbin) ;perpendicular
  ;ANALOG
    AS1=fltarr(m/2,Nbin) ;PS1=fltarr(m/2,Nbin) ; parallel
    AS2=fltarr(m/2,Nbin) ; perpendicular
    J=0;          count file
    for k=0,m-2,2 do begin
     As1[J,*]=As[k,*]
     As2[J,*]=As[k+1,*]

     ;As1[k,*]=As[k,*]
     ;As2[k,*]=As[k+1,*]
     J=J+1
    endfor; k

;;;;;;;;;;;;;;;;;;;;;;line plots;;;;;;;;;;;;;;;;;;;;;;;

!p.multi=[0,1,1]
;pos1 = [0.1,0.1,0.45,0.9]; plot_position=[0.1,0.15,0.95,0.45]


;pos2 = [0.55,0.1,0.90,0.9]
;p3=[0.4,0.1,0.65,0.9] ;middle position
  ; film=dnm+'.'+strtrim(I,2)+'m'
outpath=path+'plots\'
outplot=outpath+da+'_plot.png'
XC=da+'-  paralle/perpendicular polarization'
XA=FNMD+'Analog channel'
;outpath=path+'output\'


;h1=1.5
;h2=8
m2=round(m/2)
meanAS1=total(AS1,1)/m2;
meanAS2=total(AS2,1)/m2;
bk1=mean(meanAS1[5800:5999])
bk2=mean(meanAS2[5800:5999])
maxa=max(meanAS1)
plot,meanAS1-bk1,ht,color=2, background=1,xrange=[0,maxa/10],yrange=[h1,h2],xtitle='count',ytitle='km',$
   title=XC,charsize=2
oplot,meanAS2-bk2,ht,color=180; background=-2,xrange=[0,maxp],yrange=[h1,h2],position=pos2,xtitle='time (min)',ytitle='km',$
;title=XC,charsize=2
write_png,outplot,tvrd(/true)
;plot,A[0,*],ht,color=120,xrange=[0,50],yrange=[0,5],position=p2, xtitle='time (min)',ytitle='km',title='0425 analog channel'

STOP

write_bmp,outplot,tvrd()
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
  y=dz*indgen(Nbin)/1000
  CPPM=AS[na:m-1,*]  ;
  CPPM1=AS1[na:m2-1,*]-bk1/3  ;chan 1 photon counting
  CPPM2=AS2[na:m2-1,*]-bk2/3  ;chan 2  photon counting

 ; CPPD=A[0:m-1,*] ; analog


  col = 240 ; don't change it
  cmin=0;min(AZ);10 is arbitrary set the 5th file
  cmax=0.25*max(CPPM[m/2,bn1:bn2]);for high altitude
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
BAR_0=[0.97,0.2,0.99,0.9]
!p.multi=[0,1,2]

pA =[0.1,0.15,0.90,0.45]


pB =[0.1,0.6,0.90,0.90]
;;;;;;;;;;;;separate two channels;;;;;;;;;;;;;;;;;;;;
read,hx,prompt='top height must be <h2 :';;Read,nf1,nf1,prompt='starting and ending file number: '
   contour,CPPM1,x,y,xtitle='|| channel time starting 9am',ytitle='km',xrange=[0,m/2],yrange=[0,hx],LEVELS = CLEVS, /FILL,$
    C_COLORS = C_INDEX, color=2,/FOLLOW,charsize=1.4, position=pA,title=da+'Channel 1'  ;xyouts,500,5,'fn',color=1,charsize=2

   contour,CPPM2,x,y,ytitle='km',xrange=[0,m/2],yrange=[0,hx],LEVELS = CLEVS, /FILL,$
    C_COLORS = C_INDEX*1, color=2,/FOLLOW,charsize=1.4, position=pB,title=da+'Channel 2'

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

 stop
 outpath2='E:\Lidar_data\'+year+'\CONTOUR\'
 ;cidex=da+'_A.'
 out2=outpath2+da+'_A.'
WRITE_png,OUT2,TVRD(/true)

stop
!p.multi=[0,1,1]
bin1=round(h1*1000/dz)
bin2=round(h2*1000/dz)
 ;plot individual profiles
 plot,smooth(cppm1[0,bin1:bin2],20),ht;xrange=[0,2e7]
 oplot,smooth(cppm1[5,bin1:bin2],20),ht,color=120
 oplot,smooth(cppm1[m/3,100:bin2],20),ht,color=150
;write_png,outplot,tvrd(/true)
stop
end
