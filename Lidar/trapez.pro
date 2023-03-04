Pro trapez
;;Integral=(f(x1)+2f(x2)+2f(x3)+...+2f(x N)+f(x N+1)*(B-A)/2N
;x=findgen(1001)

 N=999.   ;for 1000 grids

read,A,prompt='initial value A:'
read,B,prompt='final value B:'
h=(B-A)/N
sum=0


For I=1,N-1 do begin
x=A+h*I   ;x position
fx=(square1(x)+square1(x+h))*h/2
sum=sum+fx
endfor

result=sum
result1= QROMB('square1', A, B)
result2=QSIMP('square1',A,B)

print,'Trapez',result
print,"QROMB",result1
print,"QSIMP",result2
stop
end
;----------------------------
FUNCTION Square1, X
   RETURN, X^2
END


