Function NLEq1,x,y
;dy0 / dx = -0.5y0,        dy1 / dx = 4.0 - 0.3y1 - 0.1y0
;We can write a function DIFFERENTIAL to express these relationships in the IDL language:

;FUNCTION differential, X, Y
   ;RETURN, [-0.5 * Y[0], 4.0 - 0.3 * Y[1] - 0.1 * Y[0]]
;END

Return,[y[1],0.1*y[1]-y[0]^3+11.2*cos(x)]
end





