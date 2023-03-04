pro Polar1
R = FINDGEN(100)
; Make a vector:
THETA = R/10;
Y1=1+(cos(theta)^2)
;stop
;y2=2*sin(theta/2)*Y1
Y2=Y1*exp(-2*(2*sin(theta/2))^2)
; Plot the data, suppressing the axes by setting their styles to 4:
PLOT, y1, THETA, SUBTITLE='Polar Plot', XSTY=4, YSTY=4, /POLAR
stop
oplot,y2,theta,/polar
;stop
AXIS, 0, 0, XAX=0
; Draw the x and y axes through (0, 0):
AXIS, 0, 0, YAX=0
stop
end