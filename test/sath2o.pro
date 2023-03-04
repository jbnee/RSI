Pro satH2O
z=findgen(10)
E0=6.11
a=7.5
b=237.3
For i=0,10 do begin
T=300.-6*i
E=E0*10^(((a*T))/(b+T))
print,i,T, E
endfor
end

