Pro fft_test
Fs=500.0;sampling freq
T=1/Fs;sampling time

n = 500. ;length of vector
x = FINDGEN(n)/n;1000.

y =5* cos(x*2*!pi*40.)+ 3*cos(x*2*!pi*135); *EXP(-((x - n/2)/50)^2/2)

plot,x,y,xrange=[0,1]
stop
yfft=fft(y,-1);,/OVERWRITE)
yfft[0]=0;   cut the 0th element
ayfft=abs(yfft)^2
ny=n_elements(yfft)
power=ayfft[1:ny/2-1]
f=findgen(250)
plot,f,ayfft(0:250),xtitle='frequency'


stop
end