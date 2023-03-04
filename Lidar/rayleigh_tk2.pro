pro Rayleigh_TK2
close,/all
g=9.8     ; gravity constant
R= 1.38E-23  ;8.314   ;J/Kmol
M=28.97*1.66E-27  ; kg

dz=24      ;height resolution 24 meter
Z=fltarr(1000)   ;height
Lisig=fltarr(2,1000)

T=fltarr(1000)        ; temperature
T[999]=250   ;k initial condition at 30 km
bk=12        ;bakcgorund caclulate from signal in 70-80 km in original data
openr,1,'d:\RSI\lidar\data\ja17_60km.txt'
;openr,1,'d:\RSI\lidar\data\Nov18_2000.txt'
line=''
readf,1,line
readf,1,Lisig
 z=Lisig[0,*]*1000   ;height in meters
 sz=lisig[1,*]    ;signal
 smz=smooth(sz,20)-bk  ;smooth signal for 20 point average
;stop

 Y1=fltarr(1000)   ;first term of the eq.
 Y2a=fltarr(1000)  ;second term prefactor
 Y2b=fltarr(1000)  ;secondterm : integration
 f=fltarr(1000)

For n=1,999 do begin

 i=999-n  ;i=998,997,996,,,,,3,2,1,0

 Y1[i]=(T[i+1]*(z[i+1]/z[i])^2*(smz[i+1]/smz[i]))
 Y2a[i]=(M*g/R)/(z[i]^2*Smz[i])
 f[i]=z[i]^2*smz[i]
 Y2b[i]= (dz/2)*(f[i]+f[i+1])
 T[i]=Y1[i]+Y2a[i]*Y2b[i]
 ;print,z[i]/1000,y1[i],y2a[i],y2b[i],T[i]
endfor
TC=T-273                     ;temperature in C
Tc[0]=Tc[1]
plot,TC,z/1000,xrange=[0,1000]
stop
end




