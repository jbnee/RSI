PRO levs, MIN=min, MAX=max, STEP=step, EXACT=exact, $
          LOWER=lower, UPPER=upper, NDECS=ndecs, MANUAL=manual, V=v
;Procedure to generate levels for contour plots
;(C) NCAS 2008

COMPILE_OPT  DEFINT32 ;Use longword integers.

;Check !guide exists.
DEFSYSV, '!guide', exists=exists
IF (exists EQ 0) THEN BEGIN
 PSOPEN
 PSCLOSE, /NOVIEW
ENDIF

;Parameter check.
IF ((N_ELEMENTS(min) EQ 0) AND (N_ELEMENTS(max) EQ 0) AND (N_ELEMENTS(manual) EQ 0)) THEN BEGIN
 PRINT, ''
 PRINT, 'LEVS error - MIN, MAX and MANUAL all unset.'
 PRINT, ''
 STOP
ENDIF


IF (N_ELEMENTS(manual) GT 0) THEN BEGIN
  levs=manual
ENDIF

IF ((N_ELEMENTS(step) EQ 0) AND (N_ELEMENTS(manual) EQ 0)) THEN BEGIN
 levs=min+FINDGEN(20)*(max-min)/19
ENDIF

IF ((N_ELEMENTS(step) EQ 1) AND (N_ELEMENTS(min) EQ 1) AND (N_ELEMENTS(max) EQ 1)) THEN BEGIN
 levs=min+INDGEN((max-min)/step+1)*step
ENDIF

IF ((NOT KEYWORD_SET(UPPER)) AND (NOT KEYWORD_SET(LOWER)) AND (NOT KEYWORD_SET(EXACT))) THEN BEGIN
 UPPER=1
 LOWER=1
ENDIF

IF KEYWORD_SET(EXACT) THEN BEGIN
 UPPER=0
 LOWER=0
ENDIF


;Extend range if required
IF (KEYWORD_SET(lower) OR KEYWORD_SET(upper)) THEN BEGIN
 ctype=SIZE(levs(0), /TYPE)
 IF (ctype EQ 7) THEN BEGIN 
  ;Using strings.
  ext_range=(FLOAT(levs(N_ELEMENTS(levs)-1))-FLOAT(levs(0)))*10000
  IF KEYWORD_SET(LOWER) THEN levs=[STRING(levs(0)-ext_range), levs]
  IF KEYWORD_SET(UPPER) THEN levs=[levs, STRING(levs(N_ELEMENTS(levs)-1)+ext_range)]
 ENDIF ELSE BEGIN
  ;Using integers or floats.
  IF ((ctype EQ 2) OR (ctype EQ 3)) THEN ext_range=2147483648 ;INT or LONG.
  IF (ctype EQ 4) THEN ext_range=1E38       ;FLOAT 
  IF KEYWORD_SET(LOWER) THEN levs=[-ext_range, levs]
  IF KEYWORD_SET(UPPER) THEN levs=[levs, ext_range-1]
 ENDELSE
ENDIF


;Crop decimal places if required
IF (N_ELEMENTS(ndecs) NE 0) THEN BEGIN
 fmt='(f0.'+SCROP(ndecs)+')'
 levs=STRING(levs, FORMAT=fmt)
ENDIF


;Convert to strings before saving
levs=STRING(levs)

;Check there are less than 256 levels.
IF (N_ELEMENTS(levs) GT 256) THEN BEGIN
 PRINT, ''
 PRINT, 'LEVELS ERROR - Maximum number of levels is 256.'
 PRINT, 'Levels are: ', levs
 PRINT, ''
 STOP
ENDIF

;Print on command-line if requested.
IF KEYWORD_SET(V) THEN BEGIN
 PRINT, ''
 PRINT, 'Levels are: ',levs
 PRINT, ''
ENDIF


;Pass to the guide definitions.
guide_levels=STRARR(256)
guide_levels(0:N_ELEMENTS(levs)-1)=levs
guide_levels_text=''
!guide.levels=guide_levels
!guide.levels_npts=N_ELEMENTS(levs)
IF (NOT KEYWORD_SET(lower)) THEN lower=0
IF (NOT KEYWORD_SET(upper)) THEN upper=0
!guide.lower=lower
!guide.upper=upper

END
