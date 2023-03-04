pro FFT_2D_1

n = 500
x0 = FINDGEN(n)+100
x=x0
y=x0;100*cos(x0/200)+500
;y=10*sin(x0*!pi/4)*exp(-((x0-100.)/500.))
;x = 20*COS(x0*!PI/6)*EXP(-((x0 - n/2)/30.)^2/2)
 z=fltarr(n,n)
; Construct a two-dimensional image of the wave.
;z= sqrt(((sin(0.05*(x-200))/(.5*(x+200))))^2*((sin(0.08*(y-200))/(0.85*(y+200))))^2)
z=sin(0.05*(x-300))*sin(0.5*(y-200))
z =sqrt(REBIN(z, n, n))

; Add two different rotations to simulate a crystal structure.
;z = ROT(z, 10) + ROT(z, -45)
;WINDOW, XSIZE=500, YSIZE=500;540
LOADCT, 39
contour,z,x,y,nlevels=25,/fill
;TVSCL, z, 100, 100;270
stop
f = FFT(z)
logpower = ALOG10(ABS(f)^2)   ; log of Fourier power spectrum.
;TVSCL, logpower, 270, 270

; Compute the FFT only along the first dimension.
f1= FFT(z, DIMENSION=1)

;logpower = ALOG10(ABS(f1)^2)   ; log of Fourier power spectrum.
TVSCL, F1, 100, 100
stop
f2=fft(z, dimension=2)
;logpower=Alog10(abs(f2)^2)
TVSCL,f2,100,100
stop
end
