pro PCA_Ozone
close,/all
;EPA=fltarr(5,10)
dataE=fltarr(10,12)
EPA=fltarr(9,12)
A=strarr(5)
A=['yr','CH4', 'NMHC','THC','Ozone','NO2','O3_8','CO','SO2','PM10']
openr,1,'f:\rsi\temp\EPA2.txt'
head=''
readf,1,head
readf,1,dataE
EPA=dataE[1:9,*]

stop
m =9   ; number of variables
   n = 12   ; number of observations
   means = TOTAL(EPA, 2)/n
   EPA = EPA - REBIN(means, m, n)

   ;Compute derived variables based upon the principal components.
   result = PCOMP(EPA, COEFFICIENTS = coefficients, $
      EIGENVALUES=eigenvalues, VARIANCES=variances, /COVARIANCE)
   PRINT, 'Result: '
   PRINT, result, FORMAT = '(5(F8.2))'
   PRINT
   PRINT, 'Coefficients: '
   FOR mode=0,m-1 DO PRINT, $
      mode+1, coefficients[*,mode], $
      FORMAT='("Mode#",I1,9(F10.4))'
   eigenvectors = coefficients/REBIN(eigenvalues, m, m)
   PRINT
   PRINT, 'Eigenvectors: '
   FOR mode=0,m-1 DO PRINT, $
      mode+1, eigenvectors[*,mode],$
      FORMAT='("Mode#",I1,9(F10.4))'
   EPA_reconstruct = result ## eigenvectors
   PRINT
   PRINT, 'Reconstruction error: ', $
      TOTAL((EPA_reconstruct - EPA)^2)
   PRINT
   PRINT, 'Energy conservation: ', TOTAL(EPA^2), $
      TOTAL(eigenvalues)*(n-1)
   PRINT
   PRINT, '     Mode   Eigenvalue  PercentVariance'
   FOR mode=0,m-1 DO PRINT, $
      mode+1, eigenvalues[mode], variances[mode]*100
  stop
  ;xc=fltarr(5,10)
  sc1=fltarr(9)
  ;yc=fltarr(10)
  sc2=fltarr(9)
 ;pc1
  s1=EPA[*,0]  ; column vector
  x1=coefficients[*,0]
  a1=sqrt(total(x1^2,1))
  pc1=x1/a1 ;row vector
;
;score for the pc1
  for ix=0,8 do begin
   xc=pc1*transpose(EPA[*,ix])
   sc1[ix]=total(xc[ix],1)
  endfor
 ;pc2
   s2=EPA[*,1]
   x2=coefficients[*,1]
   a2=sqrt(total(x2^2,1))
   pc2=x2/a2
 ;score for the pc2
  for iy=01,8 do begin
   yc=pc2*transpose(EPA[*,iy])
   sc2[iy]=total(yc[iy],1)
  endfor

   ;yc1=pc2*transpose(EPA[*,0])
   ;yc2=pc2*transpose(EPA[*,1])
   ;yc3=pc2*transpose(EPA[*,2])
  ;yc4=pc2*transpose(EPA[*,3])
   ;yc5=pc2*transpose(EPA[*,4])
  ; sc21=total(yc1,1)
  ; sc22=total(yc2,1)
   ;sc23=total(yc3,1)
   ;sc24=total(yc4,1)
  ; sc25=total(yc5,1)
   ;scy=[sc21,sc22,sc23,sc24,sc25];


   plot,sc1,sc2,psym=2
stop
  close,1
END