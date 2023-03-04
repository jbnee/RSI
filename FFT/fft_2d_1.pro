pro FFT_2D_1
erase
n = 500
x0 = FINDGEN(n)+100
x=x0
;y=50*cos(x0/50);+500
y1=100*sin(x0*!pi/400)*exp(-((x0-50.)/50.))+7*sin(x0*!pi/20)
y2=0.2*sin(x0*!pi/40)*exp((x0-30)/100.)+5*sin(x0*!pi/500)
plot,y1
stop
oplot,y2
stop
plot,y1+y2
stop
;x = 20*COS(x0*!PI/6)*EXP(-((x0 - n/2)/30.)^2/2)
 z=fltarr(n,n)
; Construct a two-dimensional image of the wave.
;z= sqrt(((sin(0.05*(x-200))/(.5*(x+200))))^2*((sin(0.08*(y-200))/(0.85*(y+200))))^2)

;z=10*sin(x0*!pi/40)*exp(((x0-50)/150)))*y;sin(0.5*(y-200))
z =(REBIN(y1+y2, n, n))

; Add two different rotations to simulate a crystal structure.
;z = ROT(z, 10) + ROT(z, -45)
;WINDOW, XSIZE=500, YSIZE=500;540
LOADCT, 39
x=indgen(500)
y=indgen(500)
contour,z,x,y,nlevels=25,/fill
;TVSCL, z, 100, 100;270
stop
f = FFT(z)
powerZ =ABS(f)^2   ; log of Fourier power spectrum.
freq=findgen(500)
plot,freq, powerZ,xrange=[0,100]
stop

erase
; Compute the FFT only along the first dimension.
f11= FFT(z,1,dimension=1)
f12=FFT(z,1,dimension=2)

P11 = ABS(f11)^2
P12= ABS( f12)^2  ; log of Fourier power spectrum.
plot,freq, P11,xrange=[0,250]
stop
plot,freq,P12,xrange=[0,250]
stop
f21=fft(z,2,dimension=1)
P21=abs(f21)^2
plot,freq,P21

f22=fft(Z,2,dimension=2)
P22=abs(f22)^2
plot,freq,P22,xrange=[0,500]

stop
end
