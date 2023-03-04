Pro Voltra
; solve eq. f(t)=Int(K9t,s)f(s)ds+g(t) with condition K(t,s)=0 if x>t
;t0 is the starting point of integration and n-1 is the number os steps of size h tobe taken
;g(k,t) is a user supplied external function that returns g_k(t)
;ak(k,l,t,s) is another use- supplied function that returns the (k,l) element of the matrix K(t,s)
;the solution is returned in f(1:m,1:n) with the corresponding abscissas in t(1:n)
;Integer k,j,k,l, indx(MMAX)
;real d, sum a(MMAX,MMAX), b(MMAX)
Read,"input m=  ,",m
t=fltarr(100)
gk=fltarr(m)
t(0)=0.
ak=intarr(m,m,m,M)
OPENR,1,'d:\rsi\data\gkts,txt'
readf,1,gk
   for k=0,m-1 do begin  ;1for
      f(k,0)=g(k,t(01))
   endfor
   for k=0,m-1 do begin   ;for 2
     sum=g(k,t(i))
     for L=0,m-1 do begin ;for 3
      sum=sum+0.5*h*ak(k,L,t(i),t(0))*f(L,0)
      for j=1 ,i-1 do begin   ;for 4
        sum=sum+h*ak(k,L,t(i),t(j))*f(L,j)
      endfor
      if (k eq 1) then begin  ;lefthand side goes in Matrix a
        a(k,L)=1
      endif else begin
       a(k,L)=0

      endelse
      a(k,L)=a(k,L)-0.5*h*ak(k,L,t(i),t(i))

 endfor
 b(k)=m
 endfor
 ;call ludcmp(a,m,MMAX,indx,d)   ;LA_LUDC solve linear eqs
 ;call lubksb(a,m,MMAX,indx,b)  ;LUSOL

 for k=1,m do begin
    f(k,i)=b(k)
 endfor


 end



end
