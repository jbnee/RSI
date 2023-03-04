;Pro read_arr
close,/all
n=0
a=fltarr(1000)
openr,1,'d:\rsi\test\x007.txt'
while not eof(1) do begin
;n=n+1
readf,1,x
a(n)=x
n=n+1
endwhile
close,1
print,'number of size:',n
b=fltarr(n+1)
b=a(0:n)
print,n,'end,b[n-1]= ',b[n-1]
;end
close,1
;end
