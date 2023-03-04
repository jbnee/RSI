pro wind_field_picture

entry_device=!d.name

;define a canvas
page_width=8.26
page_height=11.8
xsize=8.
ysize=11.5
xoffset=(page_width-xsize)*1.
yoffset=(page_height-ysize)*1.
entry_device=!D.name
  set_plot,'ps'


  device,filename='D:\wind_field_picture.eps',/portrait                                                 ;picture name
  device,xsize=xsize,ysize=ysize,xoffset=xoffset,yoffset=yoffset,/inches,color=1,Bits_Per_Pixel=8
  
  
  
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
  
  U = RANDOMN(S, 361, 181)                                                                              ;set U values      
  V = RANDOMN(S, 361, 181)                                                                              ;set V values


nlevels=25
levels=fltarr(nlevels-1)

a=min(background)
b=max(background)

step=(b-a)/float(nlevels)
clevels=a+indgen(nlevels)*step
levels(0:nlevels-2)=clevels(1:nlevels-1)
nlevels=n_elements(levels)

ncolors=nlevels+1
bottom=1
print,ncolors+1,nlevels,levels
c_levels=[a,levels,b]
c_labels=[0,replicate(1,nlevels),0]
c_colors=indgen(ncolors)+bottom
loadct,33,ncolors=ncolors,bottom=bottom

;draw a map with a latitude range from -45 degree to 45 degree, a longitude range from -60 degree to 180 degree, with a center at (0 latitude, 60 longitude)
;the map is draw at the position "position=[0.05,0.55,0.9,0.9]" on the canvas 
map_set,0,60,/mercator,/isotropic,/horizon,CHARSIZE=1.2,title='NCEP Geop.Height',/noborder,limit=[-45,-60,45,180],position=[0.05,0.55,0.9,0.9]  

;draw "background" on the map 
contour,background,longitude,latitude,levels=c_levels,c_colors=c_colors,/fill,xstyle=4,ystyle=4,font=18,/overplot

;draw isopleth
contour,background,longitude,latitude,levels=c_levels,/overplot

;draw colorbar
colorbar,position=[0.94,0.6,0.97,0.85],range=[a,b],/vertical,/right,format='(f3.1)',$
DIVISIONS=ncolors,bottom=bottom,ncolors=ncolors,color=c_colors,CHARSIZE=0.8,font=18,MINOR=1,TICKNAMES=ticknames

loadct,0

;draw continents on the map
map_continents,color=255,thick=5

;add bounding box and labels for the map
map_grid,/box,label=1

;draw wind on the map
VELOVECT, U, V, longitude,latitude,LENGTH=2.,color=0,/overplot



end










PRO COLORBAR, BOTTOM=bottom, CHARSIZE=charsize, COLOR=c_colors, DIVISIONS=divisions, $
   FORMAT=format, POSITION=position, MAXRANGE=maxrange, MINRANGE=minrange, NCOLORS=ncolors, $
   TITLE=title, VERTICAL=vertical, TOP=top, RIGHT=right, MINOR=minor, $
   RANGE=range, FONT=font, TICKLEN=ticklen, _EXTRA=extra, INVERTCOLORS=invertcolors, $
   TICKNAMES=ticknames, REVERSE=reverse, ANNOTATECOLOR=annotatecolor, XLOG=xlog, YLOG=ylog

    compile_opt idl2

    ; Return to caller on error.
    On_Error, 2

    ; Save the current plot state.
    bang_p = !P
    bang_x = !X
    bang_Y = !Y
    bang_Z = !Z
    bang_Map = !Map

    ; Are scalable pixels available on the device?
    IF (!D.Flags AND 1) NE 0 THEN scalablePixels = 1 ELSE scalablePixels = 0

    ; Which release of IDL is this?
    thisRelease = Float(!Version.Release)

    ; Check and define keywords.
    IF N_ELEMENTS(ncolors) EQ 0 THEN BEGIN

       ; Most display devices to not use the 256 colors available to
       ; the PostScript device. This presents a problem when writing
       ; general-purpose programs that can be output to the display or
       ; to the PostScript device. This problem is especially bothersome
       ; if you don't specify the number of colors you are using in the
       ; program. One way to work around this problem is to make the
       ; default number of colors the same for the display device and for
       ; the PostScript device. Then, the colors you see in PostScript are
       ; identical to the colors you see on your display. Here is one way to
       ; do it.

       IF scalablePixels THEN BEGIN
          oldDevice = !D.NAME

             ; What kind of computer are we using? SET_PLOT to appropriate
             ; display device.

          thisOS = !VERSION.OS_FAMILY
          thisOS = STRMID(thisOS, 0, 3)
          thisOS = STRUPCASE(thisOS)
          CASE thisOS of
             'MAC': SET_PLOT, thisOS
             'WIN': SET_PLOT, thisOS
             ELSE: SET_PLOT, 'X'
          ENDCASE

          ; Here is how many colors we should use.
          ncolors = !D.TABLE_SIZE
          SET_PLOT, oldDevice
        ENDIF ELSE ncolors = !D.TABLE_SIZE
    ENDIF
    IF N_ELEMENTS(bottom) EQ 0 THEN bottom = 0B
    IF N_ELEMENTS(charsize) EQ 0 THEN charsize = 1.0
    IF N_ELEMENTS(format) EQ 0 THEN format = '(I0)'
    IF N_ELEMENTS(color) EQ 0 THEN color = !P.Color
    IF N_ELEMENTS(minrange) EQ 0 THEN minrange = 0
    IF N_ELEMENTS(maxrange) EQ 0 THEN maxrange = ncolors
    IF N_ELEMENTS(ticklen) EQ 0 THEN ticklen = 0.2
    IF N_ELEMENTS(minor) EQ 0 THEN minor = 2
    IF N_ELEMENTS(range) NE 0 THEN BEGIN
       minrange = range[0]
       maxrange = range[1]
    ENDIF
    IF N_ELEMENTS(divisions) EQ 0 THEN divisions = 6
    IF N_ELEMENTS(font) EQ 0 THEN font = !P.Font
    IF N_ELEMENTS(title) EQ 0 THEN title = ''
    xlog = Keyword_Set(xlog)
    ylog = Keyword_Set(ylog)

    ; You can't have a format set *and* use ticknames.
    IF N_ELEMENTS(ticknames) NE 0 THEN format = ""

    ; If the format is NOT null, then format the ticknames yourself.
    IF (xlog XOR ylog) EQ 0 THEN BEGIN
        IF format NE "" THEN BEGIN
           step = (maxrange - minrange) / divisions
           levels = minrange > (Indgen(divisions+1) * step + minrange) < maxrange
           IF StrPos(StrLowCase(format), 'i') NE -1 THEN levels = Round(levels)
           ticknames = String(levels, Format=format)
           format = "" ; No formats allowed in PLOT call now that we have ticknames.
        ENDIF
    ENDIF

    IF KEYWORD_SET(vertical) THEN BEGIN
       bar = REPLICATE(1B,20) # BINDGEN(ncolors)
       IF Keyword_Set(invertcolors) THEN bar = Reverse(bar, 2)
       IF N_ELEMENTS(position) EQ 0 THEN BEGIN
          position = [0.88, 0.1, 0.95, 0.9]
       ENDIF ELSE BEGIN
          IF position[2]-position[0] GT position[3]-position[1] THEN BEGIN
             position = [position[1], position[0], position[3], position[2]]
          ENDIF
          IF position[0] GE position[2] THEN Message, "Position coordinates can't be reconciled."
          IF position[1] GE position[3] THEN Message, "Position coordinates can't be reconciled."
       ENDELSE
    ENDIF ELSE BEGIN
       bar = BINDGEN(ncolors) # REPLICATE(1B, 20)
       IF Keyword_Set(invertcolors) THEN bar = Reverse(bar, 1)
       IF N_ELEMENTS(position) EQ 0 THEN BEGIN
          position = [0.1, 0.88, 0.9, 0.95]
       ENDIF ELSE BEGIN
          IF position[3]-position[1] GT position[2]-position[0] THEN BEGIN
             position = [position[1], position[0], position[3], position[2]]
          ENDIF
          IF position[0] GE position[2] THEN Message, "Position coordinates can't be reconciled."
          IF position[1] GE position[3] THEN Message, "Position coordinates can't be reconciled."
       ENDELSE
    ENDELSE

    ; Scale the color bar.
     bar = BYTSCL(bar, TOP=(ncolors-1) < (255-bottom)) + bottom
     IF Keyword_Set(reverse) THEN BEGIN
       IF Keyword_Set(vertical) THEN bar = Reverse(bar,2) ELSE bar = Reverse(bar,1)
     ENDIF

    ; Get starting locations in NORMAL coordinates.
    xstart = position[0]
    ystart = position[1]

    ; Get the size of the bar in NORMAL coordinates.
    xsize = (position[2] - position[0])
    ysize = (position[3] - position[1])

    ; Display the color bar in the window. Sizing is
    ; different for PostScript and regular display.
    IF scalablePixels THEN BEGIN

       TV, bar, xstart, ystart, XSIZE=xsize, YSIZE=ysize, /Normal

    ENDIF ELSE BEGIN

       bar = CONGRID(bar, CEIL(xsize*!D.X_VSize), CEIL(ysize*!D.Y_VSize), /INTERP)

       ; Decomposed color off if device supports it.
       CASE  StrUpCase(!D.NAME) OF
            'X': BEGIN
                IF thisRelease GE 5.2 THEN Device, Get_Decomposed=thisDecomposed
                Device, Decomposed=0
                ENDCASE
            'WIN': BEGIN
                IF thisRelease GE 5.2 THEN Device, Get_Decomposed=thisDecomposed
                Device, Decomposed=0
                ENDCASE
            'MAC': BEGIN
                IF thisRelease GE 5.2 THEN Device, Get_Decomposed=thisDecomposed
                Device, Decomposed=0
                ENDCASE
            ELSE:
       ENDCASE

       TV, bar, xstart, ystart, /Normal

       ; Restore Decomposed state if necessary.
       CASE StrUpCase(!D.NAME) OF
          'X': BEGIN
             IF thisRelease GE 5.2 THEN Device, Decomposed=thisDecomposed
             ENDCASE
          'WIN': BEGIN
             IF thisRelease GE 5.2 THEN Device, Decomposed=thisDecomposed
             ENDCASE
          'MAC': BEGIN
             IF thisRelease GE 5.2 THEN Device, Decomposed=thisDecomposed
             ENDCASE
          ELSE:
       ENDCASE

    ENDELSE

    ; Annotate the color bar.
    IF N_Elements(annotateColor) NE 0 THEN color = FSC_Color(annotateColor, color)

    IF KEYWORD_SET(vertical) THEN BEGIN

       IF KEYWORD_SET(right) THEN BEGIN

          PLOT, [minrange,maxrange], [minrange,maxrange], /NODATA, XTICKS=1, $
             YTICKS=divisions, XSTYLE=1, YSTYLE=9, $
             POSITION=position, COLOR=color, CHARSIZE=charsize, /NOERASE, $
             YTICKFORMAT='(A1)', XTICKFORMAT='(A1)', YTICKLEN=ticklen , $
             YRANGE=[minrange, maxrange], FONT=font, _EXTRA=extra, YMINOR=minor, YLOG=ylog

          AXIS, YAXIS=1, YRANGE=[minrange, maxrange], YTICKFORMAT=format, YTICKS=divisions, $
             YTICKLEN=ticklen, YSTYLE=1, COLOR=color, CHARSIZE=charsize, $
             FONT=font, YTITLE=title, _EXTRA=extra, YMINOR=minor, YTICKNAME=ticknames, YLOG=ylog

       ENDIF ELSE BEGIN

          PLOT, [minrange,maxrange], [minrange,maxrange], /NODATA, XTICKS=1, $
             YTICKS=divisions, XSTYLE=1, YSTYLE=9, YMINOR=minor, $
             POSITION=position, COLOR=color, CHARSIZE=charsize, /NOERASE, $
             YTICKFORMAT=format, XTICKFORMAT='(A1)', YTICKLEN=ticklen , $
             YRANGE=[minrange, maxrange], FONT=font, YTITLE=title, _EXTRA=extra, $
             YTICKNAME=ticknames, YLOG=ylog

          AXIS, YAXIS=1, YRANGE=[minrange, maxrange], YTICKFORMAT='(A1)', YTICKS=divisions, $
             YTICKLEN=ticklen, YSTYLE=1, COLOR=color, CHARSIZE=charsize, $
             FONT=font, _EXTRA=extra, YMINOR=minor, YLOG=ylog

       ENDELSE

    ENDIF ELSE BEGIN

       IF KEYWORD_SET(top) THEN BEGIN

          PLOT, [minrange,maxrange], [minrange,maxrange], /NODATA, XTICKS=divisions, $
             YTICKS=1, XSTYLE=9, YSTYLE=1, $
             POSITION=position, COLOR=color, CHARSIZE=charsize, /NOERASE, $
             YTICKFORMAT='(A1)', XTICKFORMAT='(A1)', XTICKLEN=ticklen, $
             XRANGE=[minrange, maxrange], FONT=font, _EXTRA=extra, XMINOR=minor, XLOG=xlog

          AXIS, XTICKS=divisions, XSTYLE=1, COLOR=color, CHARSIZE=charsize, $
             XTICKFORMAT=format, XTICKLEN=ticklen, XRANGE=[minrange, maxrange], XAXIS=1, $
             FONT=font, XTITLE=title, _EXTRA=extra, XCHARSIZE=charsize, XMINOR=minor, $
             XTICKNAME=ticknames, XLOG=xlog

       ENDIF ELSE BEGIN

          PLOT, [minrange,maxrange], [minrange,maxrange], /NODATA, XTICKS=divisions, $
             YTICKS=1, XSTYLE=1, YSTYLE=1, TITLE=title, $
             POSITION=position, COLOR=color, CHARSIZE=charsize, /NOERASE, $
             YTICKFORMAT='(A1)', XTICKFORMAT=format, XTICKLEN=ticklen, $
             XRANGE=[minrange, maxrange], FONT=font, XMinor=minor, _EXTRA=extra, $
             XTICKNAME=ticknames, XLOG=xlog

        ENDELSE

    ENDELSE

    ; Restore the previous plot and map system variables.
    !P = bang_p
    !X = bang_x
    !Y = bang_y
    !Z = bang_z
    !Map = bang_map

end
