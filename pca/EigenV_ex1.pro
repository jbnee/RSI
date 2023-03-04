pro EigenV_ex1
close,/all
SCO=fltarr(3,3)  ;data file
A=['X', 'Y','Z']
;openr,1,'f:\rsi\temp\EPAdata.txt'
  SCO=[[3,3,1],[1,0,-4],[1,-3,5]]

   m =3   ; number of variables
   n = 3   ; number of observations
   means = TOTAL(SCO, 2)/n
   A = SCO - REBIN(means, m, n)
   ;Compute derived variables based upon the principal components.

stop
   TRIRED,A,D,E

TRIQL,D,E,A
print,'eigenvalue'
print,D
PRINT,'eigenvectors'
print,A
stop
END