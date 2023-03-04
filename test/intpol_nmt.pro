Pro Intpol_NMT
close,/all
YY=fltarr(2,42)


X=fltarr(42)
V=fltarr(42)

openr,1,'d:\RSI\test\YY_200809_Ascend.txt'
readf,1,YY
X =YY[0,*]+180.   ; longitude
V = YY[1,*]





; Define X-values where interpolates are desired:
;U = [-2.50, -2.25, -1.85, -1.55, -1.20, -0.85, -0.50, -0.10, $
   ;0.30, 0.40, 0.75, 0.85, 1.05, 1.45, 1.85, 2.00, 2.25, 2.75 ]

; Interpolate:
U=findgen(360)
result = INTERPOL(V, X, U)

; Plot the function:
PLOT, X, V  ,psym=2
stop
; Plot the interpolated values:
OPLOT, U, result
stop
close,1
end