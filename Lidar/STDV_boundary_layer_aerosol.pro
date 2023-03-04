Pro STDV_Boundary_layer_Aerosol  ;profile of percentage standard deviation of profiles
close,/all
erase
lodct=5
device,decomposed=0



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


  ; SEARCH files of the day, starting with 0
  JF=0

da=strmid(fnmd,0,4)

print,da  ;day of data

    ;nx=Sf[1]


    bin1=round(h1*1000./dz)  ;define range of interest bn1 is the lower bin number
    bin2=round(h2*1000./dz)  ;upper bin
   ;s1=strtrim(fix(ni),2)   ; starting file number
   ;s2=strtrim(fix(nf),2)   ;ending file number
   ;Sw ='      file:'+s1+'_'+s2;used to print title
   ; sigxm=fltarr(nx,Nbin);   signal count in with range bn2-bn1+1)


     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    hd=''

    NF=SF[1]   ; number of files
    nf1=4         ;LICEL data format inital file number is 5 ignore first 5 data
    nf2=NF-1
    nx=nf2-nf1+1
   ;Read,nf1,nf1,prompt='starting and ending file number: '
     m=nf2-nf1+1  ;m is the number of total files for example 200 with 100 parallel 100 perpendicular
    DATAB=FLTARR(2,Nbin)
    ;PS=fltarr(m,Nbin) ;Ps photon counting signal
    ;PSB=fltarr(m); background
    AS0=fltarr(m,Nbin) ;original As  Analog signal
    AS=fltarr(m,Nbin); treated AS signal
    BAS=fltarr(m);  AS background
    ASX=fltarr(m,Nbin)
    RAS=fltarr(m,Nbin)
    pr2m=fltarr(m/2,Nbin)
    pr2d=fltarr(m/2,Nbin)

    J=0;nf1-1
   FOR I=nf1-1,nf2-1 DO BEGIN ; open file to read
   OPENR,1,fls[I]

      FOR h=0,5 do begin ;;;read licel first 5 head lines
        readf,1,hd
        ;print,hd
      endfor   ;h
;;;;;;;;;;;;;;;;;;;; reading data below
    READF,1, DATAB
    AS0[J,*]=datab[0,*];*(ht*1000)^2; PR2

    BAS[j]=min(datab[0,5500:5999]); background
    ;PS[J,*]=datab[1,*];*(ht*1000)^2
     ; PSB[j]=mean(datab[1,5000:5900]); background
     ; PS[j,*]=PS[j,*]-PSB[j]
    ASx[j,*]=AS0[j,*]-BAS[j]  ;remove background
    close,1
    J=J+1
   ENDFOR;

   stop   ;check error and Interpolation below

   for im=0,m-1 do begin
       Q0=where(ASx[im,*] gt 0)
       ASt=ASx[im,Q0]  ; remove negative and zero terms
       RAS[im,*]=interpol(ASt[q0],ht[q0],ht) ;  refill missing pts

   endfor

   ;stop


   ;;;;;;;;;;;;;;;;;;;separate two channel data;;;;;;;;;;;;;;;;;;;
   ; PS1=fltarr(m/2,Nbin) ;photon  parallel
   ; PS2=fltarr(m/2,Nbin) ;photon perpendicular
    ;ANALOG
    AS1=fltarr(m/2,Nbin) ; parallel
    AS2=fltarr(m/2,Nbin) ;perpendicular
    pr2m=fltarr(nx,Nbin)
    pr2d=fltarr(nx,Nbin)

    J=0;          count file
    for k=0,m-2,2 do begin
     AS1[J,*]=RAS[k,*]
     pr2m[J,*]=RAS[k,*]*ht^2

     AS2[J,*]=RAS[k+1,*]
     Pr2d[J,*]=RAS[k+1,*]*ht^2


     J=J+1
    endfor; k
;stop
;;;;;;;;;;;;;;;;;;;;;;line plots;;;;;;;;;;;;;;;;;;;;;;;

!p.multi=[0,1,1]

 ; filenm=dnm+'.'+strtrim(I,2)+'m'
outpath=path+'plots\'
outplot=outpath+da+'_plot.png'
XC=da+'-  paralle/perpendicular polarization'
XA=FNMD+'Analog channel'

m2=round(m/2)
meanAS1=total(AS1,1)/m2;
meanAS2=total(AS2,1)/m2
maxa=max(meanAS1)
plot,meanAS1,ht,color=2, background=-2,xrange=[0,maxa/2],yrange=[h1,h2],xtitle='count',ytitle='km',$
   title=XC,charsize=2
oplot,meanAS2,ht,color=180; background=-2,xrange=[0,maxp],yrange=[h1,h2],position=pos2,xtitle='time (min)',ytitle='km',$
;title=XC,charsize=2
;write_png,outplot,tvrd()
;plot,A[0,*],ht,color=120,xrange=[0,50],yrange=[0,5],position=p2, xtitle='time (min)',ytitle='km',title='0425 analog channel'

STOP

;write_bmp,outplot,tvrd()
close,2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;find ave signals along raw (5 profiles)
 !P.MULTI = [0, 2, 2]
 plot_position1 = [0.1,0.15,0.45,0.45];
 plot_position2 = [0.1,0.65,0.45,0.95];
 plot_position3 = [0.55,0.15,0.95,0.45];
 plot_position4 = [0.55,0.65,0.95,0.95];
; BAR_POSITION1=[0.95,0.2,0.97,0.45]
 ;BAR_POSITION2=[0.95,0.7,0.97,0.95]
 ;read,year, prompt='year as 2003: ?  '



 N5=round(m/5)  ; we average 5 files
 ;bin_z=Nbin

 Nbin=1000; reduce height to 3.75 km
 AS11=AS1[*,0:Nbin-1]
 AS21=AS2[*,0:Nbin-1]

 AVSIG_M=FLTARR(N5/2,Nbin)  ; AVE 5 signals M
 AVSIG_D=FLTARR(N5/2,Nbin)
 STDS_M=fltarr(N5/2,Nbin)   ;STDV sig
 STDS_D=fltarr(N5/2,Nbin)
 PSTD_M=fltarr(N5/2,Nbin)  ;percentage STD
 PSTD_D=fltarr(N5/2,Nbin)

k1=0
;;;;average 5 profile as background to calculate SDS
  FOR i=0,nx/2-5,5 do begin

  AVSig_M[k1,*]=total(AS11[i:i+4,*],1)/5 ;average of every 5 m profiles
  AVSig_D[k1,*]=total(AS21[i:i+4,*],1)   ;...d files

  For iy=0,Nbin-1 do begin

    STDS_M[k1,iy]=STDDEV(AS11[i:i+4,iy])  ;standard dv of 5 m profiles
    PSTD_M[k1,iy]=STDS_M[k1,iy]/AVSig_M[k1,iy]   ;percentage standard deviation

    STDS_D[k1,iy]=STDDEV(AS21[i:i+4,iy])   ;std of d files
    PSTD_D[k1,iy]=STDS_D[k1,iy]/AVSig_D[k1,iy]     ;percentage STD
  endfor ;iy
   ;print,'k1= /',k1
    k1=k1+1
 endfor  ;i




;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;Find mean and stdv signals over all profiles here (ave of all raw)
stop
Meansig_M=fltarr(Nbin)
Meansig_D=fltarr(Nbin)
Meanp_M=fltarr(Nbin)
Meanp_D=fltarr(Nbin)

;sum over all profile and take mean
  Meansig_M=total(AVsig_M,1)/N5   ;所有的平均 average of all AVsig m profiles
  Meanp_M=total(PSTD_M,1)/N5;   [1:N5-1,iy2])
  Meansig_D=total(AVsig_D,1)/N5;   mean(AVsig_D[1:N5-1,iy2])    ; av   stdv d files
  Meanp_D=total(PSTD_D,1)/N5 ;[1:N5-1,iy2])

  pksigm=max(Meansig_M[1:Nbin-1])  ;  peakNbin is 6 km
  htpksigm=where(Meansig_m[1:Nbin-1] eq pksigm)
  xm=where(ht eq htpksigm)
pksigd=max(Meansig_d[1:Nbin-1])  ;Nbin is 6 km
htpksigd=where(Meansig_d[1:Nbin-1] eq pksigd)
xd=where(ht eq htpksigd)
plot,Meansig_M,ht,background=-2,color=2,yrange=[0,h2],xrange=[0,pksigm],$
 position=Plot_position1,xtitle='Mean PR2_M',ytitle='m';

plot,Meansig_D,ht,background=-2,color=2,yrange=[0,h2],xrange=[0,pksigd],$
 position=Plot_position2,xtitle='Mean PR2_D',ytitle='m',title='Figure 1a';
stop
 ;;;;;;p11,...,p22 are for plotting purpose
 p11=max(pksigM)            ;peak of pr2m
 p12=ht(htpksigm)          ;peak height pr2m
  p21=max(pksigD)           ;peak of pr2d
 p22=ht(mean(htpksigd))          ;peak ht of pr2d
 pkdata=fltarr(2,4)
 P=[[p11,p12],[p21,p22]]
print,'peak pr2m values, ht(m)  ',max(pksigM),ht(htpksigm)
print,'peak pr2d values, ht(m)  ',max(pksigD),ht(htpksigd)
 ;xyouts,max(sig1)/2,max(ht)/2,fn,color=4,charsize=1

;;;;;;calculate standard deviation
 ;read,N,prompt='Total number of data: such as 200:'

;stop
 scale1=max(STDS_M[0:N5/2-1,*])  ;to plot all profiles
a1=round(scale1/N5/2)
scale2=max(STDS_D[0:N5/2-1,*])
a2=round(scale2/N5/2)

plot,smooth(STDS_M[0,*],5),ht,background=-2,color=2,xrange=[0,scale1],yrange=[0,h2],$
 position=Plot_position3,title='St Dev of PR2_M',xtitle='Pr2',ytitle='m';
;oplot,Meansig_M,ht
FOR mm=1,n5/2-1 do begin
oplot,smooth(STDS_M[mm,*],5)+a1*mm,ht,color=4
;oplot,Meansig_M[mm,*],ht
;plot,Meansig_D,ht
endfor
;stop
pk1=max(Meansig_M[0:Nbin-1])  ;peak in the mean profile,Nbin is 6 km
hpk1=where(Meansig_M[0:Nbin-1] eq pk1)
zm1=where(ht eq hpk1)
print,"Peak Pr2m",zm1,'km, sig= ',pk1

plot,smooth(STDS_D[0,*],5),ht,background=-2,color=2,xrange=[0,scale2],yrange=[0,h2],$
 position=Plot_position4, title='Std Dev of PR2_D',ytitle='m';title='figure 1d';

 FOR md=1,n5/2-1 do begin
oplot,smooth(STDS_D[md,*],5)+a2*md,ht,color=4
endfor

stop


 outnm=outpath+da+'fig1_STD.jpg'
 write_JPEG,outnm,tvrd()
 stop

 ;read,zt,prompt='top km to plot: '
 WINDOW,1
 !P.MULTI = [0, 2, 2]
;!P.MULTI = [0, 1, 2]

 ;plot_position5=[0.1,0.15,0.95,0.45]
; plot_position6 = [0.1,0.55,0.95,0.95];
  pkm=fltarr(n5/2)
  pkd=fltarr(n5/2)
  H_pkstdsm=fltarr(n5/2)
  H_pksigm=fltarr(n5/2)
 FOR mp=0,n5/2-1 do begin
  p1=max(stds_m[mp,50:nbin-1])
  q1=where(stds_m[mp,*] eq p1)
  pkm[mp]=p1
  H_pkstdsm[mp]=ht[q1]
  s1=max(avsig_m[mp,50:Nbin-1])
  t1=where(avsig_m[mp,*] eq s1)
  H_pksigm[mp]=ht[mean(t1)]
 endfor
  plot,pkm,color=25,background=-2,psym=4,xtitle='#',ytitle='Intensity STD_m',position=plot_position1
  plot,H_pkstdsm,color=25,background=-2,xtitle='# files',ytitle='ht of peak STD_m',position=plot_position3
  oplot,H_pksigm,color=50,psym=4
  OPLOT,h_PKSIGM,COLOR=2
  oplot,H_pksigm,color=50
  oplot,(H_pkstdsm-H_pksigm)+100,color=120

  mnh1=mean(H_pkstdsm-H_pksigm)
  print,'Mean ht difference: ',mnh1
  xyouts,2,900,'mean Dht=',color=100
  xyouts,10,800,mnh1,color=100
  stop
 pkd=fltarr(n5/2)
 H_pkstdsd=fltarr(n5/2)
 H_pksigd=fltarr(n5/2)
 FOR mq=0,n5/2-1 do begin
  p2=max(stds_d[mq,5:Nbin-1])
  pkd[mq]=p2
  q2=where(stds_d[mq,*] eq p2)
  H_pkstdsd[mq]=ht[q2]
  s2=max(avsig_d[mq,5:Nbin-1])
  t2=where(avsig_d[mq,*] eq s2)
  t2=max(t2)
  H_pksigd[mq]=ht[t2]
 endfor
  plot,pkd,color=4,background=-2,psym=4,xtitle='#',ytitle='Intensity STD_d',position=plot_position2,title='Int pk sig & stds'
  plot,H_pkstdsd,color=4,background=-2,xtitle='sq_pksig,line std',ytitle='ht of peak STD_d',position=plot_position4,title='pk ht sig & stds'
  oplot,H_pksigd,color=50,psym=4
  oplot,H_pksigd,color=50
  oplot,H_pkstdsd-pksigd+100,color=120
  mnh2=mean(H_pkstdsd-H_pksigd)
  print,'mean_ht difference: '
  xyouts,25,900,'mean Dht=',color=100
  xyouts,30,900,mnh1,color=100
stop


 outnm=outpath+da+'ht_STD.jpg'
 write_JPEG,outnm,tvrd()
 stop

 ; plot,PSTD_D[0,*],ht,background=-2,color=2,xrange=[0,scale2],yrange=[0,z],$
; position=Plot_position6, title='% Std Dev of PR2_D',ytitle='m';title='figure 1d';

; FOR mp=1,n5/2-1 do begin
;  oplot,PSTD_D[mp,*]+a2*mp,ht,color=4
;endfor
;stop
AVSTDS_M=FLTARR(Nbin)
AVSTDS_D=FLTARR(Nbin)
For iy3=0,Nbin-1 do begin  ;find mean value in the profile 0 to 999elements
  AVSTDS_M[iy3]=mean(STDS_M[0:n5/2-1,iy3])   ;average of every STDV m profiles
  AVSTDS_D[iy3]=mean(STDS_D[0:n5/2-1,iy3])    ; av   stdv d files
endfor  ;iy3

;!P=[0,1,1]
plot_position5=[0.1,0.15,0.95,0.45]
plot_position6=[0.1,0.55,0.95,0.95]
!P.MULTI = [0, 1, 2]
pkm=max(avstds_m[0:Nbin-1])  ;peak in the mean profile,Nbin is 6 km
htpkm=where(avstds_m[0:Nbin-1] eq pkm)
xm=where(ht eq htpkm)
pkd=max(avstds_d[0:Nbin-1])  ;Nbin is 6 km
htpkd=where(avstds_d[0:Nbin-1] eq pkd)

 ;;;;;store pk data in qij
 q11=max(avstds_M)  ;AVE stds m
 q12=ht(htpkm)   ;  'ht of peak m
 q21=max(avstds_D)
 q22=ht(htpkd)
 ;pk=fltarr(2,4)
 q=[[q11,q12],[q21,q22]]
 r1=q11/p11  ;ratio of std to pk signal in m channel
 r2=q21/p21  ;ratio as r1 for d channel
 ; xd=where(ht eq htpkd)

print,'peak m values, height ',max(avstds_M),ht(htpkm)
print,'peak d values, ht  ',max(avstds_D),ht(htpkd)
 x1=0;ht(htpkm/2) ;range of plots
 x2=ht(htpkm*2)  ;right range
 y1=0
 y2=q11/2
plot,ht,meansig_M,background=-2,color=2,psym=0,xrange=[0,h2],position=plot_position5,xtitle='ht_m'
oplot,ht,5*AVSTDS_M,psym=1,color=180
;plot,ht,r1*AVSTDS_M/q21,xrange=[0,h2],yrange=[0,q11/20],background=-2,color=2,position=plot_position5,$
 ; xtitle='m',ytitle='signal m'
;s1=string(ht(htpkm))+'km'; label
hx=2.
y2=10
xyouts,hx*.5,y2*5,'++mean pr2m',color=3
xyouts,hx*0.8,y2*8,p12,color=3
xyouts,hx*0.5,y2*10,'--- 10*norm.STDV pr2m',color=3
;oplot,ht,meansig_M/p11,psym=1,color=2
xyouts,hx*0.8,y2*1,q12,color=3

plot,ht,meansig_D,background=-2,color=2,psym=0,xrange=[0,h2],position=plot_position6,xtitle='ht_D',title='Figure 2/3'
oplot,ht,1.2*AVSTDS_D,psym=1,color=180
;plot,ht,r2*AVSTDS_D/q21,xrange=[0,h2],yrange=[0,q11/40],background=-2,color=2,position=plot_position6,$
;ytitle='signal d'
;s2='--N STDV pr2d'+string(ht(htpkd))+'km'

xyouts,hx*.5,y2*5,'++mean Pr2d',color=3
xyouts,hx*0.8,y2*8,p22,color=3
xyouts,hx*0.5,y2*10, '--10*norm STDV pr2d',color=3
xyouts,hx*0.75,y2,q22,color=3
;oplot,ht,meansig_D/p21,psym=1,color=2
print,'mean m and d signal heights',p
print,'mean std m and d heights',q
stop
outnm2=outpath+da+'pkSTD_1.jpg'

write_JPEG,outnm2,tvrd()
data1=fltarr(2,4)
opath2=outpath+'pkaerosol\';+da+'_PK.txt'
openw,1,opath2
printf,1,da+'_PK.txt'
printf,1,'peak pr2m and ht(km)/ pr2d and ht(km)',p
;printf,1,p
printf,1,'peak STDV pr2m and ht(km)/STDV pr2d and ht(km)',q

close,1

stop
read,z2,prompt='top aerosol height km:  '
b2=round(z2*1000/dz)
read,z1,prompt='bottom aerosol height km:  '
b1= round(z1*1000/dz)
;
p_stdsm=fltarr(n5/2)
q_stdsd=fltarr(n5/2)
A_stdsm=stds_m[*,b1:b2-1]
B_stdsd=stds_d[*,b1:b2-1]
tm=findgen(n5/2)

for i2=0,n5/2-1 do begin
p_stdsm[i2]=max(A_stdsm[i2,*])
q_stdsd[i2]=max(B_stdsd[i2,*])
endfor
plot,tm,p_stdsm[*],psym=2,background=-2,color=2,xtitle='file number_time',ytitle='peak SDS_m',title=da
xfit1=poly_fit(tm,p_stdsm,2); a linefit
y1=xfit1[2]*tm^2+xfit1[1]*tm+xfit1[0]
oplot,tm,y1,psym=0,color=120
xyouts,30,200,'y=a+bt,a= / b=';
xyouts,50,200,xfit1[1]
xyouts,50,150,xfit1[0]
plot,tm,q_stdsd[*],psym=2,background=-2,color=2,xtitle='file number_time',ytitle='peak SDS_d',title='time variation of SDS'
xfit2=poly_fit(tm,q_stdsd,2); a linefit
y2=xfit2[2]*tm^2+xfit2[1]*tm+xfit2[0]
oplot,tm,y2,psym=0,color=130

stop

;outpath=bpath+yr+'\OUT_2004\'
outnm2=outpath+da+'pkSTD_t.jpg'

write_JPEG,outnm2,tvrd()
dat=fltarr(n5/2)
;data2=fltarr(n5/2)
openw,1,outpath+da+'_dat.txt'
printf,1,p_stdsm; +'_PK.txt'
;printf,1,'peak pr2m and ht(km)/ pr2d and ht(km)',p
;printf,1,p
;printf,1,'peak STDV pr2m and ht(km)/STDV pr2d and ht(km)',q
close,1
stop
 end

