;pro 3Dplt
; Create some data to be plotted:
X = REPLICATE(5., 10.)
X1 = COS(FINDGEN(36)*10.*!DTOR)*2.+5.
X = [X, X1, X]
Y = FINDGEN(56)
Z = REPLICATE(5., 10)
Z1 = SIN(FINDGEN(36)*10.*!DTOR)*2.+5.
Z = [Z, Z1, Z]

; Create the box plot with data projected on all of the walls. The
; PSYM value of -4 plots the data as diamonds connected by lines:
PLOT_3DBOX, X, Y, Z, /XY_PLANE, /YZ_PLANE, /XZ_PLANE, $
   /SOLID_WALLS, GRIDSTYLE=1, XYSTYLE=3, XZSTYLE=4, $
   YZSTYLE=5, AZ=40, TITLE='Example Plot Box', $
   XTITLE='X Coordinate', YTITLE='Y Coodinate', $
   ZTITLE='Z Coordinate', SUBTITLE='Sub Title', $
   /YSTYLE, ZRANGE=[0,10], XRANGE=[0,10], $
   PSYM=-4, CHARSIZE=1.6

stop
end