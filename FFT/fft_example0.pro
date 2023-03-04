Pro FFT_example0
; Specify the time interval
;dt = 1./8000.;
; Create an array of time indices
;t = findgen(0:3:dt)
dt=1.0/16000.0;
N=(3./dt);
t=fltarr(N)
stop
N=fix(N)
for i=0,N-1 do begin
t[i]=1.0*i
;print,i,t[i]
;wait,0.5
endfor
stop
; Create a signal with two frequencies
freq1 = 2100
freq2 = 6400
x = cos(2*!pi*t * freq1)+ sin(2*!pi*t * freq2)
; Add some random noise
x += randomn(seed, t.length)
plot,t,x,color=2,background=-2
; Compute the power spectrum of the signal
f = FFT(x, dt, FREQ=freq, $
  /TUKEY, WIDTH=0.01, SIGNIFICANCE=signif)
; Plot the results
PLOT,freq/1000, f, /YLOG, XTITLE='Frequency (kHz)',color=2,background=-2
stop
;PLOT, freq/1000, signif, '2r', /OVERPLOT,color=2,background=-2
stop
end