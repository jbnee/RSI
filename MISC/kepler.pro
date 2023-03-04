Pro kepler
r=[0.387,0.723,1.00,1.52,5.20,9.53,19.1,30.0,39.5]
T=[0.240,0.615, 1.00,1.88,11.8,29.4,83.7,164.,	248]
x=r^3/T^2
plot,x,psym=5
stop
n=findgen(10)
r2=(0.4+0.3*2^n)
Y=r2^3/x
plot,n,r2,psym=2
oplot,r,psym=5
stop
end
