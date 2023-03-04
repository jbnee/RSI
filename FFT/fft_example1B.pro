Pro FFT_example1B
;# Number of samplepoints
erase
np=3200;

;#;sample spacing
Fs=1000;  sample frequency
t=findgen(np)/Fs; period
 w=160.0;f=25.5
;y = 5.0 * sin(160.0 * 2.0*np.pi*x) + 10*np.sin(80.0 * 2.0*np.pi*x) #unit is V
y = 5.0 * sin(2*!pi*w*t) + 1.0*sin(2.*!pi*200.*t);#unit is V
plot,t,y
stop
YF = fft(y)
nf=n_elements(YF)
print,'nF: ',nf
Power=abs(YF[1:(nf/2-1)])^2;

plot,Power
stop
!p.multi=[0,1,2]
;plot.close()
Freq=0.5*findgen(nf/2)/(nf/2)
Freq=Freq(1:nf/2-1)
plot,freq, power,color=2,background=-2
T=1/freq
plot,T,power,color=2,background=-2,xrange=[0,500]
;plt.grid()
;plt.show()
stop
end
