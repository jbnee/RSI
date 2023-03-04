Pro Fit_JupiterMoon
;p=a+b*c^n, n is the integer 1,2,3,...
Y=[181.4,222,421.8,	671.1,1070.4,1882.7];,11480,22670]
X=findgen(6)
plot,x,y,psym=2
;stop
A = [1, 6, 4.0]  ;initial guess
Y2=A[0]+A[1]*A[2]^x
oplot,x,y2,psym=4
stop

fita = [1,5,12]

; Plot the initial data, with error bars:
;PLOTERR, X, Y, measure_errors
coefs = LMFIT(X,Y, A, MEASURE_ERRORS=measure_errors, /DOUBLE, $
    FITA=fita,FUNCTION_NAME = 'Titus')
yy=A[0]+A[1]*A[2]^x

stop
plot,x,y,psym=2

oplot,x,yy,psym=5
stop
end





