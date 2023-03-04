Pro tst_wvlet
n = 1000 ; pick a nice number of points
info = WV_FN_MORLET( 6, 100, n, /SPATIAL, $
   WAVELET=wavelet)
plot, float(wavelet), THICK=2
oplot, imaginary(wavelet)
stop
info = WV_FN_MORLET( 6, 100, n, $
   FREQUENCY=frequency, WAVELET=wave_fourier)
plot, frequency, wave_fourier, $
   xrange=[-0.2,0.2], thick=2
   stop
   end
