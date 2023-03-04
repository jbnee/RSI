Pro wvlttst
eta=fltarr(201)
t=0.1*findgen(101)
y=sin(2*!pi*t/5)+randomn(seed,101)
eta=findgen(201)/10-10
w0=6
wave=(!pi)^(-1/4)*exp(i*w0*eta)*exp(-eta^2/2)
plot,eta,wave,xtitle='position',ytitle='scale'
plot,t,y
scales=findgen(120)+1
Result = WV_CWT(y, 'Morlet', 120 )

stop
end
