pro test_grid_contour
close,/all

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
;;;;;;;;;;;;;;;;;;;;;;;;;;;
; make a data set
;ix = 200
;x = findgen(ix)*!pi/180.0 ; as angles
;iy = 100
;y = findgen(iy)
;data_plot = fltarr(ix,iy)
;for i = 0, iy-1 do data_plot(*,i) = -15.0*cos(y(i)*!pi/180.0)+20.0*sin(x(*))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

read,ndata,prompt='number of data: '
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
O2data=fltarr(4,8964); for B file
;O2data=fltarr(3,20930); for A file
Imgdata=fltarr(3,ndata);
 fileA='E:\RSI\data\GWLL007B.txt'
 openr,1,fileA
 readf,1,Imgdata

;Bk=380; background=384 count
x1 = Imgdata[0,*]
y1 = Imgdata[1,*]

z1 =Imgdata[2,*]
z2=smooth(z1,3)
BK=min(z2)
print,'BK= ',BK
z=z2-bk


GRID_INPUT, x1, y1, z, xSorted, ySorted, ZSorted
openw,2,"E:\rsi\waves\O2wvsort.txt"

o2data[0]=xsorted
o2data[1]=ysorted
o2data[2]=zsorted
o2data[3]=z

printf,2,o2data
close,2

scaledZ = BYTSCL(ZSorted, TOP = !D.TABLE_SIZE - 4) + 1B
plot_position1 = [0.2,0.6,0.8,0.95]
plot_position2 = [0.2,0.15,0.8,0.5]
help,scaledZ
; Open a display window and plot the resulting data points.
WINDOW, 0
plot,z ,$ ; xtitle='#',Ytitle='counts',&
position=plot_position1

;stop

PLOT, xSorted, ySorted, /XSTYLE, /YSTYLE, LINESTYLE = 1, $
   TITLE = 'O2 data: ', $
   XTITLE = 'Latitude', YTITLE = 'Longitude' ,$
   position=plot_POSITION2

;stop

window, 1

FOR i = 0L, (N_ELEMENTS(xSorted) - 1) DO PLOTs, $
   xSorted[i], ySorted[i], PSYM = -1, COLOR = scaledZ[i],$
   SYMSIZE = 2.
  ;position=Plot_position2

;print,z[0:20]
;print,data_plot[0:20]
;stop

x=rebin(x1,20)
y=rebin(y1,20)

minx = min(x)
maxx = max(x)
miny = min(y)
maxy = max(y)

cmin = min(z)
cmax = max(z)
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
  LEVELS = CLEVS0, $
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

end