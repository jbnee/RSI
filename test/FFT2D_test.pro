
Pro FFT2D_test
; Create a cosine wave damped by an exponential.
erase
n = 256
x = FINDGEN(n)
y = COS(x*!PI/6.)*EXP(-((x - n/2)/30.)^2/2)

; Construct a two-dimensional image of the wave.
z = REBIN(y, n, n)
; Add two different rotations to simulate a crystal structure.
z = ROT(z, 10) + ROT(z, -45)
WINDOW, XSIZE=540, YSIZE=540
LOADCT, 39
TVSCL, z, 10, 270
stop
; Compute the two-dimensional FFT.
f = FFT(z)
logpower = ALOG10(ABS(f)^2)   ; log of Fourier power spectrum.
TVSCL, logpower, 270, 270
stop
; Compute the FFT only along the first dimension.
f = FFT(z, DIMENSION=1)
logpower = ALOG10(ABS(f)^2)   ; log of Fourier power spectrum.
TVSCL, logpower, 10, 10
stop
; Compute the FFT only along the second dimension.
f = FFT(z, DIMENSION=2)
logpower = ALOG10(ABS(f)^2)   ; log of Fourier power spectrum.
TVSCL, logpower, 270, 10

stop
end