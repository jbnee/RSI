pro contour_plot
fig_fn='H:\taiwan\picture\'
file1=fig_fn+'ja032325_licle_MD_V1.eps'
 fn='H:\131105\ja Licel\ja032325*' 
readlidardata_mie,fn,day,starttime,ch_d,ch_m,DR,int532

 siz_m=size(ch_m)
 time_ram=findgen(siz_m(1))
 Height_ram=(findgen(siz_m(2))+1)*.0075
 PRINT,max(ch_m),min(ch_m)
 help,ch_m,time_ram

 siz_d=size(ch_d)
 time_ram1=findgen(siz_d(1))
 Height_ram1=(findgen(siz_d(2))+1)*.0075
 PRINT,max(ch_d),min(ch_d)
 help,ch_d,time_ram1
 
 for i=0,siz_m(2)-1 do begin
  ch_m(*,i)=ch_m(*,i)*Height_ram(i)*Height_ram(i)
 endfor
print,max(ch_m)
 
  for i=0,siz_d(2)-1 do begin
  ch_d(*,i)=ch_d(*,i)*Height_ram(i)*Height_ram(i)
 endfor
print,max(ch_d)
 
; set_plot,'win'
;plot,ch_d(10,0:800)
;stop
;time_ram=time_ram(0:55)
;time_ram1=time_ram1(0:55)
xsize=20000 & ysize=13500 & xspacing=3000 & yspacing=950 & charsize=200. & tcharsize=250.
xoffset=1500 & yoffset=1300
xmin=min(time_ram) & xmax=max(time_ram) & ymin=4. & ymax=6. & xticks=3
print,xmin,xmax
PSopen,FILE=file1,/EPS,TCHARSIZE=tcharsize,CHARSIZE=charsize,XPLOTS=1,YPLOTS=2;,XSPACING=xspacing;,$
;YSPACING=yspacing,XOFFSET=xoffset,YOFFSET=yoffset,YSIZE=ysize,XSIZE=xsize,FONT=2
  CS, SCALE=27
  LEVS, MIN=0, MAX=600,STEP=50
  GSET, XMIN=xmin, XMAX=xmax, YMIN=ymin, YMAX=ymax
  CONT, FIELD=ch_m(*,0:800),X=time_ram,Y=Height_ram(0:800),/NOAXES,/NOLINES,/CB_RIGHT,CB_NVALS=5,$
    CB_WIDTH=200,TITLE='ja032325M';,/CB_NOLINES
    AXES, XVALS=[1,8,15], $
XLABELS=['1','8','15'], $
YVALS=[4,5,6], $
YLABELS=['4', $
'5','6']
   POS,XPOS=1,YPOS=2
   GSET, XMIN=xmin, XMAX=xmax, YMIN=ymin, YMAX=ymax
  CONT, FIELD=ch_d(*,0:800),X=time_ram1,Y=Height_ram(0:800),/NOAXES,/NOLINES,/CB_RIGHT,CB_NVALS=5,$
    CB_WIDTH=200,TITLE='ja032325D';,/CB_NOLINES
    AXES, XVALS=[1,8,15], $
XLABELS=['1','8','15'], $
YVALS=[4,5,6], $
YLABELS=['4', $
'5','6']
 PSCLOSE,/NOVIEW

;======================================================
;fig_fn='H:\taiwan\picture\'
;file1=fig_fn+'MR312023_MD_V1.eps'
; fn1='H:\taiwan\2002\mr31\MR312023*D' 
; fn2='H:\taiwan\2002\mr31\MR312023*M' 
;;fig_fn='H:\taiwan\'
;;file1=fig_fn+'vapor_M_V1.eps'
;; fn='H:\131105\2009MCA H2O\mr\MR142056*M' 
;readlidardata_Raman,fn1,day1,starttime1,ch_D
;readlidardata_Raman,fn2,day1,starttime1,ch_M
;
; siz_D=size(ch_D)
; time_ram=findgen(siz_D(1))
; time_ram1=findgen(siz_D(1))
; Height_ram=(findgen(siz_D(2))+1)*.024
; PRINT,max(ch_D),min(ch_D)
; help,ch_D,time_ram
;
; for i=0,siz_D(2)-1 do begin
;  ch_D(*,i)=ch_D(*,i)*Height_ram(i)*Height_ram(i)
; endfor
; print,max(ch_D(*,0:800))
;
; siz_M=size(ch_M)
; time_ram=findgen(siz_M(1))
; Height_ram=(findgen(siz_M(2))+1)*.024
; PRINT,max(ch_M),min(ch_M)
; help,ch_M,time_ram
;
; for i=0,siz_M(2)-1 do begin
;  ch_M(*,i)=ch_M(*,i)*Height_ram(i)*Height_ram(i)
; endfor
; print,max(ch_M(*,0:800))
;
;;time_ram=time_ram(0:49)
;;time_ram1=time_ram1(0:49)
;xsize=20000 & ysize=13500 & xspacing=3000 & yspacing=950 & charsize=200. & tcharsize=250.
;xoffset=1500 & yoffset=1300
;xmin=min(time_ram) & xmax=max(time_ram) & ymin=0. & ymax=3. & xticks=3
;print,xmin,xmax
;PSopen,FILE=file1,/EPS,TCHARSIZE=tcharsize,CHARSIZE=charsize,XPLOTS=1,YPLOTS=2;,XSPACING=xspacing;,$
;;YSPACING=yspacing,XOFFSET=xoffset,YOFFSET=yoffset,YSIZE=ysize,XSIZE=xsize,FONT=2
;  CS, SCALE=27
;  LEVS, MIN=0, MAX=1400,STEP=100
;  GSET, XMIN=xmin, XMAX=xmax, YMIN=ymin, YMAX=ymax
;  CONT, FIELD=ch_M(*,0:800),X=time_ram,Y=Height_ram(0:800),/NOAXES,/NOLINES,/CB_RIGHT,CB_NVALS=5,$
;    CB_WIDTH=200,TITLE='MR312023M';,/CB_NOLINES
;    AXES, XVALS=[1,100,200,300,385], $
;XLABELS=['1','100', '200','300','385'], $
;YVALS=[0,1,2,3], $;,3,4,5
;YLABELS=['0','1','2','3'];,'4', $
;;'5']
;   POS,XPOS=1,YPOS=2
;   GSET, XMIN=xmin, XMAX=xmax, YMIN=ymin, YMAX=ymax
;  CONT, FIELD=ch_D(*,0:800),X=time_ram1,Y=Height_ram(0:800),/NOAXES,/NOLINES,/CB_RIGHT,CB_NVALS=5,$
;    CB_WIDTH=200,TITLE='MR312023D';,/CB_NOLINES
;    AXES, XVALS=[1,100,200,300,385], $
;XLABELS=['1','100', '200','300','385'], $
;YVALS=[0,1,2,3], $;,3,4,5
;YLABELS=['0','1','2','3'];,'4', $
;;'5']
; PSCLOSE,/NOVIEW

end