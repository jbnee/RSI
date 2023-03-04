Pro AUTO_ASC_contourplot
; AUTO contour plot for several  ascii txt files
;;;two channel data with even and odd number separately for one of 2 channels
;;;;can be expand to 5 channels
; Variable used

;PS1[J,*]=PS[k,*],PS2[J,*]=PS[k+1,*]
;PR2_1[J,*]=(PS1[J,*]-bk1[j])*ht^2  ; PR2_2[J,*]=(PS2[J,*]-bk2[j])*ht^2
;bk1[J]=mean(PS1[J,3000:4000]);;bk2[J]=mean(PS2[J,3000:4000])
;PR1A=total(PR2_1,1)/m2 ; PR2A=total(PR2_2,1)/m2
;bk1a=mean(pr1A[1000:1499]); bk2a=mean(pr2A[1000:1499])
;P1=smooth(PR1A_sm,300,/edge_truncate);P2=smooth(PR2A_sm,300,/edge_truncate)

;for aerosol bnum=2000


CLOSE,/ALL
ERASE
bnum=8000; total bin number  6000x3.75=22.5 km
T=findgen(bnum)   ; define time
fq=40.0e6 ;  20 or 40 MHz
BT=1/fq ; bin width
v=3.0E8; speed of light
dz=v*BT/2  ;this derive height resolution  3.75m
ht=dz*T/1000.+0.0001   ;convert ht to km and remove 0 as base

FNMD='';  file name

read,fnmd,prompt='Input file date as 0208 ASC:'
year='2022'
 BPATH='F:\LIDAR_DATA\2022\'
 DATAFILES=bpath+fnmd+'\a*';   '0208 ASC\a*'
 nS=FILE_SEARCH(DATAFILES)
 FS=n_elements(nS)
print,'File no: ',Fs
;stop
fileNo=[0,Fs/4,Fs/2,Fs-1]
for ino=0,3 do begin
print,fileno[ino],'  fil:',ns(fileno[ino])
endfor;
stop
read,nf1,nf2,prompt='First and last files to plot: '

read,h1,h2,prompt='Initial and final height as ,1,5 km:'

bn1=round(h1*1000./dz)  ;define range of interest bn1 is the lower bin number
bn2=round(h2*1000./dz)-1  ;upper bin

    nx=nf2-nf1+1  ;nx is the number of total files for example 200 with 100 parallel 100 perpendicular
    DATAB=FLTARR(2,bnum)
    PS=fltarr(nx,bnum) ;Ps photon counting signal
    PSB=fltarr(nx); background
    PS0=fltarr(nx,bnum) ;original PS  Analog signal
    PS=fltarr(nx,bnum); treated PS signal
    PS1=fltarr(nx/2,bnum) ;PS1=fltarr(m/2,bnum) ; parallel
    PS2=fltarr(nx/2,bnum) ; perpendicular
   ;
    PR2_1=fltarr(nx/2,bnum) ; parallel
    PR2_2=fltarr(nx/2,bnum) ;perpendicular
    PR2=fltarr(nx/2,bnum)
    bk1=fltarr(nx/2)
    bk2=fltarr(nx/2)



    BPS=fltarr(nx);  PS background



    close,/all



  ;stop

read,A_P,prompt='Analog or Photon: '

   ;s1=strtrim(fix(ni),2)   ; starting file number
   ;s2=strtrim(fix(nf),2)   ;ending file number
   ;Sw ='      file:'+s1+'_'+s2;used to print title
    sigxm=fltarr(nx,bnum);   signal count in with range bn2-bn1+1)
    ;=fltarr(nx,N)

     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    hd=''

     ; number of files
    ; 0806 take
    ;0807 take 1101:1200 for nf1 and nf2
   ; Read,nf1,nf2,prompt='starting and ending file number: '

    J=0;nf1-1
   FOR i0=nf1-1,nf2-1 DO BEGIN ; open file to read
    dnm=nS[i0];,23,7)
    da=strmid(dnm,19,5)

    OPENR,1,dnm

      FOR h=0,5 do begin ;;;read licel first 5 head lines
        readf,1,hd
        ;print,hd
      endfor   ;h
;;;;;;;;;;;;;;;;;;;; reading data below
    READF,1, DATAB


    PS[j,*]=DATAB[A_P,*]; analog
    ;AS[j,*]=DATAB[1,*]; photon counting
    close,1
    J=J+1
    ENDFOR; i0

   ;stop   ;check error
   ;;;;;;;;;;;;;;;;;;;separate two channel data;;;;;;;;;;;;;;;;;;;
    m2=long(nx/2)

    J=0;          count file
    for k=0,nx-2,2 do begin
     PS1[J,*]=PS[k,*]
     bk1[J]=mean(PS1[J,bnum-500:bnum-10])

     PR2_1[J,*]=(PS1[J,*]-bk1[j])*ht^2  ;chan 1 photon counting
     PR2_1[J,*]=PR2_1[j,*]-min(PR2_1[J,*])
     PS2[J,*]=PS[k+1,*]

     bk2[J]=mean(PS2[J,bnum-500:bnum-10])
     PR2_2[J,*]=(PS2[J,*]-bk2[j])*ht^2  ;chan 2  photon counting
     PR2_2[J,*]=PR2_2[j,*]-min(PR2_2[J,*])
     J=J+1
    endfor; k
    ;plot,bk1A,color=2,background=-2,xtitle='bins',ytitle='background'
     ;oplot,bk2a,color=80
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;check background using channel 1000:15000;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


   PR1A=total(PR2_1,1)/m2
   PR2A=total(PR2_2,1)/m2

   plot,PR1A,ht[0:bnum-1],color=2,background=1,TITLE=da
   oplot,PR2A[0:bnum-1],HT,color=-50

  bk1a=mean(pr1A[bnum-500:bnum-100])
  bk2a=mean(pr2A[bnum-500:bnum-100])
  print,'background:',bk1a,bk2a,'ratio:',bk2a/bk1a

!p.multi=[0,1,1]
window,0
 PR1A_sm=smooth(PR1A,30,/edge_truncate)
 PR2A_sm=smooth(PR2A,30,/edge_truncate)
 ;DPx=smooth(PR2a_sm/Pr1A_sm),40)
 plot,PR1A[0:bnum-1],ht,color=2,background=-1,yrange=[h1,h2],title=DA+' channel #:'+string(nf1)+string(nf2);bin2000:6000'
 oplot,PR2A[0:bnum-1],ht,color=70;

stop
outpath='E:\cirrus clouds\cirrus_2022\'
outplot=outpath+da+'_PR2.png'
write_png,outplot,tvrd(/true)
;XC=da+'-  paralle/perpendicular polarization'
;XA=FNMD+'Analog channel'
;outpath=path+'output\'

 stop


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
 pos1 = [0.1,0.1,0.4,0.9];
 pos2 = [0.6,0.1,0.9,0.9];
   !p.multi=[0,1,1]





  ;na=30 ;reset inital file for error data
  na=0
  m=nx
  x=indgen(m/2-na)
  y=dz*indgen(bnum)/1000
  CPPM=PS[na:m-1,*]  ;


 ; CPPD=A[0:m-1,*] ; analog




  col = 240 ; don't change it
  ;cmin=0.1;min(AZ);10 is arbitrary set the 5th file
   cmax=1*max(Pr2_1[m/3,bn1:bn2]);for high altitude
   cmin=cmax/20.
  ;cmax=1*max(CPPM[m/3,100:1000]); for low altitude
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
   contour,PR2_1,x,y,xtitle='|| channel time starting 9am',ytitle='km',xrange=[0,m/2],yrange=[h1,h2],LEVELS = CLEVS, /FILL,$
    C_COLORS = C_INDEX, color=2,/FOLLOW,charsize=1.4, position=pA,title=da+'Channel 1'  ;xyouts,500,5,'fn',color=1,charsize=2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  cmax=2*max(Pr2_2[m/3,bn1:bn2]);for high altitude
  cmin=cmax/40.
  cint = (cmax-cmin)/nlevs_max
  CLEVS = CMIN + FINDGEN(NLEVS_MAX+1)*CINT

  contour,PR2_2,x,y,ytitle='km',yrange=[h1,h2],LEVELS = CLEVS, /FILL,$
    C_COLORS = C_INDEX, color=2,/FOLLOW,charsize=1.4, position=pB,title=da+'Channel 2'

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
 outpath2='E:\cirrus clouds\cirrus_2022\'
 ;cidex=da+'_A.'
 out2=outpath2+da+'_contourB.png.'
WRITE_png,OUT2,TVRD(/true)

stop
window,0
erase
!p.multi=[0,1,1]
bin1=round(h1*1000/dz)
bin2=round(h2*1000/dz)-1
 PS12=PS1+PS2
plot,smooth(total(PS12[*,bin1:bin2-4],1),20),ht[bn1:bn2-4],color=2,background=-2,$
yrange=[h1,h2],title='sum signals'
;oplot,smooth(total(PS2[*,bin1:bin2-4],1),20),ht[bn1:bn2-4],color=-20;
out3=outpath2+da+'_profiles.png'

write_png,out3,tvrd(/true)
stop
end
