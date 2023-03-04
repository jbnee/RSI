pro Eigen_ex1
;find eigenvector of a given SQUARE array
close,/all
A=fltarr(4,4)  ;data file

A= [[58.3333,-16.6667, -58.3333, -25.0000],[-16.6667, 8.33333,41.6667,0],$
[-58.3333,41.6667, 233.333,-25.0000],[-25.0000,0.00,-25.0000,25.00]]

;openr,1,'f:\rsi\temp\EPAdata.txt'
; ;A=[[0.69,-1.31,0.39,0.09,1.29,0.49],[0.19,-0.81,-0.31,-0.71,0.49,-1.21],[0.99,0.29,1.09,0.79,-0.31,-0.81]];,-0.31,-1.01]]
;A= [[0.6166,0.6154],[0.6154,0.7166]]
s=size(A)

stop
B = ELMHES(A)
; Compute the eigenvalues:
EigB = HQR(B)
Print,' the eigenvalues:  '
PRINT, EigB
stop

  AV = EIGENVEC(A, EigB, RESIDUAL = residual)
  print,'AV unnorm eigenvector ',AV
; Compute the eigenvalues:
 AVX=AV
 FOR i=0,s(2)-1 DO AV[*,i] *= ABS(AV[0,i])/AV[0,i]

PRINT, 'Eigenvectors:'
PRINT, AV;FORMAT='(2("(",f8.5,",",f8.5,") "))'

;PRINT, 'Residuals:'
;FOR i=0,2 DO print, A ## evec[*,i] - eval[i]*evec[*,i], $
    ;FORMAT ='(4("(",g9.2,",",g9.2,") "))'
stop
END