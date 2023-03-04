pro Rayleigh_TK
; accept  two column data of  ht(10-30 km)  and signals
;signals are made by combining all files between 10-30 km from ProRayleigh_lidar_SR430
;
close,/all
g=9.81     ; gravity constant
R=287.0; 1.38E-23  ;8.314   ;J/Kmol
;M=28.97*1.66E-27  ; kg

dz=24      ;height resolution 24 meter
fnm='T_2001ja17a.txt'  ;data of 10-30 km
F1='F:\RSI\lidar\Rayleigh_data\'+fnm;

;f1='f:\RSI\lidar\Rayleigh_data\ja172001.txt'
openr,1,f1
line=''
A0=read_ascii(f1)
Liddata=A0.(0)
M=size(liddata)
print,M
stop
bins=M[2]
Z=fltarr(bins)
;Lidsig=fltarr(2,bins)
T=fltarr(bins)

 !p.multi=[0,1,3]
 PL1 = [0.1,0.15,0.3,0.9]; plot_position=[0.1,0.15,0.95,0.45]
 PL2 = [0.4,0.15,0.6,0.9];
 PL3 = [0.7,0.15,0.9,0.9]

  ;bin30km=30000./dz  ;bin for 30 km

  ht=Liddata[0,*];    ;ht in meters from top down
  h1=ht[0]/1000.
  h2=ht[bins-1]/1000.
  cnt0=liddata[1,*]
  plot,cnt0,ht/1000,color=2,background=-2,yrange=[h1,h2],position=PL3,title='signal count'
  stop
  cnt=cnt0[0:bins-1]
;signal unsmoothed
 smz=smooth(cnt,20)  ;smooth signal

 y1=fltarr(bins)
 Y2a=fltarr(bins)
 Y2b=fltarr(bins)

;;;temperature equation:
;;;;T(z1)=T(z2)*(z2^2/z1^2)*(S(z2)/S(z1))+(g/R)/[(z1^2*s(z1)]*Integral(z^2*s(z) dz)|z1:z2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

z[bins-1]=ht[bins-1]
Y2b[bins-1]=0
T[bins-1]=230   ;k initial condition 230 for 30 km,250 for 40 km
For n=bins-2,0,-1 do begin

 ;i=999-n  ;i=998,997,996,,,,,3,2,1
 z[n]=ht[n]
 Y1[n]=(T[bins-1]*(z[bins-1]/z[n])^2*(smz[bins-1]/smz[n]))
 Y2a[n]=(g/R)/(z[n]^2*Smz[n])
  ;;;; the ingegral below ;;;;;;;;;;;;;;;;
 Y2b[n]=Y2b[n+1]+(dz/2)*(z[n]^2*smz[n]+z[n+1]^2*smz[n+1])
 ;print,z[i]/1000,y1[n],y2a[n],y2b[n],T[n]
 T[n]=Y1[n]+Y2a[n]*Y2b[n]
endfor
;
lo_bin=0;10000./dz  ;10 km
hi_bin=m[2];30000./dz  ;30 km
plot,T[lo_bin:hi_bin-1]-273.15,z/1000,color=2,background=-2,position=PL1,yrange=[10,30]
stop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;Radiosonde data plot;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dnm='cwb20010117.txt'
 ;read,dnm,prompt='Input filename: '
;fname2='f:\radiosonde\test\'+dnm+'.txt'; rsi\cirrus\';   ;35data.txt'
path2='f:\RSI\lidar\rayleigh_data\'
f2=path2+dnm

close,/all

X=read_ascii(f2)
H=X.(0)

s=size(H)
A1=s[1]  ;column #
A2=s[2];   A[2]   ;row #
;;;;remove bins-1
A1=s[1]  ;column #
A2=s[2];   A[2]   ;row #
;;;;remove bins-1
 For i=0,A1-1  do begin; ith column
   For j=0,A2-1 do begin  ;jth raw
   ; A[j,i]=H[j,i]
     if (H[i,j] eq 999.9) then H[i,j]=(H[i,j-1]);+H[i,j-2])/2
         ;if (H[i,j] eq 999.) then H[i,j]=(H[i,j-1]+H[i,j-2])/2
   endfor   ;j
endfor ;i
Htcwb=H[3,*]/1000
;P=H[2,*]
T_cwb=H[4,*]
;RH=H[5,*]
;WD=H[7,*]

 plot,T_cwb,Htcwb,color=2,background=-2,yrange=[10,30],title='CWB',position=PL2


stop
device
!p.multi=0


plot,T-273,Z/1000,color=2,background=-2,xrange=[-100,20],xtitle='Temperature K',ytitle='km',title=fnm
stop
oplot,T_cwb,Htcwb,color=120
stop
f3=path2+'JY17_30.bmp'
write_bmp,f3,tvrd()
stop

end




