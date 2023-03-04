Pro GridTestA
close,/all
dataARR_A=fltarr(3,25)
openr,1,'d:\rsi\test\grid_testB.txt
readf,1,dataARR_A
close,1
print,'DATA: ', dataARR_A
x = dataARR_A[0,*]
y=dataARR_A[1,*]
z=dataARR_A[2,*]

; Scale the data to range from 1 to 253 so a color table can be
; applied. The values of 0, 254, and 255 are reserved as outliers.
scaled = BYTSCL(z, TOP = !D.TABLE_SIZE - 4) + 1B

; Load the color table.  If you are on a TrueColor, set the
; DECOMPOSED keyword to the DEVICE command before running a
; color table related routine.
DEVICE, DECOMPOSED = 0
LOADCT, 38

; Open a display window and plot the data points.
WINDOW, 0
PLOT, x, y, /XSTYLE, /YSTYLE, LINESTYLE = 1, $
   TITLE = 'Original Data, Scaled (1 to 253)', $
   XTITLE = 'x', YTITLE = 'y'

; Now display the data values with respect to the color table.
FOR i = 0L, (N_ELEMENTS(x) - 1) DO PLOTS, x[i], y[i], PSYM = -1,$
 SYMSIZE = 2., COLOR = scaled[i]

; Preprocess and sort the data. GRID_INPUT will
; remove any duplicate locations.
stop
GRID_INPUT, x, y, z, xSorted, ySorted, zSorted
 print,'Xsort=',xsorted
 print,'Ysort= ',ysorted
 print,'Zsort= ',zsorted
; Display the results from GRID_INPUT:

; Scale the resulting data.
scaled = BYTSCL(zSorted, TOP = !D.TABLE_SIZE - 4) + 1B

; Open a display window and plot the resulting data points.
WINDOW, 1
PLOT, xSorted, ySorted, /XSTYLE, /YSTYLE, LINESTYLE = 1, $
   TITLE = 'The Data Preprocessed and Sorted, Scaled (1 to 253)', $
   XTITLE = 'x', YTITLE = 'y'

; Now display the resulting data values with respect to the color
; table.
FOR i = 0L, (N_ELEMENTS(xSorted) - 1) DO PLOTS, $
   xSorted[i], ySorted[i], PSYM = 4, COLOR = scaled[i], $
   SYMSIZE = 3.

print,scaled

end