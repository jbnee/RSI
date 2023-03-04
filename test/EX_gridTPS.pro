pro EX_gridTPS
close,/all

;------------------
device, decomposed=0

;fileA = DIALOG_PICKFILE(/READ)
read,ndata,prompt='number of data: '
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;O2data=fltarr(3,8964); for B file
;O2data=fltarr(3,20930); for A file
Imgdata=fltarr(3,ndata);
 fileA='d:\RSI\data\GWLL007D.txt'
 openr,1,fileA
 readf,1,Imgdata


x = Imgdata[0,*]
y = Imgdata[1,*]

dataI2 =Imgdata[2,*]
z=smooth(dataI2,10)
z1 = GRID_TPS(x, y, z, NGRID=[20,20], START=[0,0], DELTA=[1,1])
help,z1
x1=rebin(x,20)
y1=rebin(y,20)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;start with a colour table, read in from an external file
rgb = bytarr(3,256)
openr,2,'d:\rsi\hues.dat'
readf,2,rgb
close,2
r=bytarr(256)
g = r
b = r
r(0:255) = rgb(0,0:255)
g(0:255) = rgb(1,0:255)
b(0:255) = rgb(2,0:255)
tvlct,r,g,b

!P.BACKGROUND= 1 ; 0 = black, 1 = white
!P.COLOR=2 ;blue labels
minx = min(x1)
maxx = max(x1)
miny = min(y1)
maxy = max(y1)

cmin = min(z1)
cmax = max(z1)
;print,'cmin,cmax ',cmin,cmax

nlevs_max = 50
cint = (cmax-cmin)/nlevs_max
CLEVS = CMIN + FINDGEN(NLEVS_MAX+1)*CINT
CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
clevs0 = clevs ; for plot the color bar

NLEVS = N_ELEMENTS(CLEVS)+1 ;actual number of countour levels
col = 240
C_INDEX=(FINDGEN(NLEVS)+1)*col/(NLEVS)
c_index(NLEVS-1) = 1 ; missing data = white
;print,'C_index ',c_index

;plot contour
plot_position1 = [0.4,0.6,0.8,0.95]
plot_position2 = [0.4,0.15,0.8,0.5]

CONTOUR,z1, X1,Y1, title='test1',$
XSTYLE =1, YSTYLE = 1, LEVELS = CLEVS, /FILL,$
C_COLORS = C_INDEX, color=2, C_CHARSIZE = 0.6,$
xticks=4,xtickname=[' ',' ',' ',' ',' ',' '],charsize=0.8, $
POSITION= PLOT_POSITION1,YTITLE = 'YTITLE'
plot_position = [0.2,0.6,0.8,0.9]
CONTOUR, z1, X1,Y1, title='test2',$
XSTYLE =1, YSTYLE = 1, LEVELS = CLEVS, /FILL,$
C_COLORS = C_INDEX, color=2, C_CHARSIZE = 0.6,$
; yticks=4,charsize=0.8, $
POSITION= PLOT_POSITION2,YTITLE = 'longitude', xtitle='Latitude',/noerase

; add labs
lab = 'the subtitle'
xyouts,minx,miny-40,lab,charsize=1.1,color=2,charthick=2
; add scale lines over contours, if int_skip not = 1 then then clevs will be changed
INT_SKIP = 2 ; where to drawlines
CLEVS =CMIN+FINDGEN(NLEVS_MAX/INT_SKIP)*(cint*int_skip)
CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
CLABS = STRARR(NLEVS_MAX/INT_SKIP)
FOR I = 0, NLEVS_MAX/INT_SKIP-1 do begin
  CLABS(i)=string(format='(i4)',CLEVS(i))
ENDFOR
CONTOUR, z1,X1,Y1,LEVELS = CLEVS,$
C_CHARSIZE = 0.6, C_ANNOTATION =CLABS,color=0,/overplot


;Show the result
;SHADE_SURF, z1, TITLE='TPS'
;CONTOUR, z1, X1,Y1, title='test'
;Grid using TRIGRID
;TRIANGULATE, x, y, tr, bounds

;z2 = TRIGRID(x, y, z, tr, [1,1], [0,0,19, 19], $
  ; EXTRAPOLATE=bounds)

;Show triangulated surface
;SHADE_SURF, z2, TITLE='TRIGRID - Quintic'
end