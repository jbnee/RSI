function fft_Func,x,y
;carried out fft for y of variable x
Nx=n_elements(x)
sfft=fft(y)
;lomb_Sg= LNP_TEST(x, y, WK1 = freq, WK2 = amp, JMAX = jmax)
N0=n_elements(sfft)/2

Nf=indgen(N0)
power=abs(sfft(0:N0))^2;
nyquist=1./2;
freq=nyquist*Nf/N0
ffty=fltarr(2,n0)
ffty[0,*]=freq
ffty[1,*]=power[0:N0-1]
return,ffty
end


;stop

