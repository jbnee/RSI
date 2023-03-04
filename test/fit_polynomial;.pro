PRO fit_polynomial; POLYNOMAIL_FIT
X = [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]
Y = [0.25, 0.16, 0.09, 0.04, 0.01, 0.00, 0.01, 0.04, 0.09,  0.16, 0.25]
PLOT,X,Y,color=2,background=-2

measure_errors = REPLICATE(0.01, 11)
ypoly=poly_fit(X,Y,2);, MEASURE_ERRORS=measure_errors,SIGMA=sigma)
yfit=poly(x,ypoly); generate curve of fitted data
oplot,x,yfit,color=99,psym=4
stop
end





