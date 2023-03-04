pro circle1
;Handle TrueColor displays:
DEVICE, DECOMPOSED=0

;Load color table
TEK_COLOR

nr =5.0 ;  radii
nt = 100 ; number of Thetas

; Create a vector of radii:
r =nr

; Create a vector of Thetas:
theta =0.02*!PI * FINDGEN(nt)
x1=r*cos(theta)+15.0
y1=r*sin(theta)+5.0
plot,x1,y1, color=1, xrange=[0,20],yrange=[0,20]
x2=1.5*r*cos(theta)+15.0
y2=1.5*r*sin(theta)+5.0
oplot,x2,y2, color=5
PLOTS, [2,20], [15,12], color=7
PLOTS, [2,20], [15,11.5], color=7
PLOTS, [2,20], [15,8], color=2
PLOTS, [2,20], [15,9], color=2
;oPLOT, /POLAR, R, THETA;  /FILL, c_color=[2, 3, 4, 5]

; Create some data values to be contoured:
;z = COS(theta*3) # (r-0.5)^2

; Create the polar contour plot:
;POLAR_CONTOUR, z, theta, r, /FILL, c_color=[2, 3, 4, 5]
end