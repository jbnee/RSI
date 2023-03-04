Pro Fred2
;n=intarr(100)
NMax=200
; Solves a linear Frehol eq. of the 2nd kind. On input , a and b are the limits of the integration and n is the number of points to use in the
;quadrature. G and AK are the user-supplied external functions
read, 'input:a,b,t,w: ',a,b,t,w
n=100
if (n LT NMax) then print,"input n<Nmax)
call Gauleg(a,b,t,w,n)
for i=1,n do begin
   for j=1,n do begin
  if (i eq j) then begin
   omk(i,j)=i

  endif, else begin
  omk(i,j)=0
  endelse
  omk(i,j)=omk(i,j)-ak(t(i),t(j))*w(j)

endfor
f(i)=g(t(i))
endfor
;call_function(ludcmp(omk,n,Nmax,indx,d)
;call lubksb(omk,n,NMax,indx,f)
end