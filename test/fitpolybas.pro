;DEFDBL "A-H,O-Z"   : DEFINT  I-N
PRO fITPOLY
;   General Weighted Linear Regression (Cd) @ J.F. Ogilvie 1990 1 1
;   Linear fit y=a+b*x ; or polynomial fit y=a+b*x+c*x^2+..
;   "input data is weighted, no weight type W(n)=1 for all n"
;   : PRINT   General Weighted Linear Regression    : PRINT
;   VARIABLE  TRANSFORMATION   * *   * *   *
;DEF    "FNX(X,K,I)=X" 'CDBL(I-1)  '    for    test   case
;DEF    "FNY(Y,I)=Y"   '1.#+1.D-0*CDBL(I-1)+1.D-0*CDBL(I-1)^2+1.D-0*CDBL(I-1)^3  +1.D-0*CDBL(I-1)^4+1.D-0*CDBL(I-1)^5 '   for   test  cases
;DEF    "FNW(X,Y,W)=1#/W^2"
;'  CONTROL  SECTION

X=fltarr(11,100)
Y=fltarr(100)
W=fltarr(100)
A=fltarr(11,11)
G=fltarr(11)
B=fltarr(11)
S=fltarr(11)
AA=fltarr(11,11)
IX=intarr(11)
AI=fltarr(11,11)
poly=''
lin=''
read, prompt=' For polynomial regression type :POLY' or for linear regression type LIN';AS
IF  AS=""POLY"""    THEN   130   ELSE  IF   "AS=""LIN"""  THEN 160 ELSE    ;PRINT  Error in input   : GOTO    110
Read, prompt=' Maximum degree of polynomial (<11) = ',K4
INPUT   Are results for lesser degrees wanted?  Type 'YES' or 'NO'.;B$
GOTO    180
read, prompt='   Number of independent variables (<11) =',K2
B$= NO
read, prompt='Is y-intercept to be zero?  Type YES or NO',Ds
;IF  "D$=""YES""" THEN    IY=0   ELSE  IY=1
'   DATA  INPUT    SECTION    *  *    *  *    *
read, prompt='   Number of data cases (<101) ',N
K5=1
IF  "A$=""POLY"""    THEN   K2=1
FOR I=K5    TO N
FOR K=1 TO  K2
PRINT   "  x(;K;"","";I;"")="";"  :    INPUT  ;    "X(K,I)"
"X(K,I)=FNX(X(K,I),K,I)"
NEXT    K
IF  "A$<>""POLY"""   THEN  310
FOR K=2 TO  K4   : "X(K,I)=X(1,I)^K"   : NEXT    K
PRINT   "    y(;I;"")="";"    :  INPUT    ;  Y(I)
"Y(I)=FNY(Y(I),I)"
PRINT   "   w(;I;"")="";" :   INPUT W(I)
IF  ABS(W(I))<.00000000000001#   THEN  W(I)=1#
"W(I)=FNW(X(1,I),Y(I),W(I))"
NEXT    I
read, prompt='   Are any data to be corrected before processing?  Type YES r 'NO'.;Ds
IF  "D$=""YES""" THEN    GOSUB  1290
'   COMPUTATION   OF    RESULTS--PREPARATION   OF    NORMAL EQUATIONS   * *   * *   *
IF  "A$<>""POLY"""   THEN  440
IF  "B$=""YES""" THEN    K7=1   ELSE  K7=K4
K6=K7
K2=K6
K1=K2+IY
FOR I=1 TO  K1
G(I)=0# :   S(I)=0#   : B(I)=0#
FOR J=1 TO  K1   : "A(I,J)=0#" :   NEXT  J
NEXT    I
SW=0#   : FOR I=1 TO  N    :  SW=SW+W(I)   : NEXT    I
IF  IY=0 THEN    G1=0#  ELSE "A(1,1)=SW"
Y5=0#
FOR K=1 TO  K1
FOR J=1 TO  K1
FOR I=1 TO  N
IF  K>1  THEN 630
IF  IY=1 THEN    IF J=1 THEN    600
"G(J)=G(J)+X(J-IY,I)*Y(I)*W(I)"
IF  IY=0 THEN    610    ELSE   "A(1,J)=A(1,J)+X(J-1,I)*W(I)"
GOTO    640
G(1)=G(1)+Y(I)*W(I)
IF  IY=1 THEN    Y5=Y5+Y(I)^2*W(I)  ELSE IF  J=1  THEN Y5=Y5+Y(I)^2*W(I)
IF  IY=1 THEN    640    ELSE   IF    J=1    THEN   G1=G1+Y(I)*W(I)
IF  J>=K THEN    "A(K,J)=A(K,J)+X(K-IY,I)*X(J-IY,I)*W(I)"
NEXT    I
"A(J,K)=A(K,J)"
NEXT    J
NEXT    K  :    IF IY=1    THEN   G1=G(1)
'   SOLUTION  OF   NORMAL    EQUATIONS  BY   THE   CROUT METHOD  *    *  *    *  *
FOR I=1 TO  K1   : FOR J=1 TO  K1   : "AA(I,J)=A(I,J)"    :  NEXT J
NEXT    I
FOR I=1 TO  K1   : R5=0#
FOR J=1 TO  K1   : IF  "ABS(AA(I,J))>R5"    THEN   "R5=ABS(AA(I,J))"
NEXT    J  :    IF ABS(R5)<1D-38   THEN  1680
S(I)=1#/R5  :    NEXT   I
FOR J=1 TO  K1   : IF  J=1  THEN 800
FOR I=1 TO  J-1  :    "SS=AA(I,J)"   : IF  I=1  THEN 790
FOR K=1 TO  I-1  :    "SS=SS-AA(I,K)*AA(K,J)"
NEXT    K  :    "AA(I,J)=SS"
NEXT    I
R5=0#   : FOR I=J TO  K1   : "SS=AA(I,J)"    :  IF   J=1   THEN  830
FOR K=1 TO  J-1  :    "SS=SS-AA(I,K)*AA(K,J)"    :  NEXT K
"AA(I,J)=SS"
R6=S(I)*ABS(SS)
IF  R6<R5    THEN   860
K3=I    :  R5=R6
NEXT    I  :    IF J=K3    THEN   900
FOR K=1 TO  K1   : "R6=AA(K3,K)"   : "AA(K3,K)=AA(J,K)"
"AA(J,K)=R6"    :  NEXT K
S(K3)=S(J)
IX(J)=K3    :  IF   J=K1  THEN 930
IF  "ABS(AA(J,J))<1D-38" THEN    "AA(J,J)=1D-32"
"R6=1#/AA(J,J)" :   FOR   I=J+1 TO  K1   : "AA(I,J)=AA(I,J)*R6"    :  NEXT I
NEXT    J  :    IF "ABS(AA(K1,K1))<1D-38"  THEN "AA(K1,K1)=1D-32"
FOR I=1 TO  K1   : FOR J=1 TO  K1   : "AI(I,J)=0#"    :  NEXT J
"AI(I,I)=1#"    :  NEXT I
FOR K=1 TO  K1   : FOR I=1 TO  K1   : "S(I)=AI(I,K)"  :    NEXT   I
GOSUB   1580  :    FOR    I=1    TO K1  :    "AI(I,K)=S(I)" :   NEXT  I    :  NEXT K
FOR I=1 TO  K1   : S(I)=G(I)   : NEXT    I  :    GOSUB  1580
FOR I=1 TO  K1   : B(I)=S(I)   : NEXT    I
FOR I=1 TO  K1   : S(I)=-G(I)
FOR J=1 TO  K1   : "S(I)=S(I)+A(I,J)*B(J)" :   NEXT  J
NEXT    I  :    GOSUB  1580
FOR I=1 TO  K1   : B(I)=B(I)-S(I)  :    NEXT   I
SS=0#   : FOR I=1 TO  N
IF  IY=0 THEN    YY=0#  ELSE YY=B(1)
FOR K=1 TO  K2   : "YY=YY+B(K+IY)*X(K,I)"  :    NEXT   K
SS=SS+W(I)*(YY-Y(I))^2
NEXT    I
FOR K=1 TO  K1   : "S(K)=SQR(AI(K,K)*SS/CDBL(N-K1))"   : NEXT    K
R5=SS/(Y5-G1^2/SW)
R6=1#-R5    :  F=CDBL(N-K1)*R6/(R5*CDBL(K2))    :  R6=SQR(R6)
'   OUTPUT    OF RESULTS *   * *   * *
LPRINT  :    IF "A$=""POLY"""   THEN  LPRINT   Degree of polynomial = ;K6    :  LPRINT
LPRINT  No.              Coefficient                 Standard Error
FOR K=1 TO  K1   : LPRINT  "K-IY,B(K),S(K)" :   NEXT  K
print,  ' F-value = ; :   print    USING  ##.####^^^^',F;
print        ' Standard deviation of fit = ;'
LPRINT  USING    ##.####^^^^;   SQR(SS*CDBL(N)/(CDBL(N-K1)*SW))
LPRINT  Absolute value of sample Correlation Coefficient = ; R6
read, prompt='   Is table of residuals wanted?  Type 'YES ' or 'NO'.;C$
IF  "C$=""YES""" THEN    GOSUB  1450
read, prompt='   Is table of correlation coefficients wanted?  Type 'YES' or 'NO'.;C$
IF  "C$=""YES""" THEN    GOSUB  1530
GOSUB   1290
IF  "A$<>""POLY"""   THEN  1700
K6=K6+1
IF  K6<=K4   THEN  430  ELSE 1700
'   DATA  CORRECTION   SECTION   * *   * *   *
PRINT   : INPUT   Number of data cases to be deleted = ;K7
IF  K7<1 THEN    1400   ELSE  IF   K7=1  THEN 1320
PRINT   Enter case numbers in descending order.
FOR J=1 TO  K7
N=N-1
read, prompt='   Case number to be deleted = ;K3
FOR I=K3    TO N
FOR K=1 TO  K2   : "X(K,I)=X(K,I+1)"   : NEXT    K
Y(I)=Y(I+1) :   W(I)=W(I+1)
NEXT    I
NEXT    J
read, prompt='   Number of data cases to be added = ;K3
K5=N+1  :    N=N+K3
IF  K7>0 OR  K3>0 THEN    230
RETURN
'   OUTPUT    OF TABLE   OF    RESIDUALS  *    *  *    *  *
LPRINT  :    LPRINT  Table of Residuals     :  LPRINT
LPRINT  Case No.   X            Y calc          Y obs         Ycalc-Yobs
FOR I=1 TO  N
IF  IY=0 THEN    YY=0#  ELSE YY=B(1)
FOR K=1 TO  K2   : "YY=YY+B(K+IY)*X(K,I)"  :    NEXT   K
LPRINT  "  ;I;"""    ";X(1,I);" ;YY;    ;Y(I); ;YY-Y(I)
NEXT    I
    RETURN
'   OUTPUT    OF COVARIANCE  (CORRELATION)    COEFFICIENTS   * *   * *   *
LPRINT     Parameter Correlation Matrix  :   LPRINT
FOR I=1 TO  K1   : FOR J=1 TO  I
LPRINT  USING    "###.####;AI(I,J)/SQR(AI(I,I)*AI(J,J));"
NEXT    J  :    LPRINT :   NEXT  I    :  RETURN
'   SUBSTITUTION  SUBROUTINE   * *   * *   *
K5=0    :  FOR  I=1  TO   K1    :  K3=IX(I) :   SS=S(K3)
S(K3)=S(I)  :    IF K5=0    THEN   1620
FOR J=K5    TO I-1 :   "SS=SS-AA(I,J)*S(J)"  :    NEXT   J :   GOTO  1630
IF  ABS(SS)>1D-36    THEN   K5=I
S(I)=SS :   NEXT  I
FOR I=K1    TO 1   STEP  -1   : SS=S(I)
IF  I=K1 THEN    1670
FOR J=I+1   TO    K1 :   "SS=SS-AA(I,J)*S(J)"  :    NEXT   J
"S(I)=SS/AA(I,I)"   : NEXT    I  :    RETURN
PRINT,   Singular matrix -- inversion aborted
'   TERMINATION   * *   * *   *
  PRINT ,  Analysis completed
D$=INKEY$   : IF  "D$="""""    THEN   1710
END
'   TERMINATION   * *   * *   *
  PRINT  :    PRINT  Analysis c
