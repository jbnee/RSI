PRO Fig_1_Ground_based_DR

Start_time=systime()
fig_fn='C:\lidar\Figures\'
file1=fig_fn+'Fig_1_Ground_based_DR.eps'
file2=fig_fn+'Fig_1_Ground_based_int.eps'
file3=fig_fn+'Fig_1_Ground_based_wvp.eps'

;Read N2 RAMAN DATA
 fn='d:\lidar\DATA\NCU Raman\N2\'  ;;;
 readlidardata_Raman,fn,day,starttime_N2,ch_N2

;Read H20 RAMAN DATA
 fn='d:\Ddisk\My paper\2012dust\DATA\NCU Raman\H2O\' ;;;;
 readlidardata_Raman,fn,day,starttime_H2O,ch_H2O

;Retrieve water vapor mixing ratio
 siz_N2=size(ch_N2)
 N2_new=fltarr(siz_N2(2))
 FOR jj=0,siz_N2(2)-1. DO BEGIN
  N2_new(jj)=MEAN(ch_N2(*,jj))
 ENDFOR

 siz_H2O=size(ch_H2O)
 wvp=fltarr(siz_H2O(1),siz_H2O(2))
 FOR ii=0,siz_H2O(1)-1. DO BEGIN
  wvp(ii,*)=6*60.*ch_H2O(ii,*)/N2_new
;  plot,wvp(ii,*),xr=[0,500],yr=[0,5]
 ENDFOR
 time_ram=starttime_H2O+findgen(siz_H2O(1))/60.
 Height_ram=findgen(siz_H2O(2))*.024

;Get ground-based lidar data
 readlidardata_mie,fn,day,starttime,ch_d,ch_m,DR,int532
 siz=size(DR)
 time=starttime+findgen(siz(1))/60.

;Average in height
 hgt_max=6000  ;m
 intvr=4.
 int_new=fltarr(siz(1),hgt_max/intvr/7.5)
 DR_new=fltarr(siz(1),hgt_max/intvr/7.5)
 FOR tt=0,siz(1)-1. DO BEGIN
  FOR hh=0,hgt_max/intvr/7.5-1. DO BEGIN
   int_new(tt,hh)=MEAN(int532(tt,(intvr*hh):(intvr*hh+intvr-1.)))*(hh*intvr*.0075)^2.
   DR_new(tt,hh)=MEAN(DR(tt,(intvr*hh):(intvr*hh+intvr-1.)))
  ENDFOR
 ENDFOR
 Height=findgen(hgt_max/intvr/7.5)*.0075*intvr
 ;Smooth
 FOR hh=0,hgt_max/intvr/7.5-1. DO BEGIN
  DR_new(*,hh)=SMOOTH(DR_new(*,hh),3)
 ENDFOR


xsize=20000 & ysize=13500 & xspacing=3000 & yspacing=950 & charsize=200. & tcharsize=250.
xoffset=1500 & yoffset=1300

 xmin=min(time_ram) & xmax=max(time_ram) & ymin=1. & ymax=5. & xticks=3
 xvals=indgen(xticks+1)*(FLOOR(xmax)-CEIL(xmin))/xticks+CEIL(xmin)
 xlabels=['21:00','22:00','23:00','24:00']

PSopen,FILE=file3,/EPS,TCHARSIZE=tcharsize,CHARSIZE=charsize,XPLOTS=1,YPLOTS=1,XSPACING=xspacing,$
YSPACING=yspacing,XOFFSET=xoffset,YOFFSET=yoffset,YSIZE=ysize,XSIZE=xsize,FONT=2

  CS, IDL=33,NCOLS=100.
  LEVS, MIN=0, MAX=6,/EXACT,STEP=0.06,NDECS=2
  GSET, XMIN=xmin, XMAX=xmax, YMIN=ymin, YMAX=ymax
  CONT, FIELD=wvp, X=time_ram, Y=Height_ram,/NOAXES,/NOLINES,/CB_RIGHT,CB_NVALS=5,$
    CB_WIDTH=200;,/CB_NOLINES
  AXES, YSTEP=1, YMINOR=0.5,XVALS=xvals,XLABELS=xlabels,NDECS=2,/NOUPPER,$
    xtitle='Time (LST)',ytitle='Altitude (km)'
  AXES, XSTEP=xmax-xmin, NDECS=1,XVALS=[xmin,xmax],XLABELS=['',''],/ONLYUPPER
  GPLOT,X=xmax+(xmax-xmin)/4., Y=ymin+(ymax-ymin)/2., TEXT='Water vapor mixing ratio (g/kg)',$
    FONT=2,VALIGN=0.5, CHARSIZE=100, ORIENTATION=90.
;  COLBAR, COORDS=[cb_x0,cb_y0,cb_x0+cb_width,cb_y0+ysize],/TEXTPOS

 PSCLOSE,/NOVIEW
stop
 xmin=min(time) & xmax=max(time) & ymin=1. & ymax=5. & xticks=5
 xvals=indgen(xticks+1)*(FLOOR(xmax)-CEIL(xmin))/xticks+CEIL(xmin)
 xlabels=['21:00','22:00','23:00','24:00','01:00','02:00']

PSopen,FILE=file2,/EPS,TCHARSIZE=tcharsize,CHARSIZE=charsize,XPLOTS=1,YPLOTS=1,XSPACING=xspacing,$
YSPACING=yspacing,XOFFSET=xoffset,YOFFSET=yoffset,YSIZE=ysize,XSIZE=xsize,FONT=2
  index=where(int_new ge 8.0)
  int_new(index)=7.99
  CS, IDL=33,NCOLS=100.
  LEVS, MIN=0, MAX=8,/EXACT,STEP=0.08,NDECS=2
  GSET, XMIN=xmin, XMAX=xmax, YMIN=ymin, YMAX=ymax
  CONT, FIELD=int_new, X=time, Y=Height,/NOAXES,/NOLINES,/CB_RIGHT,CB_NVALS=5,$
    CB_WIDTH=200;,/CB_NOLINES
  AXES, YSTEP=1, YMINOR=0.5,XVALS=xvals,XLABELS=xlabels,NDECS=2,/NOUPPER,$
    xtitle='Time (LST)',ytitle='Altitude (km)'
  AXES, XSTEP=xmax-xmin, NDECS=1,XVALS=[xmin,xmax],XLABELS=['',''],/ONLYUPPER
  GPLOT,X=xmax+(xmax-xmin)/4., Y=ymin+(ymax-ymin)/2., TEXT='Lidar backscatter signal (532nm)',$
    FONT=2,VALIGN=0.5, CHARSIZE=100, ORIENTATION=90.
;  COLBAR, COORDS=[cb_x0,cb_y0,cb_x0+cb_width,cb_y0+ysize],/TEXTPOS

 PSCLOSE,/NOVIEW


PSopen,FILE=file1,/EPS,TCHARSIZE=tcharsize,CHARSIZE=charsize,XPLOTS=1,YPLOTS=1,XSPACING=xspacing,$
YSPACING=yspacing,XOFFSET=xoffset,YOFFSET=yoffset,YSIZE=ysize,XSIZE=xsize,FONT=2


  CS, IDL=33,NCOLS=25.
  LEVS, MIN=0, MAX=0.25,/EXACT,STEP=.01,NDECS=2
  GSET, XMIN=xmin, XMAX=xmax, YMIN=ymin, YMAX=ymax
  CONT, FIELD=DR_new, X=time, Y=Height,/NOAXES,/NOLINES,/CB_RIGHT,CB_NVALS=6,$
    CB_WIDTH=200;,/CB_NOLINES
  AXES, YSTEP=1, YMINOR=0.5,XVALS=xvals,XLABELS=xlabels,NDECS=2,/NOUPPER,$
    xtitle='Time (LST)',ytitle='Altitude (km)'
  AXES, XSTEP=xmax-xmin, NDECS=1,XVALS=[xmin,xmax],XLABELS=['',''],/ONLYUPPER
  GPLOT,X=xmax+(xmax-xmin)/4., Y=ymin+(ymax-ymin)/2., TEXT='Depolarization ratio (532nm)',$
    FONT=2,VALIGN=0.5, CHARSIZE=100, ORIENTATION=90.
;  COLBAR, COORDS=[cb_x0,cb_y0,cb_x0+cb_width,cb_y0+ysize],/TEXTPOS

 PSCLOSE,/NOVIEW

   End_time=systime()
   print,'Start_time:',Start_time
   print,'End_time:',End_time
END
