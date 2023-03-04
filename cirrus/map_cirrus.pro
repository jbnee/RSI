PRO Map_cirrus

device, decomposed=0
; to decide to display / print, color/no color
;set_plot,'X' ;for x windows
;-----------------------------
;start with a colour table, read in from an external file
rgb = bytarr(3,256)
openr,2,'f:\RSI\hues.dat'
readf,2,rgb
close,2
free_lun,2
r=bytarr(256)
g = r
b = r
r(0:255) = rgb(0,0:255)
g(0:255) = rgb(1,0:255)
b(0:255) = rgb(2,0:255)
tvlct,r,g,b
!P.BACKGROUND= 1 ; 0 = black, 1 = white
!P.COLOR=2 ;blue labels
;---------------------
MAP_SET, /ORTHO, 0, 80, 0, /ISOTROPIC, /CONTINENTS, /HORIZON

n =8

; Specify equally gridded latitudes:
;lat = replicate(180./(n-1),n) # findgen(n) - 90

 lat= replicate(180./n,n+2)#findgen(n)-90.;producing [7,6] array

; Specify equally gridded longitudes:
m=8
lon = findgen(m) # replicate(180./(m), m)

; Convert to Cartesian coordinates:
 x =sin(lat * !dtor) * sin(lat * !dtor)
 ;x=intarr(4,4)+4

;y = sin(lon * !dtor)*sin(lon*!dtor)
  y=intarr(8,8)*2 +cos(lat*!dtor)
  ;;z =cos(lat*!dtor)
Z=Intarr(4,4)*4

; Set interpolation function to scaled distance squared
; from (1,1,0):
;f = BYTSCL(x^2+y^2 +  z^2)
 ;f1=bytscl((x-1)^2+(y-1)^2+z^2)
 f=[[ 75, 75, 75, 75, 75, 75],$
   [80,80,80,80,80,80],$
 [123, 123, 123, 123, 123, 123],$
 [200, 200, 200, 200, 200, 200],$
  [123, 123, 123, 123, 123, 123],$
 [80,80,80,80,80,80],$
  [75, 75, 75, 75, 75, 75]]

TV, MAP_PATCH(f, XSTART=x0, YSTART=y0), x0, y0

MAP_GRID, LABEL=2, LATS=lats, LATNAMES=latnames, LATLAB=2, LONLAB=5, LONDEL=30, LONS=30, ORIENTATION=0

stop
end




