Pro STDV_M_Aerosol  ;profile of percentage standard deviation of profiles
close,/all
lodct=5
device,decomposed=0
!P.MULTI = [0, 2, 2]
 plot_position1 = [0.1,0.15,0.45,0.45]; plot_position1=[0.1,0.15,0.95,0.45]
 plot_position2 = [0.1,0.65,0.45,0.95]; plot_position2=[0.1,0.6,0.95,0.95]
 plot_position3 = [0.55,0.15,0.95,0.45]; plot_position=[0.1,0.15,0.95,0.45]
 plot_position4 = [0.55,0.65,0.95,0.95]; plot_position2=[0.1,0.6,0.95,0.95]
; BAR_POSITION1=[0.95,0.2,0.97,0.45]
 ;BAR_POSITION2=[0.95,0.7,0.97,0.95]
 read,year, prompt='year as 2003: ?  '

 ;year=2003
; print,'year= ',year
 yr=string(year,format='(I4.4)')
 dnm=''
 month=''
  read,dnm,prompt='data filename as ja212012;MR071925:  '
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
   datab1=read_binary(fn0,DATA_TYPE=2)
  sig1[0,*]=datab1[0:bin_z-1]
  pr2m[0,*]=sig1[0,*]*ht1*ht1
  plot_position=[0.1,0.15,0.95,0.45]

  j=1

 FOR nm=ni+1,nf do begin

   sn=strtrim(fix(nm),2)
  ;ln=strlen(sn)

   fn=fnm+strtrim(sn,2)+'M'
   fn2=fnm+strtrim(sn,2)+'D'

   datab1=read_binary(fn,DATA_TYPE=2)
    datab2=read_binary(fn2,DATA_TYPE=2)

   bk1=min(datab1[bnum/2:bnum])
   bk2=min(datab2[bnum/2:bnum])
   sig1=datab1[0:bin_z-1]-bk1
    if min(sig1) le 0 then sig1=sig1-min(sig1)                ;parallel m file
   pr2m[j,*]=sig1*ht1^2+1


 j=j+1
 endfor
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;find ave signals along raw (5 profiles)
 N5=round(nx/5)  ; we average 5 files

 AVSIG_M=FLTARR(N5,bin_z)

 STDS_M=fltarr(N5,bin_z)

 RRm=fltarr(N5,bin_z)


k1=0
;;;;average 5 profile as background to calculate SDS
FOR i=0 , nx-5, 5 do begin
For iy=0,bin_z-1 do begin
 AVSig_M[k1,iy]=MEAN(pr2m[i:i+4,iy]/(ht1[iy]^2))  ;average of every 5 m profiles
 STDS_M[k1,iy]=STDDEV(pr2m[i:i+4,iy]/(ht1[iy]^2))  ;standard dv of 5 m profiles

   ;percentage standard deviation

endfor  ;i
k1=k1+1
endfor  ;iy

for kr=0,n5-1 do begin
RRm[kr,*]=smooth(STDS_M[kr,*]/AVSig_M[kr,*],10)

endfor; kr
stop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;Find mean and stdv signals over all profiles here (ave of all raw)

Meansig_M=fltarr(bin_z)
;Meansig_D=fltarr(bin_z)
Meanp_M=fltarr(bin_z)
Mean_RRm=fltarr(bin_z);

;sum over all profile and take mean
  Meansig_M=total(AVsig_M,1)/N5   ;所有的平均 average of all AVsig m profiles
  Mean_RRm=total(RRm,1)/N5;   [1:N5-1,iy2])



  pksigm=max(Meansig_M[1:bin_z-1])  ;  peak bin_z is 6 km
  htpksigm=where(Meansig_m[1:bin_z-1] eq pksigm) ;finding pk
  xm=where(ht1 eq htpksigm)     ;finding peak ht
  pkRRm=max(Mean_RRm [1:bin_z-1]) ;peak mean RRm

plot,Meansig_M,ht1,background=-2,color=2,yrange=[0,z],xrange=[0,pksigm],$
 position=Plot_position1,xtitle='Mean PR2_M',ytitle='m';
plot,Mean_RRm,ht1,background=-2,color=2,yrange=[0,z],xrange=[0,pkRRm],$
 position=Plot_position2,xtitle='Mean RRm',ytitle='m',title='stdv/avsig';
 ;;;;;;p11,...,p22 are for plotting purpose
 p11=max(pksigM)            ;peak of pr2m
 p12=ht1(htpksigm)          ;peak height pr2m
stop
 ; p21=max(pksigD)           ;peak of pr2d
 ;p22=ht1(mean(htpksigd))          ;peak ht of pr2d
 ;pkdata=fltarr(2,4)
;P=[[p11,p12],[p21,p22]]
;print,'peak pr2m values, ht(m)  ',max(pksigM),ht1(htpksigm)
;print,'peak pr2d values, ht(m)  ',max(pksigD),ht1(htpksigd)
 ;xyouts,max(sig1)/2,max(ht1)/2,fn,color=4,charsize=1

;;;;;;calculate standard deviation
 ;read,N,prompt='Total number of data: such as 200:'

;stop
 scale1=max(STDS_M[0:N5-1,*])  ;to plot all profiles
a1=round(scale1/N5)
scale2=max(RRm[0:N5-1,*])
a2=round(scale2/N5)

plot,smooth(STDS_M[0,*],5),ht1,background=-2,color=2,xrange=[0,scale1],yrange=[0,z],$
 position=Plot_position3,xtitle='STDev of PR2_M',ytitle='m'

plot,smooth(RRm[0,*],5),ht1,background=-2,color=2,xrange=[0,scale2],yrange=[0,z],$
 position=Plot_position4,title='%STDV:RR_M',xtitle='%,RRM',ytitle='m';
;oplot,Meansig_M,ht1


stop


 outnm=opath+dnm+'fig1_STD.jpg'
 write_JPEG,outnm,tvrd()
 stop
 !p.MULTI=[0,1,1]
 WINDOW,1
 PLOT,RRM[0,*],HT1,YRANGE=[0,3000],xrange=[0,80],COLOR=2,BACKGROUND=-2

FOR I3=1,N5-1 DO BEGIN
OPLOT,RRM[I3,*]+i3*2,HT1,COLOR=2
ENDFOR
STOP
x=indgen(N5)
y=ht1


outnm=opath+dnm+'RRM.jpg'
 write_JPEG,outnm,tvrd()
 stop

pkR=fltarr(N5)
hpkR=fltarr(N5)
zmR=fltarr(N5)
;hpkR=fltarr(N5)

For nr=0,N5-1 do begin
 pkR[nr]=max(RRM[Nr,0:bin_z-1])  ;peak in the mean profile, bin_z is 6 km
 hpkR[nr]=where(RRM[Nr,0:bin_z-1] eq pkR[nr])
 zmR[nr]=ht1[hpkR[Nr]]
endfor; Nr

window,2
!p.MULTI=[0,1,1]
plot,pkR,zmR,color=2,background=-2,psym=4,title='Distribution',xtitle='peak %RRM',ytitle='m'
;print,"Peak Pr2m",zm1,'km, sig= ',pk1

 outnm2=opath+dnm+'fig2_STDS_Distribution.jpg'
 write_JPEG,outnm2,tvrd()

stop
end



