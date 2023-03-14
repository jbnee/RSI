Pro map_Taiwan
erase

!p.multi=[0,1,1]

;4. Since we are using Direct graphics, tell IDL to use a maximum of 256 colors.
;Load a gray scale color table and set the background to white and the foreground to black:
DEVICE, RETAIN=2, DECOMPOSED=0
LOADCT, 0
!P.BACKGROUND=255
!P.COLOR=0
;5. Draw a Mercator projection and define an area that encompasses the United
;States and Central America.
MAP_SET, /MERCATOR, /GRID, /CONTINENT, limit=[15,110,30,130];LIMIT=[10,-130,60,-70]
stop
end