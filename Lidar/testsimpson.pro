FUNCTION cubic, X
   RETURN,x^2+x^3-100
END
pro testsimpson
;w=3.0
a=0
b=1.0

result= QSIMP('cubic', a, b)
print,'Result=',result
stop
end



