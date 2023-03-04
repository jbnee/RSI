Pro TestIMG; Create a simple image to be warped:
image = BYTSCL(SIN(DIST(400)/10))

; Display the image so we can see what it looks like before
; warping:
TV, image
latmin = -90 ; 65
latmax = 90   ;-65

; Left edge is 160 East:
lonmin = 160

; Right edge is 70 West = +360:
lonmax = -70 + 360
MAP_SET, 0, -140, /ORTHOGRAPHIC, /ISOTROPIC, $
   LIMIT=[latmin, lonmin, latmax, lonmax]
result = MAP_IMAGE(image,Startx,Starty, COMPRESS=1, $
   LATMIN=latmin, LONMIN=lonmin, $
   LATMAX=latmax, LONMAX=lonmax)

; Display the warped image on the map at the proper position:
TV, result, Startx, Starty

; Draw gridlines over the map and image:
MAP_GRID, latdel=10, londel=10, /LABEL, /HORIZON

; Draw continent outlines:
MAP_CONTINENTS, /coasts
stop
end