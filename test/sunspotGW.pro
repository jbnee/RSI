Pro sunspotGW
close,/all
n=0
av=fltarr(1000)
x=fltarr(4,1000)
A=fltarr(2,1000)
;line=''
openr,1,'d:\rsi\test\sunspot_Greenwich.txt'
while not eof(1) do begin
n=0
n0=1749
readf,1,x
;readf,1,y1,y2,y3,y4
A[0,*]=x[0,*,*,*]
AV=0
yr=1748/12
For m=0,yr-1
For I=0,11 do begin
  Av=x(2,i)+AV
  endfor
A(1,m)=AV
endfor  ;
 ;a(0,n)=x(0,*)
 ;a(1,n)=x(1,*)
 ;a(2,n)=x(2,*)

n=n+1
endwhile
close,1
print,'number of size:',n
stop
b=fltarr(3,n+1)
;b1=a(0,0:n)
;b2=a(1,0:n)
;b3=a(2,0:n)
;print,n,'end,b[n-1]= ',b[n-1]
;end
close,1
end
