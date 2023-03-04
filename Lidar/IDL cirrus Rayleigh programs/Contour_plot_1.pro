Pro contour_plot_1
;start with a colour table, read in from an external file hues.dat
device, decomposed=0

rgb = bytarr(3,256)
openr,2,'d:\RSI\hues.dat'

readf,2,rgb
close,2
free_lun,2
r=bytarr(256)
g = r
b = r
r(0:255) = rgb(0,0:255)
g(0:255) = rgb(1,0:255)
b(0:255) = rgb(2,0:255)
tvlct,r,g,b
!P.BACKGROUND= 1 ; 0 = black, 1 = white
!P.COLOR=2 ;blue labels
cmax=500
cmin=50
nlevs_max=40
cint=(cmax-cmin)/nlevs_max
CLEVS = CMIN + FINDGEN(NLEVS_MAX+1)*CINT
CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
z=fltarr(200,30) ;

x=findgen(200)
y=findgen(30)
For ix=0,199 do begin
  For iy=0,29 do begin
  z[ix,iy]=400*(sin(y[iy])*cos(x[ix])+2*sin(y[iy]))*exp(-iy/15.)
  endfor
Endfor
;contour plot in the following
contour,z,x,y,xrange=[0,160],yrange=[0,30],LEVELS = CLEVS, /FILL,$
 C_COLORS = C_INDEX, color=2

stop
end