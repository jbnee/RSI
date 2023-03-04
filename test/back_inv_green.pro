
pro back_inv_green
;-----------------------
; to read CDF file and produce a file for inverted volume emission rate for O(1S) layer
;
; 1. run 'sddc_read_cdf' to get ISUAL CDF airglow data file,
; 2. make background emission data, then subtract the background emissions
; 3. separate one image into sets, each set has 10 columns (from column 7, as 7-16, 17-26, ...),
;    and decide the veritical pixel position to include the OH layer for
;    calculating positions of tangent point (latitude, longitude, and height)
;    using INTERPOL_PROJ_LL.PRO
; 4. convert counts to Rayleighs using IM_INTENSITY.PRO
; 5. invert LOS (line of sight) intensity in Rayleigh to vertical profile of volume emission rate
;    (VER photons cm^(-3) s^(-1)
; 6. average the 8 vertical profiles (do not use the min and the max points) to get the final
;    vertical profile
;
; while running this program it will
; plot the original image and the background emission subtracted data,
;      the profiles of LOS intensity, the 10 inverted VER profiles,
;      and the averaged vertical profile
;
; input: 1) date of the image (month and day if the year is given) as mmdd
;        2) set number of column
; (here use 5 sets as 5, 15, 25, 35, and 45 for one image, each has 10 columne from px1 to px2)
;
; output: a file for volume emission rates, hights, latitudes, and longitudes for every images
;         in a day
;
; Shengpan Zhang
; Oct-Nov. 2007
; NCU, Taiwan
;--------------------------
device, decomposed=0
;
;-----------------------------
;start with a colour table, read in from an external file hues.dat
rgb = bytarr(3,256)
openr,2,'d:\rsi\spz_work\data_file\hues.dat'
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
;---------------------
add = 'd:\rsi\spz_work\data_file\'  ; my data file location
line = ' '
big_number = 1.0e6
;the main code
year = '04'
;read,'Enter year as 04, 05, 06, 07 : ',year
dt = '1105'
;print,'days in 2004 NOV: 05,06,07,09,11,12'
;read,'Enter mmdd as 1105 : ',dt
fname = 'd:\rsi\cdf\is_k0_aur_20'+year+dt
print,'input file : ',fname
hv = 491.76471
;------------------------
;--get the file of the day
mm = sddc_read_cdf(fname) ;there are 129 images in a day as mm(i) i=0,128, each image is (524,128)
;help,mm
;help,mm,/stru

ix0 = 524
iy0 = 128
; for background subtraction
ix1 = ix0/2 ;for background removal
x0 = findgen(ix0)

; to get longitude, latitude, and height of tanget points, reduce the size of the image
; make an array of data using the middle 10 rows
ix = 10 ;px2-px1+1
iy = 56 ;py2-py1+1
;use the centre 10 columns only, other columns may give incorrected tangent heights

k0 = 45
read,'Enter k0 for column set number (5,15,25,35,45, k0=25 is the center set) :',k0
ak0 = string(k0,format='(i2.2)')
px1 = 7+k0*10   ;first horizontal pixel number
px2 = px1+ix-1  ;last
px0 = px1+4

py1 = 70-0.5*abs(25-k0) ;adjust py1 according to column location (vertical pixel number)
py2 = py1+iy-1
if k0 eq 5 then py0 = 92 ;estimated peak pixel position
if k0 eq 15 then py0 = 100
if k0 eq 25 then py0 = 102
if k0 eq 35 then py0 = 102
if k0 eq 45 then py0 = 100
apx1 = string(px1,format='(i3.3)')
apx2 = string(px2,format='(i3.3)')
; for final profile
if k0 le 25 then yy1 = 70.0-0.5*abs(25-k0)  ;km
if k0 gt 25 then yy1 = 70.0+0.2*abs(25-k0)  ;km
yy2 = yy1 + 60.0
dy = 2.0
iyy = (yy2-yy1)/dy+1
yy = findgen(iyy)*dy+yy1
h_0 = 50.0  ;min TPA height
h_1 = 125 ;max TAP height
if k0 ge 35 then begin
  h_0 = 55
  h_1 = 130
endif
print,px1,px2,py1,py2

;output file
max_im0 = 129
fout = add + 'tmp.dat' ;'profiles_'+ak0+'_'+year+'_'+dt+'.dat'
get_lun,lun_out
openw,lun_out,fout
printf,lun_out,'Volume emission rate profiles of the O(1S) Layer'
printf,lun_out,'Using columns No. '+apx1+' - '+apx2
printf,lun_out,'Local Time is given by UT and longitude'
printf,lun_out,'Total images :'
printf,lun_out,max_im0
printf,lun_out,'Height y(km)= findgen(iy)*dy + y0, iy,y0,dy:'
printf,lun_out,iyy,yy1,dy
;printf,lun_out,'ix x0 dx: x(pixel position)=x0+findgen(ix)*dx'
; for final profile

prf = fltarr(ix,iyy)
max_im = 129
for im = 2,2 do begin ;1, max_im do begin  ; 2, 2 do begin ;
  ut0 = mm(im-1).buffer_switch_time/1000.0/60.0/60.0/24.0 ;in days
  ut = (ut0-long(ut0))*24.0 ; in hours
  hv = mm(im-1).mcp_hv
  filter = mm(im-1).filter_code

  aim = string(im,format='(i3.3)')
  ht = fltarr(ix,iy) & lat = ht & lon = ht
  for i = px1, px2 do begin
    i0 = i-px1
    for j = py1, py2 do begin
      j0 = j-py1
      th1 = h_0
      th2 = h_1
      ll1 = interpol_proj_ll(mm(im-1),i,j,th1) ; for an unrotared image
      ll2 = interpol_proj_ll(mm(im-1),i,j,th2) ; for an unrotared image
; if ll1(0) = 0 and ll2(0) = 0 then ll1(0)+ll2(0) = 0, TH > th2
; if ll1(0) ne 0 and ll2(0) ne 0 then ll1(0)*ll2(0) ne 0, TH < th1
; if ll1(0) eq 0 and ll2(0) ne 0 then th1 < TH < th2
      if (ll1(0)+ll2(0) eq 0) or (ll1(0)*ll2(0) ne 0) then ht(i0,j0) = 0
      if ll1(0)+ll2(0) ne 0 and ll1(0)*ll2(0) eq 0 then begin
        repeat begin
          th3 = 0.5*(th1+th2)
          l3 = interpol_proj_ll(mm(im-1),i,j,th3)
          if l3(0) eq 0 then th1 = th3  ; ht > th3
          if l3(0) ne 0 then begin
            th2 = th3  ; ht < th3
            lat1 = l3(1)
            lon1 = l3(0)
          endif
        endrep until (abs(th2-th1) lt 1.0)
        th3 = 0.5*(th1+th2)
        ht(i0,j0) = th3
      endif
  ;print,i,j,ht0,th1,th2
      if j eq py0 and i eq px0 then begin
        the_lat = lat1
        the_lon = lon1
        the_ltm = ut + the_lon/15.0 ; in hours
  ;print,'Image ',im,' column',i,j,ht(i0,j0),the_lat,the_lon,the_ltm
      endif
    endfor
  endfor
  ss = where(ht eq 0,nn)
  if nn gt 0 then ht(ss) = big_number
;----------------------
  tvmm = rotate(mm(im-1).img0,3)
; tvmm is an image rotated by 270 deg. to make image file as (524,128)
;--------------------------------------------------
; since the image is made of two parts, the left half and the right half with different
; dark counts, do the two parts separately
  mbc = fltarr(ix0,iy0) & bc = mbc
  by1 = 2 ;do not use the first and last points
  by2 = iy0-3
  dby = by2-by1 ; total pixels between by1 and by2
  max_bc1 = 430
  max_bc2 = max_bc1
  gn_bc = 5 ; the pixels below the layer are affected by green layer which is not backE!
  for j0 = 0, 1 do begin ;two halves of one image
    x1 = j0*ix1
    x2 = (j0+1)*ix1-1
    back1 = intarr(ix1) & back2 = back1
    back1(0:ix1-1) = tvmm(x1:x2,by1)
    back2(0:ix1-1) = tvmm(x1:x2,by2)    ;the one one pixel below the top row
; adjust maxb1 and maxb2
    ss = where(back1 lt max_bc1,nn)
    ab1 = total(back1(ss))/nn+15
    ss = where(back2 lt max_bc2,nn)
    ab2 = total(back2)/nn+15
;print,'ab1 ab2 : ',j0,ab1-25,ab2-25
;print,'min,max b1, b2:',j0,min(back1),max(back1),min(back2),max(back2)
; for i = 0, ix1-1 do print,i,back1(i),back2(i)
    ss = where(back1 lt ab1,nn)
    if nn lt ix1 then back1 = interpol(back1(ss),x0(ss),x0)
    ss = where(back2 lt ab2,nn)
    if nn lt ix1 then back2 = interpol(back2(ss),x0(ss),x0)
;adjust back subtraction at the bottom
    back1 = back1 - gn_bc
;smooth 5 times
    for ii = 0, 4 do begin
      tmp = back1
      for i = 1, ix1-2 do back1(i) = 0.25*(tmp(i-1)+tmp(i)*2+tmp(i+1))
      tmp = back2
      for i = 1, ix1-2 do back2(i) = 0.25*(tmp(i-1)+tmp(i)*2+tmp(i+1))
    endfor
;print,'min,max b1, b2:',j0,min(back1),max(back1),min(back2),max(back2)
;---------------------
; suntract the background emission
    for i = 0, ix1-1 do begin
      dbc = 1.0*(back2(i)-back1(i))/dby
      for j = 0, iy0-1 do begin
        if j le by1 then backe = back1(i) - dbc * (by1-j)
        if j gt by1 then backe = back1(i) + dbc * (j-by1)
        bc(i+x1,j) = backe
      endfor
    endfor
  endfor
; subtract BC
  mbc = tvmm - bc
;print,'min,max of New image:',min(mbc),max(mbc)
  s0 = where(mbc lt 0,n0)
  if n0 gt 0 then mbc(s0) = 0
;print,'Number of zero points in the new image : ',n0
;---------------------------
; plot original image and the image after subtracting the background emission
  x = findgen(ix0)
  y = findgen(iy0)
  ;help,x
  ;help,y
  for i0 = 0, 1 do begin
    if i0 eq 0 then data_plot = tvmm
    if i0 eq 1 then data_plot = mbc

    cmin = min(data_plot)
    cmax = max(data_plot)
 print,'no.,min,max of the image: ',im,cmin,cmax

;read,'Enter cmin,cmax : ',cmin,cmax

    cmin = 400 ; adjust cmin and cmax for a better range
    cmax = 580
    if i0 eq 1 then begin
      cmin = 0
      cmax = 150  ;im_intensity(3,595,120)
 ;cmax = cmax * 1.0e6 ;Rayleighs for count = 200
    endif

    nlevs_max = 20 ; choose what you think is right
    cint = (cmax-cmin)/nlevs_max
    CLEVS = CMIN + FINDGEN(NLEVS_MAX+1)*CINT
    CLEVS = CLEVS(WHERE(CLEVS LE CMAX))
    clevs0 = clevs ; for plot the color bar

    NLEVS = N_ELEMENTS(CLEVS)+1 ;actual number of countour levels

    ;print,i0,' cmin,cmax',cmin,cmax,cint,nlevs

    col = 240 ; don't change it
    C_INDEX=(FINDGEN(NLEVS)+1)*col/(NLEVS)
    c_index(NLEVS-1) = 1 ; missing data = white
;print,'C_index ',c_index
;plot contour
    plot_position = [0.1+i0*0.45,0.6,0.45+i0*0.45,0.9]
    BAR_POSITION=[0.50+i0*0.45,0.6,0.51+i0*0.45,0.9]
    minx = 0
    maxx = 524
    if i0 eq 0 then CONTOUR, DATA_PLOT, X,Y, title=dt+' No.'+aim,$
      xrange=[minx,maxx],XSTYLE =1, YSTYLE = 1, LEVELS = CLEVS, /FILL,$
      C_COLORS = C_INDEX, color=2, C_CHARSIZE = 0.6,$
; yticks=4,charsize=0.8, background=1,$
      POSITION= PLOT_POSITION,YTITLE = 'Pixel position'

    minx = px1-30
    maxx = px2+30
    aa = [minx,minx]
    bb = [0,iy0-1]
    oplot,aa,bb
    aa = [maxx,maxx]
    oplot,aa,bb
    aa = [px1,px2]
    bb = [py1,py1]
    oplot,aa,bb
    bb = [py2,py2]
    oplot,aa,bb

    if i0 eq 1 then CONTOUR, DATA_PLOT, X,Y, title='Back-e removed',$
      xrange=[minx,maxx],XSTYLE =1,YSTYLE = 1, LEVELS = CLEVS, /FILL,$
      C_COLORS = C_INDEX, color=2, C_CHARSIZE = 0.6,$
; yticks=4,charsize=0.8, background=1,$
      POSITION= PLOT_POSITION,/noerase
    aa = [px1,px1]
    bb = [0,iy0-1]
    oplot,aa,bb
    aa = [px2,px2]
    oplot,aa,bb
    aa = [px1,px2]
    bb = [py1,py1]
    oplot,aa,bb,color=1
    bb = [py2,py2]
    oplot,aa,bb,color=1
; add labs
;lab = 'the subtitle'
;xyouts,minx,miny-40,lab,charsize=1.1,color=2,charthick=2

; plot a color bar, use the same clevs as in the contour

    zb = fltarr(2,nlevs)
    for k = 0, nlevs-1 do zb(0:1,k) = cmin + cint*k
    xb = [0,1]
    yb = cmin + findgen(nlevs)*cint
    xname = [' ',' ',' ']
    CONTOUR, zb, xb(0:1), yb(0:nlevs-1),position=bar_position,$
      xrange=[0,1],/xstyle,xtickv=findgen(2),$
      xticks=1,xtickname=xname,yrange =[cmin,cmax],/YSTYLE, $
      LEVELS = CLEVS0,C_COLOR = C_INDEX, /FILL, ycharsize=0.7, $
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
;-------------------
  mm1 = fltarr(ix,iy) ; for the image after subtracting the background emission
  mm1(0:ix-1,0:iy-1) = mbc(px1:px2,py1:py2) ; to be the same array as lat, lon, and ht
  mm2 = mm1
  x = findgen(ix)
; filling single missing points
  for j = 0, iy-1 do begin
    for i = 1, ix-2 do begin
      if mm2(i,j) eq 0 and mm2(i-1,j)*mm2(i+1,j) ne 0 then mm1(i,j)=0.5*(mm2(i-1,j)+mm2(i+1,j))
    endfor
  endfor
  mm2 = mm1
  for i = 0, ix-1 do begin
    for j = 1, iy-2 do begin
      if mm2(i,j) eq 0 and mm2(i,j-1)*mm2(i,j+1) ne 0 then mm1(i,j)=0.5*(mm2(i,j-1)+mm2(i,j+1))
    endfor
  endfor
; remove zero data by interpolating
  for j = 0, iy-1 do begin
    tmp1 = fltarr(ix)
    tmp1(*) = mm1(*,j)
    s0 = where(tmp1 gt 0,n0)
    if n0 lt ix and n0 gt 3 then begin
      tmp2 = interpol(tmp1(s0),x(s0),x)
      mm1(*,j) = tmp2(*)
    endif
  endfor
; smooth once by 1:2:1
  for k = 0, 0 do begin
    mm2 = mm1
    for i = 0, ix-1 do begin
      for j = 1, iy-2 do begin
        mm1(i,j) = 0.25*(mm2(i,j-1)+2.0*mm2(i,j)+mm2(i,j+1))
      endfor
    endfor
    mm2 = mm1
    for j = 0, iy-1 do begin
      for i = 1, ix-2 do begin
        mm1(i,j) = 0.25*(mm2(i-1,j)+2.0*mm2(i,j)+mm2(i+1,j))
      endfor
    endfor
  endfor
;------------------------------
;to convert counts to Rayleighs using IM_INTENSITY.pro
  max_ray = 4000
; set a maximum Rayleigh to remove spikes due to cosmic rays
  int_data = fltarr(ix,iy)
  for i = 0, ix-1 do begin
    for j = 0, iy-1 do begin
    ; give Rayleighs, originally it is in MR (=10^6 Rayleighs)
      if mm1(i,j) gt 0 then int_data(i,j) = im_intensity(filter,hv,mm1(i,j))*1.0e6
    endfor
  endfor
  s0 = where(int_data eq 0,n0)
  if n0 gt 0 then print,'zero points in int_data :',n0
print,'min/max Int : ',min(int_data),max(int_data)
;--------------------------------------------
; inversion
;----------------
; from Yves Rochon's PH.D thesis, page 233-234
; I = MK E
; where I is the integrated volume emission rate alone LOS in Rayleigh given by int_data
; MK(i,j) is a matrix given by Eq (7.4),
; BUT modified by Shengpan Zhang because his equation would not give a lower triangular matrix!
; original equation:
; mk_i,j = 0.2*(sqrt((z_j-1-h_i)(z_j-1+h_i+2Re))-sqrt((z_j-h_i)(z_j+h_i+2Re)))
; i for the height of a tangen point, j for atmosphere layers covering the OH emission layer
; E is the inverted volume emission rate in Photons cm^-3 s^-1
; z_j = (h_j+1+h_j)/2
;-----
; modified equation:
; mk_i,j = 0.2*(sqrt((z_i-1-h_j)(z_i-1+h_j+2Re))-sqrt((z_i-h_j)(z_i+h_j+2Re)))
; j for the height of a tangen point, i for atmosphere layers covering the OH emission layer
; z_j = (h_j+1+h_j)/2
;
; NOTE: z0>z1>z2> ... and h0>h1>h2> ...
; h_j for j = 0, 1, 2, ... n-1,n
; z_i for i = 0, 1, 2, ... n-1
;
; for mk(i,j), i = 0,1,2 ..., n-1, and j = 0, 2, 3, ... n-1, mk(i,j) = 0 when i> j
;----------------------
  re = 6378.136 ;the Earth's average radius in km
  re2 = 2.0*re
  for ia = 0, ix-1 do begin
    tmp = fltarr(iy) & h0 = tmp & te0 = tmp
; make h(i) > h(i+1) from high altitude (h0(0)) to low altitude (h0(iy-1)) !!!
    tmp(*) = 1.0*ht(ia,*)
    for j = 0, iy-1 do h0(j) = tmp(iy-1-j)
    tmp(*) = int_data(ia,*)
    for j = 0, iy-1 do te0(j) = tmp(iy-1-j)
; calculate z(iy), NOTE there are points whose h = bad data (=1.0e6) and should be removed
    sa = where(h0 lt 900,ny)
    if ny gt 10 then begin
      h = h0(sa) & z = h
      te = te0(sa)
;   print,ia,' iy and ny, h0: ',iy,ny,min(h0(sa)),max(h0(sa))
      for j = 0, ny-2 do z(j) = 0.5*(h(j+1)+h(j))
      z(ny-1) = 0.5*(3.0*h(ny-1)-h(ny-2)) ; the estimated last z value
; calculate mk(ny,ny) but only for (1:ny-2,1:ny-2) due to the invertion method
      mk = fltarr(ny,ny)
      tt = fltarr(ny)
      for i = 1, ny-1 do begin
        for j = 0, ny-1 do begin
          t1 = 0.0 & t2 = 0.0
        ; using the format given by Yves the matrix mk would be
        ; square, upper trianglar and diagonally dominant, not as he wrote 'lower triangular...'
        ;if z(j-1)-h(i) gt 0 and z(j)-h(i) gt 0 then begin
        ;  t1 = sqrt((z(j-1)-h(i))*(z(j-1)+h(i)+re2))
        ;  t2 = sqrt((z(j)-h(i))*(z(j)+h(i)+re2))
        ;endif
        ;see notes given above
        ;t1 and t2 are modified to the followings
          if z(i-1)-h(j) gt 0 and z(i)-h(j) gt 0 then begin
            t1 = sqrt((z(i-1)-h(j))*(z(i-1)+h(j)+re2))
            t2 = sqrt((z(i)-h(j))*(z(i)+h(j)+re2))
          endif
          mk(i,j) = 0.2*(t1-t2)
        endfor
      endfor
; makr mk as a square, lower triangle and dominant matrix, that mk_ij = 0 when i>j
      ny1 = ny-2
      mk1 = fltarr(ny1,ny1)
      mk1(0:ny1-1,0:ny1-1) = mk(1:ny-2,2:ny-1) ;checked, must be this way!
      te1 = fltarr(ny1)
      te1(0:ny1-1) = te(1:ny-2)
; interpolate and smooth te1 onece
      hy = findgen(ny1)
      hy(0:ny1-1) = h(1:ny1)
;print,ny1,' min,max hy ',min(hy),max(hy),' te',min(te1),max(te1)
      ss = where(te1 ne 0 and te1 lt max_ray,nn)
      if nn lt ny1 and nn gt ny1/2 then begin
        tmp1 = interpol(te1(ss),hy(ss),hy)
        te1 = tmp1
      endif
      tmp1 = te1
      for i = 1, ny1-2 do te1(i) = 0.25*(tmp1(i-1)+tmp1(i+1)+2.0*tmp1(i))

;for i = 0, ny1-1 do print,y_tmp(i),te1(i)
;print,'min,max te :',min(te1),max(te1),' at h=',y_tmp(sp(0))
; plot profile of LOS integrated intensity in Rayleigh
      maxx = 20000
      plot,te1,hy,psym=2,position=[0.1,0.1,0.35,0.5],title='TPA Rayleighs',$
       xrange=[0,maxx],xticks=2,/xstyle,charsize=0.8,$
       yrange=[yy1,yy2],/ystyle,ytitle='Height',color=2,/noerase
      oplot,te1,hy

;----------------------------------
;solve the equation: te1 = mk1 * E(= inverted values) using CRAMER or LUDC and LUSOL
;NOTE because te1 is in Rayleigh (10^6 photons cm^(-2)s^(-1), mk in km=10^5 cm,
;to get inverted profile of the volume emission rate in photon cm^(-3) s^(-1)
;te1 should * 10
  ;resl =  cramer(mk1,te1)
  ;print,resl(10),min(resl),max(resl)
      te1 = 10.0*te1
      ludc,mk1,index
      resl = lusol(mk1,index,te1)
;      print,'min,max VER:',min(resl),max(resl),' min,max J',min(te1),max(te1)
      maxx = 5000
      minx = -100
; return data back to the original vertical order, i.e. h(i) < h(i+1)
; for j = 1, ny-2 do inv_e(i0,sa(j)) = resl(ny-1-j)

;smooth
;      tmp = resl
;      for i = 1, ny1-2 do begin
;        if tmp(i) lt 0 and tmp(i-1) gt 0 and tmp(i+1) gt 0 then $
;          resl(i)=0.5*(tmp(i-1)+tmp(i+1))
;      endfor
;      tmp = resl
;      for i = 1, ny1-2 do begin
;        if tmp(i) gt 0 and tmp(i-1) gt 0 and tmp(i+1) gt 0 then $
;          resl(i)=0.25*(tmp(i-1)+tmp(i+1)+2.0*tmp(i))
;      endfor
; keep data between 70 and 110 km
; re-arrange the data make it from low to high altitudes !!!
      t_h = hy
      for i = 0, ny1-1 do t_h(i) = hy(ny1-1-i)
      t_ver = resl
      for i = 0, ny1-1 do t_ver(i) = resl(ny1-1-i)
      ss = where(t_h ge yy1 and t_h le yy2,n1)
      tt = interpol(t_ver(ss),t_h(ss),yy)
      prf(ia,*) = tt(*) ;NOTE there are negative VERs in the profiles

      plot,tt,yy,psym=2,position=[0.45,0.1,0.70,0.5],title='Inverted VER',$
       xrange=[minx,maxx],xticks=2,/xstyle,charsize=0.8,$
       yrange=[yy1,yy2],/ystyle,ytitle='Height',color=2,/noerase
      oplot,tt,yy
      xa = [0,0]
      ya = [yy1,yy2]
      oplot,xa,ya
    endif
  endfor
;------------------
; average the ix profiles to give the final OH profile and alt, lat, and lon.
; make profiles from 70-110 km, every 2 km
  avg = fltarr(iyy) & psdv = avg
  for i = 0, iyy-1 do begin
    mn = min(prf(*,i))
    mx = max(prf(*,i))
    for j = 0, ix-1 do begin
      if prf(j,i) gt mn and prf(j,i) lt mx then avg(i) = avg(i) + prf(j,i)
    endfor
  endfor
  avg = avg/(ix-2) ; do not use min and max, so there are only ix-2 points
  for i = 0, iyy-1 do begin
    mn = min(prf(*,i))
    mx = max(prf(*,i))
    for j = 0, ix-1 do begin
      if prf(j,i) gt mn and prf(j,i) lt mx then $
      psdv(i) = psdv(i) + (prf(j,i)-avg(i))*(prf(j,i)-avg(i))
    endfor
  endfor
  psdv = sqrt(psdv/(ix-1))+2.0  ;Standard Deviation, 2.0 (estimated) is due to oh_bc
  sp = where(avg eq max(avg))
  ss = where(yy ge 76 and yy le 106,nn) ; for k0 = 25
  if k0 eq 5 then ss = where(yy ge 66 and yy le 96,nn)
  if k0 eq 15 then ss = where(yy ge 70 and yy le 100,nn)
  if k0 eq 25 then ss = where(yy ge 74 and yy le 104,nn)
  if k0 eq 35 then ss = where(yy ge 78 and yy le 108,nn)
  if k0 eq 45 then ss = where(yy ge 80 and yy le 110,nn)
  inte = 0.0 & isdv = 0.0
  for i = 0, nn-2 do begin
    if avg(ss(i)) lt 0 then avg(ss(i)) = 0.0
    if avg(ss(i+1)) lt 0 then avg(ss(i+1)) = 0.0
    t1 = avg(ss(i))+avg(ss(i+1))
    if t1 gt 0 then begin
      t2 = psdv(ss(i))+psdv(ss(i+1))
      dh = yy(ss(i+1))-yy(ss(i))
      inte = inte + 0.5*t1*dh
      isdv = isdv + 0.5*t2+dh
    endif
; print,i,avg(ss(i)),t1,inte,' ',t2,psdv(ss(i)),isdv
  endfor
  isdv = 0.1*isdv
  inte = inte * 0.1 ; Rayleighs
  print,aim,' Ph,Pver,I(R),lon,lat:',yy(sp(0)),max(avg),inte,the_lon,the_lat,' ltm',the_ltm
  plot,avg,yy,psym=2,position=[0.75,0.1,0.95,0.5],title='Avg VER',$
     xrange=[minx,maxx],xticks=2,/xstyle,charsize=0.8,$
     yrange=[yy1,yy2],/ystyle,ytitle='Height',color=2,/noerase
  oplot,avg,yy
  aa = [0,0]
  bb = [yy1,yy2]
  oplot,aa,bb,color=2
  ; plot errors
  for i = 0, iyy-1 do begin
    ax = [avg(i)-psdv(i),avg(i)+psdv(i)]
    ay = [yy(i),yy(i)]
    oplot,ax,ay
  endfor

  printf,lun_out,'Image No. '+aim
  printf,lun_out,'Longitude and Latitude in deg., and ltm (hours) by UT and Longitude'
  printf,lun_out,the_lon,the_lat,the_ltm
  printf,lun_out,'Integrated Volume Emission Rate (Rayleigh) and Error'
  printf,lun_out,inte,isdv
  printf,lun_out,'Volume Emission Rate (photons cm^(-3) s^(-1)) profile'
  printf,lun_out,avg
  printf,lun_out,'Errors of Volume Emission Rate (photons cm^(-3) s^(-1)) profile'
  printf,lun_out,psdv
  ;wait,2
  ;endif
endfor
close,lun_out
free_lun,lun_out
print,'Output file : ',fout

end
;-----------------------------------
; subroutines for some reasons, I cannot call them when they are not included in the file
function sddc_cdf_getvartype, zinfos, idx
  type = zinfos[idx].datatype
  case type of
    "CDF_EPOCH" : ret = '0d'
    "CDF_INT4"  : ret = '0l'
    "CDF_DOUBLE": ret = '0d'
    "CDF_INT2": begin
                dim1 = zinfos[idx].dim1
                dim2 = zinfos[idx].dim2
                if dim2 ne 0 then $
                  ret = "INTARR("+STRING(dim1, format='(I)')+","+STRING(dim2, format='(I)')+")" $
                else $
                  ret = "INTARR("+STRING(dim1, format='(I)')+")"
       end
    else: ret = ""
  endcase
  return, ret
end
;-----------------------------
function sddc_read_cdf, filename, rec_start=rec_start, rec_read=rec_read
  if n_elements(filename) eq 0 then $
    filename = "/nspo/scc/inbound/Level1Data/is_k0_aps_20010224.cdf"
  ;2004-07-30: fix error of lost data
  cdfId = cdf_open(filename)
  res   = cdf_inquire(cdfid)
  zvarN = res.nzvars

  ;Get names of zvars
  zvarinfo  = {name:"", datatype:"", dim1:0L, dim2:0L}
  zvarinfos = replicate(zvarinfo, zVarN)

  for i=1, zvarN-1 do begin
    tmpInfo           = cdf_varinq(cdfid, i, /zVar)
    zvarinfos[i].name = tmpInfo.name
    zvarinfos[i].datatype = tmpInfo.datatype
    if n_elements(tmpinfo.dim) eq 1 then begin
      zvarinfos[i].dim1 = tmpInfo.dim
    endif else if n_elements(tmpinfo.dim) eq 2 then begin
      zvarinfos[i].dim1 = tmpInfo.dim[0]
      zvarinfos[i].dim2 = tmpInfo.dim[1]
    endif
  endfor

  ;Create structure
  exec = "cdf = {"
  cnt  = 0
  for i=0, n_elements(zvarinfos.name)-1 do begin
    if cnt gt 0 then exec += ","
    if zvarinfos[i].name ne "" then begin
        exec += zvarinfos[i].name +":"+sddc_cdf_getvartype(zvarinfos, i)
        cnt += 1
    endif
  endfor
  exec += "}"
  ;print, exec
  resu = execute(exec)

  ;Get record number
  cdf_control, cdfid, var=zvarinfos[n_elements(zvarinfos)-1].name, /zvar, get_var_info=vinfo, set_padvalue=0.0d
  recNum = vinfo.maxrecs+1
  if recNum lt 1 then begin
    print, "Record nubmer eq zero..."
    return, -1
  endif

  if not keyword_set(rec_read ) then rec_read =recnum
  if not keyword_set(rec_start) then rec_start=0

  if rec_read+rec_start gt recnum then rec_read=recnum-rec_start

  print, "recnum=", recnum
  cdfs   = replicate(cdf[0], rec_read)
   ;cdfs   = replicate(cdf[0], recNum)

  ;Insert data
  varnames = tag_names(cdf)
  for i=0, n_elements(varnames)-1 do begin
    cdf_control, cdfid, var=varnames[i], /zvar, set_padvalue=0.0d
    ;for j=0, recNum-1 do begin
    for j=0, rec_read-1 do begin
      ;Rec start from 0
      cdf_varget, cdfid, varnames[i], value, rec_start=rec_start+j
      cdfs[j].(i)[*] = value
    endfor
  endfor
  cdf_close, cdfid
  return, cdfs
end
