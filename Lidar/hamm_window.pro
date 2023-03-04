pro Hamm_window
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