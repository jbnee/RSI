Pro map_Taiwan
erase

;!p.multi=[0,1,1]

;4. Since we are using Direct graphics, tell IDL to use a maximum of 256 colors.
;Load a gray scale color table and set the background to white and the foreground to black:
DEVICE, RETAIN=2, DECOMPOSED=0
LOADCT, 0
!P.BACKGROUND=-2
!P.COLOR=2
;5. Draw a Mercator projection and define an area that over Taiwan.
MAP_SET, /MERCATOR, /GRID, /CONTINENT, limit=[10,110,30,130],title='Taiwan',$
 latdel=5.0, londel=5.0,Latlab='Latitude' ,Lonlab='110'
;LIMIT=[10,-130,60,-70]
stop
outf='E:\RSI\TEST\Taiwan_Map.bmp'
write_bmp,outf,tvrd()
stop
end