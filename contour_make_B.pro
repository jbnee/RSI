pro contour_make_B,z,x,y
;-----------------
;test_data:
; openr,1,'E:\RSI\test\data_plot.txt'
;  z=fltarr(200,100)
;  readf,1,Z
; x = findgen(200)*!pi/180.0 ; as angles
;  y=findgen(100)


;;At NCU
;------------------
device, decomposed=0
; to decide to display / print, color/no color
;set_plot,'X' ;for x windows
;-----------------------
erase
;start with a colour table, read in from an external file
rgb = bytarr(3,256)
openr,2,'E:\rsi\hues.dat'
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
;------------------------------------------
; size of dots to plot
rp = 0.8
a = findgen(16)*(!pi*2/16.0)
usersym,cos(a)*rp,sin(a)*rp,/fill

; TEST:make a data set
;ix = 200
;x = findgen(ix)*!pi/180.0 ; as angles
;iy = 100
;y = findgen(iy)
;data_plot = fltarr(ix,iy)
;for i = 0, iy-1 do data_plot(*,i) = -15.0*cos(y(i)*!pi/180.0)+20.0*sin(x(*))
data_plot=z
minx = min(x)
maxx = max(x)
miny = min(y)
maxy = max(y)
window,1
;cmin = min(data_plot)
cmax =1* max(data_plot)
cmin=cmax/30
;print,'cmin,cmax ',cmin,cmax

nlevs_max = 20
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
;plot_position1 = [0.1,0.1,0.9,0.45]
;plot_position2 = [0.1,0.6,0.9,0.95]
 plot_position=[0.1,0.1,0.9,0.9]
CONTOUR, DATA_PLOT, X,Y,XSTYLE =1,YTITLE='ht',title='0715_1',POSITION= PLOT_POSITION,$
LEVELS = CLEVS, /FILL, C_COLORS = C_INDEX, color=2,/FOLLOW;
       ;/OVERPLOT,LEVEL=1.0,


; add labs
lab = 'the subtitle'
xyouts,minx,miny-40,lab,charsize=1.1,color=2,charthick=2
; add scale lines over contours, if int_skip not = 1 then then clevs will be changed
INT_SKIP = 2 ; where to drawlines


;CLEVS =CMIN+FINDGEN(NLEVS_MAX/INT_SKIP)*(cint*int_skip)
;CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
;CLABS = STRARR(NLEVS_MAX/INT_SKIP)
;FOR I = 0, NLEVS_MAX/INT_SKIP-1 do begin
 ; CLABS(i)=string(format='(i4)',CLEVS(i))
;;ENDFOR
;;CONTOUR, DATA_PLOT,X,Y,LEVELS = CLEVS,$
;;C_CHARSIZE = 0.6, C_ANNOTATION =CLABS,color=0,/overplot
;return
;stop
; plot a color bar, use the same clevs as in the contour

BAR_POSITION=[0.93,0.10,0.96,0.90]
zb = fltarr(2,nlevs)
for k = 0, nlevs-1 do zb(0:1,k) = cmin + cint*k
xb = [0,1]
yb = cmin + findgen(nlevs)*cint
xname = [' ',' ',' ']

CONTOUR, zb, xb(0:1), yb(0:nlevs-1),  xrange=[0,1],/xstyle,xtickv=findgen(2),$
  xticks=1,xtickname=xname, yrange =[cmin,cmax],/YSTYLE, LEVELS = CLEVS0,$
  C_COLOR = C_INDEX, /FILL, ycharsize=0.7, $
  xcharsize=0.8,/noerase,position=bar_position

; add labs
ac = [0,1]
for i = 1, nlevs-2 do begin
  bc = [cmin+i*cint,cmin+i*cint]
  oplot,ac,bc,color=1 ;black, 0 = white
endfor
lab0 = string(cmax,format='(i2.2)')
xyouts,0.0,cmax*1.01,'P',charsize=0.9,color=2

return
;stop
end


