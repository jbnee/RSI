Pro STD_Aerosol  ;profile of percentage standard deviation of profiles
close,/all
!P.MULTI = [0, 2, 2]
 plot_position1 = [0.1,0.15,0.45,0.45]; plot_position1=[0.1,0.15,0.95,0.45]
 plot_position2 = [0.1,0.55,0.45,0.95]; plot_position2=[0.1,0.6,0.95,0.95]
 plot_position3 = [0.55,0.15,0.95,0.45]; plot_position=[0.1,0.15,0.95,0.45]
 plot_position4 = [0.55,0.55,0.95,0.95]; plot_position2=[0.1,0.6,0.95,0.95]
; BAR_POSITION1=[0.95,0.2,0.97,0.45]
 ;BAR_POSITION2=[0.95,0.7,0.97,0.95]
 ;read,year, prompt='year as 2003: ?  '

 year=2003
 print,'year= ',year
 yr=string(year,format='(I4.4)')
 dnm=''
 month=''
  read,dnm,prompt='data filename as ja212012;mr022018:  '
  month=strmid(dnm,0,2)

 bpath='f:\Lidar_data\'  ;   systems\depolar\'
 fpath=bpath+yr+'\'+month+'\'
 opath=bpath+yr+'\out_2003\'
 fnm=fpath+dnm+'.'
 read,zkm,prompt='top height km:  '
 z=zkm*1000.
 bin_z=round(z/24.)  ;bin number for peak km 5/0.024
;path='F:\Lidar systems\LidarPro\depolar\'; 2002\mr\'

 ;read,filenm,prompt='filename as mr080015.'
;filenm ='mr190111.';'mr080015.'; 'mr072150.'; 'mr182309.';  'jn022058.';  'mr312023.';202312.';192330.'; 192028.';190111.'; 182309.';  ap022014.' ;
 ;file_basename=path+filenm
 read,ni,nf, prompt='Initial and file number as 1,99: '
  nx=nf-ni+1  ;num of files to treat
  bnum=4000
  T=findgen(bnum); to avoid 0
  pr2m=fltarr(nx,bin_z)
  pr2d=fltarr(nx,bin_z)
  sig1=fltarr(nx,bin_z)
  sig2=fltarr(nx,bin_z)
  bw=24.   ;bin width
  bt=160E-9 ; 160 ns
  ht0=3.0E8*bt*T/2.    ; ht1 in m
  ht1=ht0[1:bin_z+1]
   sn=strtrim(fix(ni),1)
   fn0=fnm+strtrim(sn,1)+'M'
   datab0=read_binary(fn0,DATA_TYPE=2)
  sig1[0,*]=datab0[0:bin_z-1]
  pr2m[0,*]=sig1[0,*]*ht1*ht1
  plot_position=[0.1,0.15,0.95,0.45]
  ;plot,pr2m[0,*],ht1,background=-2,color=2,yrange=[0,5],xrange=[0,3000],position=Plot_position,$
      ; xtitle='Signal/channel',ytitle='km'

  j=1

 FOR nm=ni+1,nf do begin

   sn=strtrim(fix(nm),2)
  ;ln=strlen(sn)

   fn=fnm+strtrim(sn,2)+'M'
   fn2=fnm+strtrim(sn,2)+'D'

   datab=read_binary(fn,DATA_TYPE=2)
    datab2=read_binary(fn2,DATA_TYPE=2)

   bk1=mean(datab[bnum/2:bnum])
   bk2=mean(datab2[bnum/2:bnum])
   sig1=datab[0:bin_z-1]-bk1                  ;parallel m file
   pr2m[j,*]=sig1*ht1^2

   sig2=datab2[0:bin_z-1]-bk2               ;perpendicular d files
   pr2d[j,*]=sig2*ht1^2
   ;oplot,pr2m[j,*]+j*50,ht1,color=2;
  ;xyouts,max(sig1)/2,max(ht1)/2,nm,color=4,charsize=2
 ;wait,1
 j=j+1
 endfor
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;find ave signals along raw (5 profiles)
 N5=round(nx/5)  ; we average 5 files

 AVSIG_M=FLTARR(N5,bin_z)
 AVSIG_D=FLTARR(N5,bin_z)
 STDS_M=fltarr(N5,bin_z)
 STDS_D=fltarr(N5,bin_z)
 PSTD_M=fltarr(N5,bin_z)
 PSTD_D=fltarr(N5,bin_z)
k1=0
;;;;average 5 profile as background to calculate SDS
FOR i=0 , nx-5, 5 do begin
For iy=0,bin_z-1 do begin
AVSig_M[k1,iy]=MEAN(pr2m[i:i+4,iy]/(ht1[iy]^2))  ;average of every 5 m profiles
STDS_M[k1,iy]=STDDEV(pr2m[i:i+4,iy]/(ht1[iy]^2))  ;standard dv of 5 m profiles
PSTD_M[k1,iy]=STDS_M[k1,iy]/AVSig_M[k1,iy]   ;percentage standard deviation
AVSig_D[k1,iy]=MEAN(pr2d[i:i+4,iy]/(ht1[iy]^2))   ;...d files
STDS_D[k1,iy]=STDDEV(pr2d[i:i+4,iy]/(ht1[iy]^2))   ;std of d files
PSTD_D[k1,iy]=STDS_D[k1,iy]/AVSig_D[k1,iy]     ;percentage STD
endfor  ;i
k1=k1+1
endfor  ;iy
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;Find mean and stdv signals over all profiles here (ave of all raw)

Meansig_M=fltarr(bin_z)
Meansig_D=fltarr(bin_z)
Meanp_M=fltarr(bin_z)
Meanp_D=fltarr(bin_z)

For iy2=0,bin_z-1 do begin
  Meansig_M[iy2]=mean(AVsig_M[1:N5-1,iy2])   ;所有的平均 average of all AVsig m profiles
  Meanp_M=mean(PSTD_M[1:N5-1,iy2])
  Meansig_D[iy2]=mean(AVsig_D[1:N5-1,iy2])    ; av   stdv d files
  Meanp_D=mean(PSTD_D[1:N5-1,iy2])
endfor  ;iy2
pksigm=max(Meansig_M[1:bin_z-1])  ;  peak bin_z is 6 km
htpksigm=where(Meansig_m[1:bin_z-1] eq pksigm)
xm=where(ht1 eq htpksigm)
pksigd=max(Meansig_d[1:bin_z-1])  ;bin_z is 6 km
htpksigd=where(Meansig_d[1:bin_z-1] eq pksigd)
xd=where(ht1 eq htpksigd)
plot,Meansig_M,ht1,background=-2,color=2,yrange=[0,z],xrange=[0,pksigm],$
 position=Plot_position1,xtitle='Mean PR2_M',ytitle='m';
plot,Meansig_D,ht1,background=-2,color=2,yrange=[0,z],xrange=[0,pksigd],$
 position=Plot_position2,xtitle='Mean PR2_D',ytitle='m',title='Figure 1a';
 ;;;;;;p11,...,p22 are for plotting purpose
 p11=max(pksigM)            ;peak of pr2m
 p12=ht1(htpksigm)          ;peak height pr2m
  p21=max(pksigD)           ;peak of pr2d
 p22=ht1(mean(htpksigd))          ;peak ht of pr2d
 pkdata=fltarr(2,4)
 P=[[p11,p12],[p21,p22]]
print,'peak pr2m values, ht(m)  ',max(pksigM),ht1(htpksigm)
print,'peak pr2d values, ht(m)  ',max(pksigD),ht1(htpksigd)
 ;xyouts,max(sig1)/2,max(ht1)/2,fn,color=4,charsize=1

;;;;;;calculate standard deviation
 ;read,N,prompt='Total number of data: such as 200:'

;stop
 scale1=max(STDS_M[0:N5-1,*])  ;to plot all profiles
a1=round(scale1/N5)
scale2=max(STDS_D[0:N5-1,*])
a2=round(scale2/N5)

plot,smooth(STDS_M[0,*],5),ht1,background=-2,color=2,xrange=[0,scale1],yrange=[0,z],$
 position=Plot_position3,title='St Dev of PR2_M',xtitle='Pr2',ytitle='m';
;oplot,Meansig_M,ht1
FOR mm=1,N5-1 do begin
oplot,smooth(STDS_M[mm,*],5)+a1*mm,ht1,color=4
;oplot,Meansig_M[mm,*],ht1
;plot,Meansig_D,ht1
endfor
;stop
pk1=max(Meansig_M[0:bin_z-1])  ;peak in the mean profile, bin_z is 6 km
hpk1=where(Meansig_M[0:bin_z-1] eq pk1)
zm1=where(ht1 eq hpk1)
print,"Peak Pr2m",zm1,'km, sig= ',pk1

plot,smooth(STDS_D[0,*],5),ht1,background=-2,color=2,xrange=[0,scale2],yrange=[0,z],$
 position=Plot_position4, title='Std Dev of PR2_D',ytitle='m';title='figure 1d';

 FOR md=1,N5-1 do begin
oplot,smooth(STDS_D[md,*],5)+a2*md,ht1,color=4
endfor

stop
; opath=bpath+yr+'\out_2003\'


 read,zt,prompt='top km to plot: '
 bzt=round(zt*1000/bw)

!P.MULTI = [0, 1, 2]

 plot_position5=[0.1,0.15,0.95,0.45]
 plot_position6 = [0.1,0.55,0.95,0.95];
  ; plot,PSTD_M[0,*],ht1,background=-2,color=2,xrange=[0,scale2],yrange=[0,z],$
;  position=Plot_position5, title='% Std Dev of PR2_M',ytitle='m';title='figure 1d';
  pkstdsm=fltarr(N5)
  pksigm=fltarr(N5)
 FOR mp=0,N5-1 do begin
  p1=max(stds_m[mp,5:bzt])
  q1=where(stds_m[mp,*] eq p1)
  pkstdsm[mp]=ht1[q1]
  s1=max(avsig_m[mp,5:bzt])
  t1=where(avsig_m[mp,*] eq s1)
  pksigm[mp]=ht1[t1]
 endfor

  plot,pkstdsm,color=4,background=-2,xtitle='# files',ytitle='ht of peak STD_m',position=plot_position5
  oplot,pksigm,color=50,psym=4
  oplot,pksigm,color=50
  oplot,(pkstdsm-pksigm)+100,color=120

  mnh1=mean(pkstdsm-pksigm)
  xyouts,25,900,'mean Dht=',color=100
  xyouts,30,900,mnh1,color=100
  stop

 pkstdsd=fltarr(N5)
 pksigd=fltarr(N5)
 FOR mq=0,N5-1 do begin
  p2=max(stds_d[mq,5:bzt])
  q2=where(stds_d[mq,*] eq p2)
  pkstdsd[mq]=ht1[q2]
  s2=max(avsig_d[mq,5:bzt])
  t2=where(avsig_d[mq,*] eq s2)
  pksigd[mq]=ht1[t2]
 endfor
  plot,pkstdsd,color=4,background=-2,xtitle='# files',ytitle='ht of peak STD_d',position=plot_position6,title='pk ht sig & stds'
  oplot,pksigd,color=50,psym=4
  oplot,pksigd,color=50
  oplot,pkstdsd-pksigd+100,color=120
  mnh2=mean(pkstdsd-pksigd)
  xyouts,25,900,'mean Dht=',color=100
  xyouts,30,900,mnh1,color=100
stop


 outnm=opath+dnm+'ht_STD.jpg'
 write_JPEG,outnm,tvrd()
 stop

 ; plot,PSTD_D[0,*],ht1,background=-2,color=2,xrange=[0,scale2],yrange=[0,z],$
; position=Plot_position6, title='% Std Dev of PR2_D',ytitle='m';title='figure 1d';

; FOR mp=1,N5-1 do begin
;  oplot,PSTD_D[mp,*]+a2*mp,ht1,color=4
;endfor
;stop
AVSTDS_M=FLTARR(bin_z)
AVSTDS_D=FLTARR(bin_z)
For iy3=0,bin_z-1 do begin  ;find mean value in the profile 0 to 999elements
  AVSTDS_M[iy3]=mean(STDS_M[0:N5-1,iy3])   ;average of every STDV m profiles
  AVSTDS_D[iy3]=mean(STDS_D[0:N5-1,iy3])    ; av   stdv d files
endfor  ;iy3

;!P=[0,1,1]
plot_position5=[0.1,0.15,0.95,0.45]
plot_position6=[0.1,0.55,0.95,0.95]
!P.MULTI = [0, 1, 2]
pkm=max(avstds_m[0:bin_z-1])  ;peak in the mean profile, bin_z is 6 km
htpkm=where(avstds_m[0:bin_z-1] eq pkm)
xm=where(ht1 eq htpkm)
pkd=max(avstds_d[0:bin_z-1])  ;bin_z is 6 km
htpkd=where(avstds_d[0:bin_z-1] eq pkd)

 ;;;;;store pk data in qij
 q11=max(avstds_M)  ;AVE stds m
 q12=ht1(htpkm)   ;  'ht of peak m
 q21=max(avstds_D)
 q22=ht1(htpkd)
 ;pk=fltarr(2,4)
 q=[[q11,q12],[q21,q22]]
 r1=q11/p11  ;ratio of std to pk signal in m channel
 r2=q21/p21  ;ratio as r1 for d channel
 ; xd=where(ht1 eq htpkd)

print,'peak m values, height ',max(avstds_M),ht1(htpkm)
print,'peak d values, ht  ',max(avstds_D),ht1(htpkd)
 x1=0;ht1(htpkm/2) ;range of plots
 x2=ht1(htpkm*2)  ;right range
 y1=0
 y2=q11/2
plot,ht1,meansig_M,background=-2,color=2,psym=0,xrange=[0,z],position=plot_position5,xtitle='ht_m'
oplot,ht1,5*AVSTDS_M,psym=1,color=180
;plot,ht1,r1*AVSTDS_M/q21,xrange=[0,z],yrange=[0,q11/20],background=-2,color=2,position=plot_position5,$
 ; xtitle='m',ytitle='signal m'
;s1=string(ht1(htpkm))+'km'; label
xyouts,z*.5,y2*5,'++mean pr2m',color=3
xyouts,z*0.8,y2*5,p12,color=3
xyouts,z*0.5,y2*1.5,'--- 10*norm.STDV pr2m',color=3
;oplot,ht1,meansig_M/p11,psym=1,color=2
xyouts,z*0.8,y2*1.0,q12,color=3

plot,ht1,meansig_D,background=-2,color=2,psym=0,xrange=[0,z],position=plot_position6,xtitle='ht_D',title='Figure 2/3'
oplot,ht1,1.2*AVSTDS_D,psym=1,color=180
;plot,ht1,r2*AVSTDS_D/q21,xrange=[0,z],yrange=[0,q11/40],background=-2,color=2,position=plot_position6,$
;ytitle='signal d'
;s2='--N STDV pr2d'+string(ht1(htpkd))+'km'
xyouts,z*.5,y2*5,'++mean Pr2d',color=3
xyouts,z*0.8,y2*5,p22,color=3
xyouts,z*0.5,y2*3, '--10*norm STDV pr2d',color=3
xyouts,z*0.75,y2*3,q22,color=3
;oplot,ht1,meansig_D/p21,psym=1,color=2
print,'mean m and d signal heights',p
print,'mean std m and d heights',q
stop
outnm2=opath+dnm+'pkSTD_1.jpg'

write_JPEG,outnm2,tvrd()
data1=fltarr(2,4)
opath2=opath+'pkaerosol\';+dnm+'_PK.txt'
openw,1,opath2
printf,1,dnm+'_PK.txt'
printf,1,'peak pr2m and ht(km)/ pr2d and ht(km)',p
;printf,1,p
printf,1,'peak STDV pr2m and ht(km)/STDV pr2d and ht(km)',q

close,1

stop
read,h1,prompt='top aerosol height km:  '
b1=round(h1/0.024)
read,h2,prompt='bottom aerosol height km:  '
b2=round(h2/0.024)
;A_stds_m=fltarr(N5,b
p_stdsm=fltarr(N5)
q_stdsd=fltarr(N5)
A_stdsm=stds_m[*,b2:b1]
B_stdsd=stds_d[*,b2:b1]
tm=findgen(N5)

for i2=0,N5-1 do begin
p_stdsm[i2]=max(A_stdsm[i2,*])
q_stdsd[i2]=max(B_stdsd[i2,*])
endfor
plot,tm,p_stdsm[*],psym=2,background=-2,color=2,xtitle='file number_time',ytitle='peak SDS_m',title=dnm
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
outnm2=opath+dnm+'pkSTD_t.jpg'

write_JPEG,outnm2,tvrd()
dat=fltarr(N5)
;data2=fltarr(N5)
openw,1,opath+dnm+'_dat.txt'
printf,1,p_stdsm; +'_PK.txt'
;printf,1,'peak pr2m and ht(km)/ pr2d and ht(km)',p
;printf,1,p
;printf,1,'peak STDV pr2m and ht(km)/STDV pr2d and ht(km)',q
close,1
stop
 end

