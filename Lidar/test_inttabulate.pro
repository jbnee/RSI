Pro TEST_IntTabulate
 X = [0.0, .12, .22, .32, .36, .40, .44, .54, .64, .70, .80]
 ;Define 11 f-values corresponding to xi:

F = [0.200000, 1.30973, 1.30524, 1.74339, 2.07490, 2.45600, $
     2.84299, 3.50730, 3.18194, 2.36302, 0.231964]
plot,X,F
result = INT_TABULATED(X, F)
;In this example, the f-values are generated from a known function
;f = 0.2 + 25x- 200x2 + 675x3 - 900x4 + 400x5
;which allows the determination of an exact solution. A comparison of methods yields the following results:
;The Multiple Application Trapezoid Method yields: 1.5648


 ;if fit with function f_test and integrate from 0 to 0.8
 z=findgen(101)*0.008
  Y=f_test(z)
  oplot,z,y,psym=2

;integral of this polynomil
 R=qsimp('f_test',0,0.8)
 print,result,R
 stop
 end
