Pro AEROSOL_BACKSCATT_FFT
; CARRY OUT fft FOR backscattering coefficient to remove noise

openr,1,'F:\RSI\lidar\Fernald\Aerosol\Ja15_D.txt'
Back_D=fltarr(4000,40)
readf,1,Back_D
close,1
dz=7.5
H=dz*findgen(1000)/1000
plot,back_d[*,0],H,color=2,background=-2
stop
N = 40. ;


yfft0=fft(back_d[*,0],-1)
yfft0[0]=0
ampyfft=abs(yfft0)
s1=size(ampyfft)
plot,ampyfft,xrange=[0,500]
stop
freq=findgen(500)
p_ht=dz/freq

plot,p_ht,ampyfft
stop
y=fltarr(N)
yfft=fltarr(N)
ayfft=fltarr(N)
read,i1,i2,prompt='bins for FFT as 500,1000:'
for i=0,N-1 do begin

y(i)=Back_D[i1:i2,i]

yfft[i]=fft(y(i),-1);,/OVERWRITE)
yfft[0]=0;   cut the 0th element
ayfft[i]=abs(yfft)
endfor
plot,ayfft,color=2,background=-2

perd=1/s1(1)
plot,perd,ayfft;color=2,background=-2

stop
end