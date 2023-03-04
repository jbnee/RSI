Pro FFT_AEROSOL_BACKSCATT_1D
; CARRY OUT fft FOR backscattering coefficient to remove noise

openr,1,'f:\RSI\lidar\FERNALD\Aerosol\Ja15_D1.txt'
Back_D=fltarr(40,440)
hd=''
readf,1,hd
print,hd

readf,1,Back_D
close,1
dz=7.5
H=dz*findgen(1000)/1000
plot,back_d[0,*],H,color=2,background=-2
stop
N = 40. ;
read,i1,i2,prompt='bins for FFT as 500,1000:'

yfft0=fft(back_d[0,*],-1)
yfft0[0]=0
ampyfft=abs(yfft0)

s1=size(ampyfft)
plot,ampyfft,xrange=[0,(i2-i1+1)/2]
stop
freq=findgen(i2-i1+1)
aperd=dz/freq

plot,aperd,ampyfft,xrange=[0,10],color=2,background=-2
stop


y=fltarr(N,i2-i1)
yfft=fltarr(N,i2-i1)
ayfft=fltarr(N,i2-i1)
stop
for i=0,N-1 do begin

y[i,*]=Back_D[i,*]

yfft[i,*]=fft(y(i,*),-1);,/OVERWRITE)
yfft[i,0]=0;   cut the 0th element
ayfft[i,*]=abs(yfft[i,*])

oplot,aperd,ayfft[i,*],color=5*i
endfor
s1=size(ayfft)


;plot,aperd,mean(ayfft[*,i];color=2,background=-2

stop
end