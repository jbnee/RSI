pro hexalegendre
seed=4L
t= randomn(seed)*2; 0.383972
t2=t+!pi/6
if (t2 lt 1.) then begin
for i=0,20 do begin
y=legendre(t,i)
yy=legendre(t2,i)
dy=y-yy
if (abs(dy) lt 0.1) then print,i,y,yy,y-yy
endfor
endif
stop
end
