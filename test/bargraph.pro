

PRO BARGRAPH, minval

; Define variables.

;@plot01

; Define constants used in this procedure. Note that the number of
; colors used in the bar graph is defined by the number of colors
; available on your system.

del = 1./5.
ncol=!d.n_colors/5
colors = ncol*INDGEN(4)+ncol

; Loop for each score.

FOR iscore = 0, 3 DO BEGIN

    ; The y value of annotation. Vertical separation is 20 data units.

    yannot = minval + 20 *(iscore+1)

    ; Label for each bar.

    XYOUTS, 1984, yannot, names(iscore)

    ; Bar for annotation.

    BOX, 1984, yannot - 6, 1988, yannot - 2, colors(iscore)

    ; The x offset of vertical bar for each score.

    xoff = iscore * del - 2 * del

    ; Draw vertical box for each year's score.

    FOR iyr=0, N_ELEMENTS(year)-1 DO $
        BOX, year(iyr) + xoff, minval, year(iyr) + xoff + del, $
        allpts(iyr, iscore), colors(iscore)
    ENDFOR

END