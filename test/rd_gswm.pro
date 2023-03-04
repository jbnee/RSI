pro rd_gswm, gfile, lat, z, ua, up, va, vp, wa, wp, ta, tp
if (n_params() lt 11) then begin
print,'usage: rd_gswm, gfile, lat, z, ua, up, va, vp, wa, wp, ta, tp'
return
endif
ny = 59
nz = 31
s=''
openr, lun1, gfile, /get_lun
for i=0,3 do begin
readf, lun1, s
print, s
endfor
fstr1 = '(13x,f7.3)'
fstr2 = '(5x,f5.1,5x,e8.3,1x,f5.1,4x,e8.3,1x,f5.1,4x,e8.3,1x,f5.1, 4x,e8.3,1x,f5.1)'
z = fltarr(nz)
lat = fltarr(ny)
ua = fltarr(ny, nz)
up = fltarr(ny, nz)
va = fltarr(ny, nz)
vp = fltarr(ny, nz)
wa = fltarr(ny, nz)
wp = fltarr(ny, nz)
ta = fltarr(ny, nz)
tp = fltarr(ny, nz)
z1 = 0.0
dummy = fltarr(9)
for j=0,nz-1 do begin
readf, lun1, z1, form = fstr1
z(j) = z1
for i=0,ny-1 do begin
readf, lun1, dummy, form = fstr2
lat(i) = dummy(0)
ua(i,j) = dummy(1)
up(i,j) = dummy(2)
va(i,j) = dummy(3)
vp(i,j) = dummy(4)
wa(i,j) = dummy(5)
wp(i,j) = dummy(6)
ta(i,j) = dummy(7)
tp(i,j) = dummy(8)
endfor
endfor
close, lun1
free_lun, lun1
return
end