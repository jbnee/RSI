Pro map_Philippines
!p.multi=[0,1,1]
lats=[25.037,23,7,14.35]
 ;lats=[40.02,34.00,38.55,48.25,17.29]
; The values in LONS are negative because they represent degrees West of zero longitude.
lons=[121,3,120.17,120.58]
;lons=[-105.16,-119.40,-77.00,-114.21,-88.10]
;3. Create a five-element array of string values. Text strings can be enclosed in
;either single or double quotes.
;cities=['Boulder, CO','Santa Cruz, CA',$
;'Washington, DC','Whitefish, MT','Belize, Belize']

 ; cities=['Taipei','Kaohsiung','Manila']
;4. Since we are using Direct graphics, tell IDL to use a maximum of 256 colors.
;Load a gray scale color table and set the background to white and the foreground to black:
DEVICE, RETAIN=2, DECOMPOSED=0
LOADCT, 0
!P.BACKGROUND=255
!P.COLOR=0
;5. Draw a Mercator projection and define an area that encompasses the United
;States and Central America.
MAP_SET, /MERCATOR, /GRID, /CONTINENT, limit=[10,110,20,130];LIMIT=[10,-130,60,-70]
stop
end