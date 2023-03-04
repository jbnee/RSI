Pro Rayleigh_TEMPERATURE_COMPARE
 ;COMPARE LIDAR AND RADIOSONDE
; In the first part we will read data and plot;
; In the second part, we will process signal according to Fernald
; Rayleigh lidar calcution
 ; read,bnum, prompt='Enter total number bins (eg.4096)  '
 loadct,5
 device,decomposed=0
!P.MULTI = [0,2,1]
   PL1 = [0.1,0.15,0.45,0.95];
   PL2 = [0.6,0.15,0.98,0.95];

f1='F:\RSI\lidar\Rayleigh_data\jy12_2009T.txt'
A0=read_ascii(F1)
A1=A0.(0)
help,A1
z1=A1[0,*]
T1=A1[1,*]
plot,T1-273,z1/1000,xrange=[-80,0],yrange=[10,30],color=2,background=-2,position=PL1
F2='F:\RSI\lidar\Rayleigh_data\CWB09071212T.txt'
B0=read_ascii(F2)
B1=B0.(0)
help,B1
z2=B1[0,*]
T2=B1[1,*]
plot,T2,Z2/1000,yrange=[10,30],color=2,background=-2,position=PL2

stop
end
