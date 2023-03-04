pro Lidar_Hamm_window
; CARRY OUT fft FOR backscattering coefficient to remove noise
close,/all
openr,1,'F:\RSI\lidar\Fernald\aerosol\Ja15_D1.txt'


Back_D=fltarr(4000)
readf,1,Back_D
close,1
dz=7.5
H=dz*findgen(1000)/1000
plot,back_d[*,0],H,color=2,background=-2
stop
close,1
;
N=4000
f=indgen(N)+1
yfft0=fft(back_d,-1)
yfft0[0]=0
ampyfft=abs(yfft0)
s1=size(ampyfft)
plot,f,ampyfft,xrange=[0,N/5],color=2,background=-2
stop
NH=20
k=hanning(NH)
Hafft=convol(ampyfft,k,/edge_truncate,/normalize)


ampH=abs(Hafft)
oplot,f,ampH,color=134,thick=1.5
stop



freq=findgen(N)
p_ht=dz/freq

plot,p_ht,ampyfft,xrange=[0,2],color=2,background=-2
oplot,p_ht,amph,color=88
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


N=100
k=indgen(N)

y=fltarr(N)

H=0.54-0.46*cos(2*3.1416*k/N)

plot,H
stop
y=fft(H)

y[0]=0
ampyfft=abs(y)

s1=size(ampyfft)
plot,ampyfft,xrange=[0,50]
stop
end