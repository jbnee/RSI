
Pro contour_Map_test
ERASE,COLOR=-2
close,/all
device, decomposed=0

!p.multi=[0,1,2]
;!p.background=255
; loadct,39
plot,[0,10],[-1,1],COLOR = 2,background=-2
plot,[0,1],xrange=[0,20],yrange=[-2,2],/nodata,COLOR = 4
oplot,[0,20],[1.5,1.5],COLOR = 50

;
;-----------------------------
  ;start with a colour table, read in from an external file hues.dat
rgb = bytarr(3,256)
openr,2,'E:\RSI\hues.dat'
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
!P.COLOR=2 ;blue labe



  Longitude=fltarr(361)                                                                                 ;define length of longitude
  Latitude=fltarr(181)                                                                                  ;define length of latitude
  background=fltarr(361,181)                                                                            ;define size of a parameter eg.Geophysical height, "background"
  U=fltarr(361,181)                                                                                     ;define size of zonal component of wind
  V=fltarr(361,181)                                                                                     ;define size of meridional component of wind

  for i=0,361-1 do begin
  Longitude(i)=i*1.                                                                                       ;set longitude values
  endfor
  for i=0,181-1 do begin
  latitude(i)=i*1.-90                                                                                     ;set latitude values
  endfor


  for i=0,361-1 do begin
  for j=0,181-1 do begin
  background(i,j)=sin(i*1./360.)+cos(j*1./180.)                                                         ;set values
 ; if(j eq 60)then begin
  U(i,j)=i*5.
  V(i,j)=j^2
  ;endif
  endfor
  endfor
  stop

  U = RANDOMN(S, 361, 181)                                                                              ;set U values
  V = RANDOMN(S, 361, 181)                                                                              ;set V values


;;;:::****

;;;;::****

;;;;;;;;;;;;;;;;;;;test map;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


 MAP_SET, /MERCATOR,0, 0,/ISOTROPIC, /GRID, /CONTINENTS,TITLE = 'Simple Mercator'


stop

MAP_SET, /MERCATOR, 0, -75, 90, CENTRAL_AZIMUTH=90, $
   /ISOTROPIC, LIMIT= [32,-130, 70,-86, -5,-34, -58, -67], $
   /GRID, LATDEL=15, LONDEL=15, /CONTINENTS, $
   TITLE = 'Transverse Mercator'





stop;,33,ncolors=ncolors,bottom=bottom

MAP_SET, /SATELLITE, SAT_P=[1.0251, 55, 150], 41.5, -74., $
   /ISOTROPIC, /HORIZON, $
   LIMIT=[39, -74, 33, -80, 40, -77, 41,-74], $
   /CONTINENTS, TITLE='Satellite / Tilted Perspective'



;;;************** test map ************************************
;draw a map with a latitude range from -45 degree to 45 degree, a longitude range from -60 degree to 180 degree, with a center at (0 latitude, 60 longitude)
;the map is draw at the position "position=[0.05,0.55,0.9,0.9]" on the canvas
map_set,0,60,/mercator,/isotropic,/horizon,CHARSIZE=1.2,title='NCEP Geop.Height',/noborder,limit=[-45,-60,45,180],position=[0.05,0.55,0.9,0.9]
stop
;draw "background" on the map
contour,background,longitude,latitude,levels=c_levels,c_colors=c_colors,/fill,xstyle=4,ystyle=4,font=18,/overplot

;draw isopleth
contour,background,longitude,latitude,levels=c_levels,/overplot

;draw colorbar
;colorbar,position=[0.94,0.6,0.97,0.85],range=[a,b],/vertical,/right,format='(f3.1)',$
;DIVISIONS=ncolors,bottom=bottom,ncolors=ncolors,color=c_colors,CHARSIZE=0.8,font=18,MINOR=1,TICKNAMES=ticknames

loadct,0

;draw continents on the map
map_continents,color=255,thick=5

;add bounding box and labels for the map
map_grid,/box,label=1

;draw wind on the map
VELOVECT, U, V, longitude,latitude,LENGTH=2.,color=90,/overplot
stop


end
