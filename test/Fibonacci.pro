pro Fibonacci
afib=fltarr(100)
afib1=fltarr(100)
afib2=fltarr(100)
fib0 = 1.
fib1 = 1. ;fib;
i=0
print, fib0, fib1;
while (fib1 lt 70000) do begin
fib = fib0 + fib1;
fib2=fib0+2*fib1
fib3=2*fib0+fib1

fib0 = fib1;
fib1 = fib;
AFIB(i)=fib
Afib2(i)=fib2
;Afib3(i)=fib3
print,i,fib,fib2,fib3,fib2/fib1,fib3/fib2
i=i+1
endwhile
;stop
x=findgen(i)
plot,x,afib/afib2,psym=2,yrange=[0.58,0.63]

end