Pro STDV_Boundary_layer_Aerosol_A  ;profile of percentage standard deviation of profiles
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
    pr2=fltarr(nx,Nbin)
    ;pr2d=fltarr(nx,Nbin)

    J=0;          count file
    for k=0,m-2,2 do begin
     AS1[J,*]=RAS[k,*]

     AS2[J,*]=RAS[k+1,*]

     Pr2[J,*]=(AS1[J,*]+AS2[J,*])*ht^2


     J=J+1
    endfor; k
;stop
;;;;;;;;;;;;;;;;;;;;;;line plots;;;;;;;;;;;;;;;;;;;;;;;

!p.multi=[0,1,1]

 ; filenm=dnm+'.'+strtrim(I,2)+'m'
outpath='E:\RSI\lidar\Boundarylayer\test\'

XC=da+'-  paralle/perpendicular and sum'
XA=FNMD+'Analog channel'

;m2=round(m/2)
meanAS1=total(AS1,1)/m;
meanAS2=total(AS2,1)/m
meanAS=meanAS1+meanAS2;
maxa=max(meanAS)
plot,meanAS1,ht,color=2, background=-2,xrange=[0,maxa/20],yrange=[h1,h2],xtitle='count',ytitle='km',$
   title='Fig1-'+XC,charsize=1.5
oplot,meanAS2,ht,color=80; background=-2,xrange=[0,maxp],yrange=[h1,h2],position=pos2,xtitle='time (min)',ytitle='km',$
oplot,meanAS,ht,color=200;
;title=XC,charsize=2
outplot=outpath+da+'_meanSig.png'
write_png,outplot,tvrd(/true)
;plot,A[0,*],ht,color=120,xrange=[0,50],yrange=[0,5],position=p2, xtitle='time (min)',ytitle='km',title='0425 analog channel'

STOP

;write_bmp,outplot,tvrd()
close,2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;find ave signals along raw (5 profiles)
 !P.MULTI = [0, 1, 2]
 plot_position1 = [0.1,0.15,0.90,0.45]
 plot_position2 = [0.1,0.65,0.90,0.95];



;;;;;;;;;;;;;********************????????????????????;;;;;;;;;;;;;
 N5=round(m/10)  ; we average 5 files
 ;bin_z=Nbin

 Nbin=1000; reduce height to 3.75 km
 AS12=AS1+AS2 ;[*,0:Nbin-1]
 AS12=AS12[*,0:Nbin-1]

 AVSIG=FLTARR(N5,Nbin)  ; AVE 5 signals M

 STDS=fltarr(N5,Nbin)   ;STDV sig

 PSTD=fltarr(N5,Nbin)  ;percentage STD

k1=0
;;;;average 5 profile as background to calculate SDS
  FOR i=0,nx/2-5,5 do begin

     AVSig[k1,*]=total(AS12[i:i+4,*],1)/5 ;average of every 5 m profiles



    For iy=0,Nbin-1 do begin

      STDS[k1,iy]=STDDEV(AS12[i:i+4,iy])  ;standard dv of 5 m profiles
      PSTD[k1,iy]=STDS[k1,iy]/AVSig[k1,iy]   ;percentage standard deviation

    ;STDS_D[k1,iy]=STDDEV(AS21[i:i+4,iy])   ;std of d files
    ;PSTD_D[k1,iy]=STDS_D[k1,iy]/AVSig_D[k1,iy]     ;percentage STD
    endfor ;iy
   ;print,'k1= /',k1
    k1=k1+1
 endfor  ;i

 ;;;;find peak of %std
 PSTD_PK=fltarr(n5) ; peak percent% of STD
 QJ1=fltarr(n5)     ;question 1
 QJ2=fltarr(n5)      ;question 2
 HJ1=fltarr(n5)     ;height of peak STD
 HJ2=fltarr(n5)     ;ht of peak %STD
 STD_PK=fltarr(n5)

 for Ipk=0,n5-1 do begin
   STD_pk[Ipk]=max(STDS[Ipk,100:500])
   qj1[Ipk]=where(STDS[Ipk,100:500] eq STD_PK[Ipk])
   HJ1[Ipk]=ht[qj1[Ipk]]   ;peak ht of STD

   PSTD_pk[Ipk]=max(PSTD[Ipk,100:550])  ; take data between 0.3 and 2 km
   qj2[Ipk]=where(PSTD[Ipk,*] eq PSTD_PK[Ipk])
   HJ2[Ipk]=ht[qj2[Ipk]]  ;peak ht of %STD
 endfor ; Ipk

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;Find mean and stdv signals over all profiles here (ave of all raw)
;stop
Meansig=fltarr(Nbin)
;Meansig_D=fltarr(Nbin)
MeanP =fltarr(Nbin)


;sum over all profile and take mean

  Meansig=total(AVsig,1)/N5   ;所有的平均 average of all AVsig m profiles
  MeanP=total(PSTD,1)/N5;   [1:N5-1,iy2])

  pksig=max(Meansig[1:Nbin-1])  ;  peakNbin is 6 km
  htpksig=where(Meansig[1:Nbin-1] eq pksig)
  xm=where(ht eq htpksig)

 ;;;;;;p11,...,p22 are for plotting purpose
 p11=max(pksig)            ;peak of pr2m
 p12=ht(htpksig)          ;peak height pr2m
  ;p21=max(pksigD)           ;peak of pr2d
 ;p22=ht(mean(htpksigd))          ;peak ht of pr2d
 pkdata=fltarr(2,2)
 P=[p11,p12]

 print,'peak pr2m values, ht(m)  ',max(pksig),ht(htpksig)


;;;;;;calculate standard deviation


scale1=max(STDS[0:N5-1,*])  ;to plot all profiles
a1=round(scale1/N5)

plot,smooth(PSTD[0,*],5),ht,background=-2,color=2,xrange=[0,n5],yrange=[0,h2],$
 position=Plot_position1,title='Fig2_1% SDev peak D, pk% *, ',xtitle='%',ytitle='km',charsize=1.2;

FOR mi=1,n5-1 do begin
oplot,smooth(PSTD[mi,*],5)+mi,ht,color=4
plots,mi,Hj1[mi],psym=4,color=50
plots,mi,Hj2[mi],psym=2,color=150
endfor


plot,smooth(STDS[0,*],5),ht,background=-2,color=2,xrange=[0,scale1],yrange=[0,h2],$
 position=Plot_position2,title=da+'Fig.2-2 STDV of PR2',xtitle='Pr2',ytitle='meter',charsize=1.2;

FOR mj=1,n5-1 do begin
oplot,smooth(STDS[mj,*],5)+a1*mj,ht,color=4

endfor
;stop
pk1=max(Meansig[100:Nbin-1])  ;peak in the mean profile,Nbin is 6 km
hpk1=where(Meansig [100:Nbin-1] eq pk1)
zm1=where(ht[100:Nbin-1] eq hpk1)
print,"Peak ht of mean Pr2m",zm1,' km, sig= ',pk1

pk2=min(Meansig[100:Nbin-2])
hpk2=where(Meansig [100:Nbin-1] eq pk2)
zm2=where(ht eq hpk2)
print,"Minimum Pr2m",zm2,'  km, sig= ',pk2




stop


 outnm=outpath+da+'Fig2_STD.jpg'
 write_JPEG,outnm,tvrd()
 stop

 ;read,zt,prompt='top km to plot: '
 WINDOW,1

;!P.MULTI = [0, 1, 2]
; plot_position1 = [0.1,0.15,0.90,0.45]
; plot_position2 = [0.1,0.65,0.90,0.95];

  p1=fltarr(n5)
  q1=fltarr(n5)
  t1=fltarr(n5)
  s1=fltarr(n5)
  H_pkstds=fltarr(n5)
  H_pksig=fltarr(n5)
 FOR mp=0,n5-1 do begin
  p1[mp]=max(stds[mp,50:nbin-1])
  q1[mp]=where(stds[mp,*] eq p1[mp])
  ;pkm[mp]=p1
  H_pkSTDS[mp]=ht[q1[mp]]   ;ht of peak STDS
  s1[mp]=max(avsig [mp,50:Nbin-1])
  t1[mp]=where(avsig[mp,50:Nbin-1] eq s1[mp])
  H_pksig[mp]=ht[t1[mp]]  ;ht of peak signal
 endfor
  plot,p1,color=25,background=-2,psym=4,xtitle='#',ytitle='Intensity STD & pk ht (m)',$
  title='Fig.3: heights of peak signal(*) and peak STDS (o)',position=plot_position1

  ;plot,H_pkstds,color=25,background=-2,xtitle='# files',ytitle='ht of peak STD ',position=plot_position3
  oplot,H_pksig*1000,color=50,psym=2
  ;OPLOT,h_PKSIG,COLOR=2
  ;oplot,H_pksig,color=50
  print,'difference ht of pk sig vs STDS:',H_pkSTDS- H_pksig

  mnh1=mean(H_pkstds-H_pksig)
  print,'Mean ht difference: ',mnh1
 ; xyouts,2,900,'mean Dht=',color=100
 ; xyouts,10,800,mnh1,color=100
  ;stop


 ;stop

;stop
AVSTDS =FLTARR(Nbin)
;AVSTDS_D=FLTARR(Nbin)
For iy3=0,Nbin-1 do begin  ;find mean value in the profile 0 to 999elements
  AVSTDS [iy3]=mean(STDS [0:n5-1,iy3])   ;average of every STDV m profiles
  ;AVSTDS_D[iy3]=mean(STDS_D[0:n5/2-1,iy3])    ; av   stdv d files
endfor  ;iy3

plot,ht,meansig ,background=-2,color=2,psym=2,xrange=[0,2],yrange=[0,300],xtitle='ht',position=plot_position2,$
  title='Fig 4 mean signal (*) and 2*AVSTDS ----'
oplot,ht,2*AVSTDS,color=180


pkm=max(avstds [0:Nbin-1])  ;peak in the mean profile,Nbin is 6 km
htpkm=where(avstds [0:Nbin-1] eq pkm)
xm=where(ht eq htpkm)
;pkd=max(avstds_d[0:Nbin-1])  ;Nbin is 6 km
;htpkd=where(avstds_d[0:Nbin-1] eq pkd)

 ;;;;;store pk data in qij
;;; q11=max(avstds )  ;AVE stds m
;;; q12=ht(htpkm)   ;  'ht of peak m
     ;q21=max(avstds_D)
     ;q22=ht(htpkd)
     ;pk=fltarr(2,4)
;;;q=[q11,q12];         ,[q21,q22]]
;;; r1=q11/p11  ;ratio of std to pk signal in m channel
    ; r2=q21/p21  ;ratio as r1 for d channel
    ; xd=where(ht eq htpkd)

print,'peak m values, height ',max(avstds ),ht(htpkm)
;print,'peak d values, ht  ',max(avstds_D),ht(htpkd)
;;;; x1=0;ht(htpkm/2) ;range of plots
 ;;;x2=ht(htpkm*2)  ;right range
 ;;;y1=0
 ;;;y2=q11/2

;plot,ht,r1*AVSTDS_M/q21,xrange=[0,h2],yrange=[0,q11/20],background=-2,color=2,position=plot_position5,$
 ; xtitle='m',ytitle='signal m'
;s1=string(ht(htpkm))+'km'; label
hx=2.
y2=10
xyouts,hx*.5,y2*4,'++mean pr2',color=3
xyouts,hx*0.8,y2*6,p12,color=3
;xyouts,hx*0.5,y2*10,'--- 10*norm.STDV pr2m',color=3
oplot,ht,meansig/p11,psym=1,color=2


outnm2=outpath+da+'pkSTD_1.jpg'

write_JPEG,outnm2,tvrd()
;data1=fltarr(2,4)
opath2=outpath+'pkaerosol\';+da+'_PK.txt'
openw,1,opath2
printf,1,da+'_PK.txt'
printf,1,'peak pr2m and ht(km)/ pr2d and ht(km)',p
;printf,1,p
;printf,1,'peak STDV pr2m and ht(km)/STDV pr2d and ht(km)',q

close,1

stop
read,z2,prompt='top aerosol height km:  '
b2=round(z2*1000/dz)
read,z1,prompt='bottom aerosol height km: < h2: 2 '
b1= round(z1*1000/dz)
;
window,2



p_stds=fltarr(n5); maximum STDS
b_stds=fltarr(n5) ; bin max stds
h_stds=fltarr(n5); ht of peak STDS
;q_stdsd=fltarr(n5/2)
A_stds=stds[*,b1:b2-1]  ;STDS in the range b1 to b2
;B_stdsd=stds_d[*,b1:b2-1]
tm=findgen(n5)

for i2=0,n5-1 do begin
p_stds[i2]=max(A_stds[i2,*]) ;maximum STDS in b1:b2
b_stds[i2]=where(A_stds[i2,*] eq p_stds[i2]); minimum
h_stds[i2]=ht[b_stds[i2]]
endfor
WINDOW,2

;!P.MULTI = [0, 1, 2]

 plot_position1 = [0.1,0.15,0.90,0.45]
 plot_position2 = [0.1,0.65,0.90,0.95];

plot,tm,p_stds[*],psym=2,background=-2,color=2,xtitle='file number_time',ytitle='peak SDS ', position=plot_position2,$
title='Fig5 Pk stds'

;oplot,tm,q_stds[*],psym=5,color=60

stop
plot,tm,h_stds[*]+z1, psym=5,color=50,xtitle='file time',ytitle='peak ht', position=plot_position1,$
title='Fig 6- peak ht of STDS'


xfit1=poly_fit(tm,p_stds,2);   a linefit
y1=xfit1[2]*tm^2+xfit1[1]*tm+xfit1[0]
;oplot,tm,y1,psym=0,color=120
;xyouts,30,200,'y=a+bt,a= / b=';
;xyouts,50,200,xfit1[1]
;xyouts,50,150,xfit1[0]


;APSTD=total(PSTD,1)/N5;

;plot,smooth(APSTD,20),ht,psym=2,background=-2,color=2,xtitle='mean %STDC ',ytitle='km',title='% of STDV'
 ;position=pl2;
;xfit2=poly_fit(tm,q_stdsd,2); a linefit
;y2=xfit2[2]*tm^2+xfit2[1]*tm+xfit2[0]
;oplot,tm,y2,psym=0,color=130

stop

;outpath=bpath+yr+'\OUT_2004\'
outnm2=outpath+da+'pkSTD_time-ht.jpg'

write_JPEG,outnm2,tvrd()
;dat=fltarr(n5/2)
;data2=fltarr(n5/2)
openw,1,outnm2+da+'.txt'
pkSTDS=[P_stds,H_stds]
printf,1,pkstds +'_PK_Ht.txt'
;printf,1,'peak pr2m and ht(km)/ pr2d and ht(km)',p
;printf,1,p
;printf,1,'peak STDV pr2m and ht(km)/STDV pr2d and ht(km)',q
close,1
stop
 end

