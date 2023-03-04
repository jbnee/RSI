Pro Raman
L0=532; 1064; 532; 266  ;355  ;laser wavelength in nm
E0=1E7/L0
EH2=4159;  H2;  2145. ; 1/cm
for i=0,5 do begin
E1=1.E7/(E0-Eh2*i)
E2=1.E7/(E0+EH2*i)
print,i,E1,E2
endfor
stop
end