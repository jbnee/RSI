pro test_tiff
; Write the image data:
data = FIX(DIST(256))
rgbdata = LONARR(3,320,240)
WRITE_TIFF,'multi.tif',data,COMPRESSION=1,/SHORT
WRITE_TIFF,'multi.tif',rgbdata,/LONG,/APPEND
; Read the image data back
ok = QUERY_TIFF('multi.tif',s)
IF (ok) THEN BEGIN
   FOR i=0,s.NUM_IMAGES-1 DO BEGIN
      imp = QUERY_TIFF('multi.tif',t,IMAGE_INDEX=i)
      img = READ_TIFF('multi.tif',IMAGE_INDEX=i)
      HELP,t,/STRUCTURE
      HELP,img
   ENDFOR
ENDIF
end
