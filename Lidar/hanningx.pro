pro HanningX
; Construct a time series with three sine waves.
n = 1024
dt = 0.02
w = 2*!DPI*dt*DINDGEN(n)
x = -0.3d + SIN(2.8d * w) + SIN(6.25d * w) + SIN(11.0d * w)
; Find the power spectrum with and without the Hanning filter.
han = HANNING(n, /DOUBLE)
powerHan = ABS(FFT(han*x))^2
powerUnfilt = ABS(FFT(x))^2
freq = FINDGEN(n)/(n*dt)
; Plot the results.
PLOT, freq, powerHan, /XLOG, /YLOG, $
    XRANGE=[1,1./(2*dt)], XSTYLE=1, $
    TITLE='Power spectrum with Hanning (solid) and without (dashed)'
OPLOT, freq, powerUnfilt, LINESTYLE=2
 stop
 end
