Pro NewtonRalphson
;solve equations
err=0.0000001
h=0.0001

read,xo,promp='    xo='
f=(xo^3-5*xo-3)
print,xo,f
if (f gt err) then begin
df=((xo+h)^3-5*(xo+h)-3)-(xo^3-5*xo-3)
x=xo-((xo^3-5*xo-3)/df)
xo=x
print,x
ENDIF
stop
end