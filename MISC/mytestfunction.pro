FUNCTION Titus,n,a

 Y=A[0]+A[1]*A[2]^n
 return,A


END

;FUNCTION testmyfunct, X, A

   ;bx = A[0]*EXP(A[1]*X)
   ;RETURN,[ [bx+A[2]+A[3]*SIN(X)], [EXP(A[1]*X)], [bx*X], $
     ; [1.0] ,[SIN(X)] ]
