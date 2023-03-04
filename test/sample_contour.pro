pro sample_contour
;-----------------
; to plot data in colours
; need a color file named hues.dat
;
;October, 2007
;By Shengpan Zhang
;At NCU
;------------------
device, decomposed=0
; to decide to display / print, color/no color
;set_plot,'X' ;for x windows
;-----------------------
printfile='n'
read,'Store to a file instead of displaying (y/n)? ',printfile
plot_color=1
;read,'Enter 1/0 for color/no-color contour plot: ',plot_color
filetype='ps'
if (printfile eq 'y') then begin
  read,'Enter ps/eps for filetype: ',filetype
  if (filetype eq 'ps') then begin
    thisDevice = !D.Name
    set_plot,'ps'
    if plot_color eq 0 then device, filename='image_out.ps'
    if plot_color eq 1 then device,filename='image_out.ps',/color
    ;Device,/Close_File ; wit this command, 0 file size was produced
    print,'Plot will be written to file image_out.ps'
  endif
  if (filetype eq 'eps') then begin
    thisDevice = !D.Name
    set_plot,'ps'
    if plot_color eq 1 then $
    device,/ENCAPSULATED,preview=1,filename='image_out.eps',/color
    if plot_color eq 0 then $
    device,/ENCAPSULATED,filename='image_out.eps'
    ;Device,/Close_File
    print,'Plot will be written to file image_out.eps'
  endif
endif
;-----------------------------
;start with a colour table, read in from an external file
rgb = bytarr(3,256)
openr,2,'e:\rsi\hues.dat'
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

; make a data set
ix = 200
x = findgen(ix)*!pi/180.0 ; as angles
iy = 100
y = findgen(iy)
data_plot = fltarr(ix,iy)
for i = 0, iy-1 do data_plot(*,i) = -15.0*cos(y(i)*!pi/180.0)+20.0*sin(x(*))

minx = min(x)
maxx = max(x)
miny = min(y)
maxy = max(y)

cmin = min(data_plot)
cmax = max(data_plot)
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

CONTOUR, DATA_PLOT, X,Y, title='test',$
XSTYLE =1, YSTYLE = 1, LEVELS = CLEVS, /FILL,$
C_COLORS = C_INDEX, color=2, C_CHARSIZE = 0.6,$
xticks=4,xtickname=[' ',' ',' ',' ',' ',' '],charsize=0.8, $
POSITION= PLOT_POSITION1,YTITLE = 'theYTITLE'

;plot contour
plot_position = [0.2,0.6,0.8,0.9]
CONTOUR, DATA_PLOT, X,Y, title='test',$
XSTYLE =1, YSTYLE = 1, LEVELS = CLEVS, /FILL,$
C_COLORS = C_INDEX, color=2, C_CHARSIZE = 0.6,$
; yticks=4,charsize=0.8, $
POSITION= PLOT_POSITION2,YTITLE = 'theYTITLE', xtitle='theXtitle',/noerase

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
CONTOUR, DATA_PLOT,X,Y,LEVELS = CLEVS,$
C_CHARSIZE = 0.6, C_ANNOTATION =CLABS,color=0,/overplot


; plot a color bar, use the same clevs as in the contour

BAR_POSITION=[0.90,0.10,0.95,0.95]
zb = fltarr(2,nlevs)
for k = 0, nlevs-1 do zb(0:1,k) = cmin + cint*k
xb = [0,1]
yb = cmin + findgen(nlevs)*cint
xname = [' ',' ',' ']

CONTOUR, zb, xb(0:1), yb(0:nlevs-1), $
  position=bar_position,$
  xrange=[0,1],/xstyle,xtickv=findgen(2),$
  xticks=1,xtickname=xname,$
  yrange =[cmin,cmax],/YSTYLE, $
  LEVELS = CLEVS0,$
  C_COLOR = C_INDEX, /FILL, ycharsize=0.7, $
  xcharsize=0.8,/noerase

; add labs
ac = [0,1]
for i = 1, nlevs-2 do begin
  bc = [cmin+i*cint,cmin+i*cint]
  oplot,ac,bc,color=1 ;black, 0 = white
endfor
lab0 = string(cmax,format='(i2.2)')
xyouts,0.0,cmax*1.01,'P',charsize=0.9,color=2

; plot dots
plot_position = [0.1,0.2,0.3,0.8]
ix = 11
x = findgen(ix)-5
y = x*x
plot,x,y,psym=8,position=plot_position,$
  xrange=[min(x),max(x)],/xstyle,$
  yrange=[min(y),max(y)],/ystyle,ytitle='Y=x^2',$
  color=2,/noerase
oplot,x,y,thick=2

end


