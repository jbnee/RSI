pro PCA_TEST
close,/all
SCO=fltarr(3,8)  ;data file
A=['a', 'b','c'];   ,' c','c']
;openr,1,'f:\rsi\temp\EPAdata.txt'
openr,1,'f:\RSI\temp\air.txt'
readf,1,SCO
   m =3   ; number of variables
   n = 8   ; number of observations
   means = TOTAL(SCO, 2)/n
   SCO = SCO - REBIN(means, m, n)
   x1=sco(0,*)
   x2=sco(1,*)
   x3=sco(2,*)
   plot,x1,x2,psym=4
   stop

   ;Compute derived variables based upon the principal components.
   result = PCOMP(SCO, COEFFICIENTS = coefficients, $
      EIGENVALUES=eigenvalues, VARIANCES=variances, /COVARIANCE)
   PRINT, 'Result: '
   PRINT, result;, FORMAT = '(2(F8.2))'
   PRINT
   Print,'eigenvalues'
   print,eigenvalues
   PRINT, 'Coefficients: '
   FOR mode=0,m-1 DO PRINT, $
      mode+1, coefficients[*,mode], $
      FORMAT='("Mode#",I1,3(F10.4))'
   eigenvectors = coefficients/REBIN(eigenvalues, m, m)
   PRINT

   PRINT, 'Eigenvectors: '
   FOR mode=0,m-1 DO PRINT, $
      mode+1, eigenvectors[*,mode],$
      FORMAT='("Mode#",I1,3(F10.4))'
   SCO_reconstruct = result ## eigenvectors
   PRINT
   PRINT, 'Reconstruction error: ', $
      TOTAL((SCO_reconstruct - SCO)^2)
   PRINT
   PRINT, 'Energy conservation: ', TOTAL(SCO^2), $
      TOTAL(eigenvalues)*(n-1)
   PRINT
   PRINT, '     Mode   Eigenvalue  PercentVariance'
   FOR mode=0,m-1 DO PRINT, $
      mode+1, eigenvalues[mode], variances[mode]*100
  stop
  s1=sco[*,0]  ; column vector
  x1=coefficients[*,0]
  x1=x1/norm(x1)
  a1=sqrt(total(x1^2,1))
  pc1=x1/a1 ;row vector
  xc1=pc1*transpose(sco[*,0])
  xc2=pc1*transpose(sco[*,1])
  xc3=pc1*transpose(sco[*,2])
  sc11=total(xc1,1)
  sc12=total(xc2,1)
  sc13=total(xc3,1)
  scx=[sc11,sc12,sc13];score 1


   s2=sco[*,1]
   x2=coefficients[*,1]
   x2=x2/norm(x2)
   a2=sqrt(total(x2^2,1))
   pc2=x2/a2
   yc1=pc2*transpose(sco[*,0])
   yc2=pc2*transpose(sco[*,1])
   yc3=pc2*transpose(sco[*,2])
   sc21=total(yc1,1)
   sc22=total(yc2,1)
   sc23=total(yc3,1)
   scy=[sc21,sc22,sc23];score 2

   plot,scx,scy,psym=2
stop
  close,1
END