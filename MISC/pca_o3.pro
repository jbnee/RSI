pro PCA_O3
close,/all
EPA=fltarr(5,10)
EPA2=fltarr(5,10)
A=strarr(5)
A=['CH4', 'NMHC','THC','O3','NO2']
openr,1,'f:\rsi\temp\EPAdata.txt'
readf,1,EPA
Pear=correlate(EPA,/covariance)
stop
m =5   ; number of variables
   n = 10   ; number of observations
   means = TOTAL(EPA, 2)/n
   EPA = EPA - REBIN(means, m, n)

   ;Compute derived variables based upon the principal components.
   result = PCOMP(EPA, COEFFICIENTS = coefficients, $
      EIGENVALUES=eigenvalues, VARIANCES=variances, /COVARIANCE)
   PRINT, 'Result: '
   PRINT, result, FORMAT = '(5(F8.2))'
   PRINT
   PRINT, 'Coefficients: '
   FOR mode=0,4 DO PRINT, $
      mode+1, coefficients[*,mode], $
      FORMAT='("Mode#",I1,5(F10.4))'
   eigenvectors = coefficients/REBIN(eigenvalues, m, m)
   PRINT
   PRINT, 'Eigenvectors: '
   FOR mode=0,4 DO PRINT, $
      mode+1, eigenvectors[*,mode],$
      FORMAT='("Mode#",I1,5(F10.4))'
   EPA_reconstruct = result ## eigenvectors
   PRINT
   PRINT, 'Reconstruction error: ', $
      TOTAL((EPA_reconstruct - EPA)^2)
   PRINT
   PRINT, 'Energy conservation: ', TOTAL(EPA^2), $
      TOTAL(eigenvalues)*(n-1)
   PRINT
   PRINT, '     Mode   Eigenvalue  PercentVariance'
   FOR mode=0,4 DO PRINT, $
      mode+1, eigenvalues[mode], variances[mode]*100
  stop

  s1=EPA[*,0]  ; column vector
  x1=coefficients[*,0]
  a1=sqrt(total(x1^2,1))
  pc1=x1/a1 ;row vector
  xc1=pc1*transpose(EPA[*,0])
  xc2=pc1*transpose(EPA[*,1])
  xc3=pc1*transpose(EPA[*,2])
  xc4=pc1*transpose(EPA[*,3])
  xc5=pc1*transpose(EPA[*,4])

  sc11=total(xc1,1)
  sc12=total(xc2,1)
  sc13=total(xc3,1)
  sc14=total(xc4,1)
  sc15=total(xc5,1)
  scx=[sc11,sc12,sc13,sc14,sc15];


   s2=EPA[*,1]
   x2=coefficients[*,1]
   a2=sqrt(total(x2^2,1))
   pc2=x2/a2
   yc1=pc2*transpose(EPA[*,0])
   yc2=pc2*transpose(EPA[*,1])
   yc3=pc2*transpose(EPA[*,2])
   yc4=pc2*transpose(EPA[*,3])
   yc5=pc2*transpose(EPA[*,4])
   sc21=total(yc1,1)
   sc22=total(yc2,1)
   sc23=total(yc3,1)
   sc24=total(yc4,1)
   sc25=total(yc5,1)
   scy=[sc21,sc22,sc23,sc24,sc25];


   plot,scx,scy,psym=2
stop
  close,1
END