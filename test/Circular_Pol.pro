Pro Circular_Pol
w=100.
k=50.
t=20.
z=40.
;z=intarr(100)
;t=intarr(100)
x1=findgen(100)
y1=findgen(100)
plot,x1,y1,background=-2, color=-100
Ex=fltarr(100)
Ey=fltarr(100)
plots,50,50,color=3
plots,100,0,/continue

Read,z,prompt='z=?'
For i=0 ,49 do begin
;z=findgen(500)
;z=0
plots,50,50
t=i

Ex[i]=50*cos(k*z-w*t)
Ey[i]=50*sin(k*z-w*t)
plots,ex[i]+50,ey[i]+50,color=4 ,/continue
;print,ex[i],ey[i]
;plot,Ex,Ey
wait,0.1
endfor
;plots,ex,ey,
stop
end
