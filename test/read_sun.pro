Pro read_sun
close,/all
n=0
X=fltarr(6)
a=fltarr(2,288)
;C:\RSI62\work 1
openr,1,'d:\rsi\test\sun_spot.txt'
while not eof(1) do begin
;n=n+1
readf,1,a
print,a
stop
;ht=a(0,*)
;NO=a(1,*)
;N2=a(2,*)
;O2=a(3,*)
;NO=a(4,*)
;I=k1*NO*O/(A2+k3A2*(0.8*N2+0.2*O2))
n=n+1
endwhile
close,1
print,'number of size:',n
b=fltarr(n+1)
t=a(0,*)
h=a(1,*)
print,n,'end,b[n-1]= ',b[n-1]
;end
close,1
stop
end