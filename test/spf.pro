Pro SPF; calculate equatorial channel 5 (777.4nm) signal for recors 8,9,10,11
close,/all
n=0
m=0
a=fltarr(8,1100)
b=fltarr(3,180)
sum7774=0
line=''
;x1=''
openr,1,'d:\rsi\ISUAL\SPF200809D.txt'
while not eof(1) do begin
readf,1,line
readf,1,x1,x2,x3,x4,x5,x6,x7,x8
a(0,n)=x1   ; date
a(1,n)=x2   ;orbit
a(2,n)=x3   ;record
a(3,n)=x4   ;channel 1
a(4,n)=x5   ;channel 2
a(5,n)=x6   ;channel 3
a(6,n)=x7   ;channel 4
a(7,n)=x8   ;channel 5  ;7774
;a(8,n)=x9   ;channel 6
;print,n,x1,x2,x3,x4,x5,x6,x7,x8;
;stop
while (x7 GE 8) and (x7 LE 11) do begin
print,x2,x3,x7
b(0,m)=x2
b(1,m)=x3
b(2,m)=x7

sum7774=sum7774+x7
endwhile
n=n+1
m=m+1
endwhile
close,1
print,'number of size:',n
print, 'number of data: ',m
stop
;print,n,'end,b[n-1]= ',b[n-1]
;end
close,1
end
