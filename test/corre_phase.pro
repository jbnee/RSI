Pro corre_phase
phi=fltarr(200)
;x=fltarr(200)
x=findgen(200)
seed=1
For N=0,10,99 do begin
phi(N)=randomu(seed)
;for i=0,9 do begin
phi(N:N+9)=phi(N)
;x(i)=i+N
print,N,phi(N)
endfor
plot,x,phi
stop
end