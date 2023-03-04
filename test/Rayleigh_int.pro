
pro Rayleigh_int
;-----------------------
;
;--------------------------
device, decomposed=0
; to decide to display / print, color/no color
;set_plot,'X' ;for x windows
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

;---------------------
;the main code
dt = '1007'
print,'days in 2004 OCT: 07-08,10,13-17'
read,'Enter mmdd as 1007 : ',dt
fname = 'd:\rsi\spR\is_k0_aur_2004'+dt

print,'input file : ',fname
mm = sddc_read_cdf(fname)   ; image file originally is (128,524)

;help,mm
help,mm,/stru
ix = 524
iy = 128

x = findgen(ix)
y = findgen(iy)
ix1 = ix/2
x0 = findgen(ix1)

minx = min(x)
maxx = max(x)
miny = min(y)
maxy = max(y)

; image after removing back ground emission
new_mm = intarr(ix,iy)
;---------------
m1 = 1
m2 = 1
mp = 65
if dt eq '1014' then mp = 70 ; middle point for background subtraction
print,'Total 128 images (1-128)'
read,'Enter the first and last images to display (as 10, 20) : ',m1,m2
for im = m1, m2 do begin
  aim = string(im,format='(i3.3)')
  tvmm = rotate(mm(im-1).img0,3) ; rotate 270 deg. to make image file as (524,128)

; remove background emission, use row no. 7 as the bottom (in some images there are hot spots
; near the bottom), and row no. iy-2 as the top
; to avoid bad counts in some pixels in the first and last rows
; since the image is made of two parts, the keft half and the right half with different
; dark counts, do the two parts separately
  for j0 = 0, 1 do begin
    x1 = j0*ix1
    x2 = (j0+1)*ix1-1
    back1 = intarr(ix1) & back2 = back1
    back1(0:ix1-1) = tvmm(x1:x2,1)  ;the one one pixel above the bottom row
    if dt eq '1014' and im eq 92 and j0 eq 1 then $
      back1(0:ix1-1) = tvmm(x1:x2,20)
    back2(0:ix1-1) = tvmm(x1:x2,iy-2)    ;the one one pixel below the top row
    ; when there are both O(1D) and OH layers the top row are O(1D) emissions so cannot be
    ; used as the background emission
    if dt eq '1014' or dt eq '1015' or dt eq '1016' or dt eq '1017' then $
      back2(0:ix1-1) = tvmm(x1:x2,mp)  ; the row between the two layers
    ss = where(back1 lt 500,nn) ; 500-maximum for the back emission at the bottom row
    ab1 = total(back1(ss))/nn+25 ; 25 - range for the back emission variation
    ss = where(back2 lt 550,nn) ; 550-maximum for the back emission at the top row
    ab2 = total(back2)/nn+25
print,'min,max b1, b2:',j0,min(back1),max(back1),ab1-25,min(back2),max(back2),ab2-25
; for i = 0, ix1-1 do print,i,back1(i),back2(i)
    ss = where(back1 lt ab1,nn)
    if nn lt ix1 then back1 = interpol(back1(ss),x0(ss),x0)
    ss = where(back2 lt ab2,nn)
    if nn lt ix1 then back2 = interpol(back2(ss),x0(ss),x0)
;smooth 5 times
    for ii = 0, 5 do begin
      tmp = back1
      for i = 1, ix1-2 do back1(i) = 0.25*(tmp(i-1)+tmp(i)*2+tmp(i+1))
      tmp = back2
      for i = 1, ix1-2 do back2(i) = 0.25*(tmp(i-1)+tmp(i)*2+tmp(i+1))
    endfor
    print,'min,max b1, b2:',j0,min(back1),max(back1),min(back2),max(back2)

    ;for i = 1, 10 do print,i,back1(i),back2(i)

; suntract the background emission
    for i = x1, x2 do begin
      for j = 0, iy-1 do begin
        backe = (back2(i-x1)-back1(i-x1))*j/iy+back1(i-x1)
        if backe gt 0 then new_mm(i,j) = tvmm(i,j) - backe
      endfor
    endfor
; when there are two layers to interpolate for pixels above row No. 65
    if dt eq '1014' or dt eq '1015' or dt eq '1016' or dt eq '1017' then begin
      for i = x1, x2 do begin
        for j = 0, mp do begin
          backe = (back2(i-x1)-back1(i-x1))*j/mp+back1(i-x1)
          if backe gt 0 then new_mm(i,j) = tvmm(i,j) - backe
        endfor

        db = 1.0*(back2(i-x1)-back1(i-x1))/mp
        for j = mp+1, iy-1 do begin
          backe = db*(j-mp)+back2(i-x1)
          if backe gt 0 then new_mm(i,j) = tvmm(i,j) - backe
        endfor
      endfor
    endif
;for i = 0, ix-1 do print,i,back1(i),back2(i)
  endfor
  print,'min,max of New:',min(new_mm),max(new_mm)
  s0 = where(new_mm lt 0,n0)
  if n0 gt 0 then new_mm(s0) = 0
; convert counts to Rayleighs
  int_data = fltarr(ix,iy)
  for i = 0, ix-1 do begin
    for j = 0, iy-1 do begin
      int_data(i,j) = im_intensity(3,595,new_mm(i,j))
    endfor
  endfor
  int_data = int_data * 1.0e6 ; Rayleighs, originally it was in MR (=10^6 Rayleighs)
;-------------------
  for i0 = 0, 1 do begin
    if i0 eq 0 then data_plot = tvmm
    if i0 eq 1 then data_plot = int_data  ;new_mm

    cmin = min(data_plot)
    cmax = max(data_plot)
    print,'no.,min,max of the image: ',im,cmin,cmax

;read,'Enter cmin,cmax : ',cmin,cmax

    cmin = 400 ; adjust cmin and cmax for the best range
    cmax = 650
    ;;if dt eq '1007' or dt eq '1008' or dt eq '1016' then cmax = 650
    ;;if dt eq '1013' then cmax = 550
    ;;if dt eq '1017' then cmax = 700
    if i0 eq 1 then begin
      cmin = 0
      cmax = im_intensity(3,595,150); in Mega Rayleighs
      cmax = cmax * 1.0e6           ; in Rayleigh
    endif

    nlevs_max = 20 ; choose what you think is right
    cint = (cmax-cmin)/nlevs_max
    CLEVS = CMIN + FINDGEN(NLEVS_MAX+1)*CINT
    CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
    clevs0 = clevs ; for plot the color bar

    NLEVS = N_ELEMENTS(CLEVS)+1 ;actual number of countour levels
    col = 240 ; don't change it
    C_INDEX=(FINDGEN(NLEVS)+1)*col/(NLEVS)
    c_index(NLEVS-1) = 1 ; missing data = white
;print,'C_index ',c_index
;plot contour
    plot_position = [0.1,0.6-i0*0.4,0.9,0.9-i0*0.4]
    BAR_POSITION=[0.95,0.6-i0*0.4,0.96,0.9-i0*0.4]
    if i0 eq 0 then CONTOUR, DATA_PLOT, X,Y, title=fname+' image No. '+aim,$
      XSTYLE =1, YSTYLE = 1, LEVELS = CLEVS, /FILL,$
      C_COLORS = C_INDEX, color=2, C_CHARSIZE = 0.6,$
; yticks=4,charsize=0.8, background=1,$
      POSITION= PLOT_POSITION,YTITLE = 'Pixel position'

    if i0 eq 1 then CONTOUR, DATA_PLOT, X,Y, title='Rayleighs Backgrond emission removed',$
      XSTYLE =1, YSTYLE = 1, LEVELS = CLEVS, /FILL,$
      C_COLORS = C_INDEX, color=2, C_CHARSIZE = 0.6,$
; yticks=4,charsize=0.8, background=1,$
      POSITION= PLOT_POSITION,YTITLE = 'Pixel position', $
      xtitle='Pixel position',/noerase

; add labs
;lab = 'the subtitle'
;xyouts,minx,miny-40,lab,charsize=1.1,color=2,charthick=2

; plot a color bar, use the same clevs as in the contour

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
;  ac = [0,1]
;  for i = 1, nlevs-2 do begin
;    bc = [cmin+i*cint,cmin+i*cint]
;  oplot,ac,bc,color=1 ;black, 0 = white
;  endfor
;  lab0 = string(cmax,format='(i2.2)')
;xyouts,0.0,cmax*1.01,'P',charsize=0.9,color=2
  endfor
  wait,1
endfor

end
;-----------------------------------


