pro PCA_TEST2
close,/all
B=fltarr(4,4)  ;data file

openr,1,'f:\pca\ex0.txt'
readf,1,B

A=B[*,1:3]
  m =4   ; number of variables
 n = 3  ; number of observations
   means = TOTAL(A, 2)/n
   A = A - REBIN(means, m, n)
   x1=A(0,*)
   x2=A(1,*)

   plot,x1,x2,psym=4
   ;stop
 STDV=FLTARR(M)
   For i=0,m-1 do begin
        STDV[i]=STDDEV(A[i,*])
    endfor
    PRINT,'MEAN AND STD DEV'
    PRINT,means,stdv

stop
   ;Compute derived variables based upon the principal components.
   result = PCOMP(A, COEFFICIENTS = coefficients, $
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
   A_reconstruct = result ## eigenvectors
   PRINT
   PRINT, 'Reconstruction error: ', $
      TOTAL((A_reconstruct - A)^2)
   PRINT
   PRINT, 'Energy conservation: ', TOTAL(A^2), $
      TOTAL(eigenvalues)*(n-1)
   PRINT
   PRINT, '     Mode   Eigenvalue  PercentVariance'
   FOR mode=0,m-1 DO PRINT, $
      mode+1, eigenvalues[mode], variances[mode]*100
  stop

  x1=coefficients[*,0]  ;PCA1, coeff of the 1st eigenvector
  a1=sqrt(total(x1^2,1))
  pc1=x1/a1 ;normalized vector of PCA1 length=1
  xc=fltarr(m,n)
  sc1=fltarr(n)

  for ix=0,n-1 do begin
    xc[*,ix]=pc1*transpose(A[*,ix])
    sc1[ix]=total(xc[*,ix])
  endfor


   x2=coefficients[*,1]
   a2=sqrt(total(x2^2,1))
   pc2=x2/a2

    yc=fltarr(m,n)
   sc2=fltarr(n)

  for iy=0,n-1 do begin
    yc[*,iy]=pc2*transpose(A[*,iy])
    sc2[iy]=total(yc[*,iy])
  endfor


   plot,sc1,sc2,psym=2,background=-2,color=2,xtitle='sc1',ytitle='sc2',title='yearsly scores'
   w=strarr(N)


for L=0,N-1 do begin
px=strcompress(L)
xyouts,Sc1[L],Sc2[L],px,color=2
endfor
stop

 for L=0,n-1 do begin
    px=strcompress(L+1)
    xyouts,Sc1[L],Sc2[L],px,color=2
    endfor
 write_bmp,'f:\pca\PCA_test1.bmp',tvrd()
;scores for variables
  ;pc1:
  xd=fltarr(n,m)
  sc1=fltarr(m)

   for jx=0,m-1 do begin
     xd[jx,*]=pc1*transpose(A[jx,*])
     sc1[jx]=total(xc[*,jx])
  endfor
 ;pc2
  yd=fltarr(n,m)
  sc2=fltarr(m)
    for jy=0,m-1 do begin
      yd[jy,*]=pc1*transpose(A[jy,*])
      sc2[jy]=total(yd[*,jy])
    endfor

  oplot,sc1,sc2,psym=5,color=2;xtitle='sc1',ytitle='sc2',title='variable scores'

stop

    LD1=pc1*sqrt(eigenvalues[0])/STDV
    LD2=pc2*sqrt(eigenvalues[1])/STDV
    plot,LD1,LD2,psym=2,color=2,background=-2,title='loadings for pc1 & pc2

   for L=0,m-1 do begin
    px=strcompress(L+1)
    xyouts,LD1[L],LD2[L],px,color=2
    endfor
stop
 write_bmp,'f:\pca\PCA_test2_loading.bmp',tvrd()

END