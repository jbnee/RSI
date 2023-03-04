PRO example_oz
filename='f:\pca\EPA2.txt'
close,/all
;first part reading data

OPENR,1,filename
H=FLTARR(10,20) ;A big array to hold the data
A=FLTARR(10) ;A small array to read a line
sco=fltarr(9,12)

on_IOERROR,ers
line=''
readf,1,line
;readf,1,line
FOR n=0,20 DO BEGIN
READF,1,A ;Read a line of data
PRINT,A ;Print the line
H[*,n]=A ;Store it in H
ENDFOR
ers:CLOSE,1
stop
sH=size(H)
hy=sH(1)
SCX=H[1:hy-1,0:n-1]
sz=size(SCX);
m=hy-1
n=Sz[2]
sum=0
MSCX=fltarr(m)
STDV=fltarr(m)
stop
   means = TOTAL(SCX, 2)/n
   SCO = SCX - REBIN(means, m, n)
   For i=0,m-1 do begin
        STDV[i]=STDDEV(SCX[i,*])
    endfor
stop

VA=correlate(SCX) ;variance array
CVA=correlate(SCX,/covariance)  ;covariance
print,'covariance matrix CVA '
print,CVA
stop
VB=VA
;find eigenvalues of VA
 B = ELMHES(VA)
; Compute the eigenvalues:
EigB = HQR(B)
Print,'the eigenvalues: '
Elamda=abs(EigB)
PRINT, abs(Elamda)
PRINT,'Energy conservation'
print,total(Elamda)
print
PRINT, '     Mode   Eigenvalue  PercentVariance'
   FOR mode=0,m-1 DO PRINT, $
      mode+1, Elamda[mode], Elamda[mode]/total(Elamda)*100,'%'
print,'XV:'
XV=fltarr(m,m)
evec = EIGENVEC(VA, EigB, RESIDUAL = residual)
FOR i=0,m-1 DO evec[*,i] *= ABS(evec[0,i])/evec[0,i]

PRINT, 'Eigenvectors:'
PRINT, evec, FORMAT='(9("(",f8.5,",",f8.5,") "))'


For i=0,m-1 do XV[i,*]=real_part(evec[i,*])

PRINT, 'eigenvector COEFFICIENTS:'
 PRINT,XV ,FORMAT='(9(f8.5,", "))'

;PRINT, 'Residuals:'
;FOR i=0,2 DO print, A ## evec[*,i] - eval[i]*evec[*,i], $
    ;FORMAT ='(4("(",g9.2,",",g9.2,") "))'
stop
FOR mode=0,m-1 DO PRINT, $
      mode+1, XV[*,mode], $
      FORMAT='("Mode#",I1,9(F10.4))'
   eigenvectors = XV/REBIN(Elamda, m, m)
   PRINT
  stop
;;;;calculate scores for 15 students
sb=fltarr(n,m)  ;(15,5)
for k=0,m-1 do begin
for i=0,n-1 do begin
;sc[i,0]=p[0,0]*(A[0,i]-m[0])/sdv[0]+p[1,0]*(A[1,i]-m[1])/sdv[1]+p[2,0]*(A[2,i]-m[2])/sdv[2]+p[3,0]*(A[3,i]-m[3])/sdv[3]+p[4,0]*(A[4,i]-m[4])/sdv[4]
 sb[i,k]=XV[0,k]*(SCX[0,i]-means[0])/stdv[0]+XV[1,k]*(SCX[1,i]-means[1])/stdv[1]+XV[2,k]*(SCX[2,i]-means[2])/stdv[2]+XV[3,k]*(SCX[3,i]-means[3])/stdv[3]+XV[4,k]*(SCX[4,i]-means[4])/stdv[4]


endfor
endfor
print,'SB:  '
print,sb;
PLOT,SB[*,0],SB[*,1],PSYM=2,color=2,background=-2,title='scores of pc1,pc2(*),pc3(o)'
oplot,sb[*,0],sb[*,2],psym=4,color=2
print,line
print,SB[*,0],SB[*,1]
print,SB[*,2]
w=strarr(m)
w[0]='CH4'
w[1]='NMHC'
w[2]='THC'
w[3]='Ozone'
w[4]='NO2'
w[5]='O3_8'
w[6]='CO'
w[7]='SO2'
w[8]='PM10'

for L=0,m-1 do begin
px=w[L]
xyouts,SB[L,0],SB[L,2],px,color=2
endfor
stop
write_bmp,'f:\pca\PCA_oz2.bmp',tvrd()

  s1=VA[*,0]  ; column vector
  x1=XV[*,0]
  x1=x1/norm(x1)
  a1=sqrt(total(x1^2,1))
  pc1=x1/a1 ;row vector
  xc1=pc1*transpose(VA[*,0])
  xc2=pc1*transpose(VA[*,1])
  xc3=pc1*transpose(VA[*,2])
  sc11=total(xc1,1)
  sc12=total(xc2,1)
  sc13=total(xc3,1)
  scx=[sc11,sc12,sc13];score 1


   s2=VA[*,1]
   x2=XV[*,1]
   x2=x2/norm(x2)
   a2=sqrt(total(x2^2,1))
   pc2=x2/a2
   yc1=pc2*transpose(VA[*,0])
   yc2=pc2*transpose(VA[*,1])
   yc3=pc2*transpose(VA[*,2])
   sc21=total(yc1,1)
   sc22=total(yc2,1)
   sc23=total(yc3,1)
   scy=[sc21,sc22,sc23];score 2
   print,'eigenvectors: x1,x2 :',x1,x2
   print,'pc1,pc2:  ',pc1,pc2

   oplot,scx,scy,psym=5
stop
  close,1
END



