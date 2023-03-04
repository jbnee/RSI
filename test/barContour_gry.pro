;=======================================================================
; Draw color contour with a colorbar on the right side
; by He Yujin, 2004
;=======================================================================
pro barContour_gry, z, x, y, levels=levels, nlevels=nlevels, Position=Position, CTLevel=CTLevel, CTBottom=CTBottom, $
    barTitle=barTitle, barOffset=barOffset, barlevels=barlevels, barnlevels=barnlevels, $
    line=line, barTickFormat=barTickFormat, reverseColor=reverseColor, _extra=_extra

  compile_opt strictarr

  on_error, 2

  if( !d.name EQ 'WIN' ) then begin
    device,get_decomposed=old_decomposed
    device,decomposed=0
  endif

  if(not keyword_set(z)) then message, 'Incorrect number of arguments',/traceback
  zsize = size (z)
  if (zsize[0] ne 2) then message, 'Array must have 2 dimensions',/traceback

  ind=where( finite(z),complement=badInd,ncomplement=nBad )
  zmin=min(z[ind]) & zmax=max(z[ind])
  if(nBad GT 0) then begin
    zbad=zmin-(zmax-zmin)
    z[badInd]=zbad
  endif
  zmax=max(abs(z[ind]))

  if not keyword_set(x) then x = lindgen(zsize[1])
  if not keyword_set(y) then y = lindgen(zsize[2])

  if not keyword_set(Position) then Position=[0.12, 0.15, 0.8, 0.9]
  if not keyword_set(barOffset) then barOffset=[0.1,0.18]

  if not keyword_set(levels) then begin
    if not keyword_set(nlevels) then nlevels=31 else nlevels=nlevels<254
    levels = -zmax + dindgen(nlevels) * 2.*zmax/(nlevels-1)
  endif else nlevels=n_elements(levels)

  if not keyword_set(barlevels) then begin
    if not keyword_set(barnlevels) then barnlevels=nlevels else barnlevels=barnlevels<254
    barlevels = -zmax + dindgen(barnlevels) * 2.*zmax/(barnlevels-1)
;    barlevels = zmin + dindgen(barnlevels) * (zmax-zmin)/(barnlevels-1)
  endif else barnlevels=n_elements(barlevels)

  if not keyword_set(barTickFormat) then barTickFormat='(F4.1)'

  if n_elements(CTLevel ) NE 1 then CTLevel=33
  if n_elements(CTBottom) NE 1 then CTBottom=1

  loadct,0,/silent ; load black and white color for axis
;  loadct,CTLevel,bottom=CTBottom,ncolors=nlevels-1,/silent
  loadct,CTLevel

  mx_color_reso=180
  colors=38+indgen(nlevels)*mx_color_reso/(nlevels-1)
  colors[nlevels/2]=255

  if(nBad GT 0) then begin
    levels=[zbad,levels]
    colors=[0,colors]
  endif



  if keyword_set(reverseColor) then colors=nlevels-colors

  contour,z,x,y,color=0,levels=levels,/fill,_extra=_extra,$
          xstyle=1,xthick=2,ythick=2,ystyle=1,c_colors=colors,Position=Position
;  if keyword_set(line) then $
;     contour,z,x,y,levels=levels,c_thick=replicate(0.1,nlevels),/overplot

  loadct,CTLevel,bottom=CTBottom,ncolors=barnlevels-1,/silent
  colors=1+indgen(barnlevels)
  if keyword_set(reverseColor) then colors=barnlevels-colors
  contour,transpose([[barlevels],[barlevels]]),[0,1],barlevels,/fill,/noerase, $
          levels=barlevels,c_colors=colors,color=0,title=barTitle, $
          xstyle=4,ystyle=1,ytickformat=barTickFormat,yTitle='', $
          yticks=2,yminor=1,$
          Position=[Position[2]+barOffset[0],Position[1],Position[2]+barOffset[1],Position[3]];,charsize=0.6
  loadct,0,/silent
  if( !d.name EQ 'WIN' ) then device,decomposed=old_decomposed
end