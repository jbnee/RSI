Pro BAR_plot_example1
LOADCT, 15

;Make axes black:
!P.COLOR=0

;Create 5-column by 8-row array:
 array = INDGEN(5,8)

;Create a 2D array, equal in size to array, that has identical
;color index values across each row to ensure that the same item is
;represented by the same color in all bars:
colors = INTARR(5,8)
FOR I = 0, 7 DO colors[*,I]=(20*I)+20

;With arrays and colors defined, create stacked bars (note that
;the number of rows and columns is arbitrary):


;Scale range to accommodate the total bar lengths:
!Y.RANGE = [0, MAX(array)]
nrows = N_ELEMENTS(array[0,*])
base = INTARR(nrows)
FOR I = 0, nrows-1 DO BEGIN
   BAR_PLOT, array[*,I], COLORS=colors[*,I], BACKGROUND=-2, $
      BASELINES=base, BARWIDTH=0.75, BARSPACE=0.25, OVER=(I GT 0)
   base = array[*,I]
ENDFOR
stop
end