Pro PCA_2
close,/all
X=fltarr(2,8)
openr,1,'F:\RSI\TEMP\air.txt'
readf,1,X
close,1
x1=X[0,*]
x2=X[1,*]3.1416/
Var1=variance(x1)
Var2=variance(x2)
covar=correlate(x1,x2,/covariance)
print,Var1,var2,covar
stop
theta1=!pi/2+0.5*atan(2*covar/(abs(var1^2-var2^2)))
theta=theta1*180/3.14
print,theta

stop
end


