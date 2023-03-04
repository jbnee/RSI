PRO Polar_calibration3x
;H, filename,COLUMNS=cols,ROWS=rows
;filename='d:\rsi\cirrus\ASM_10_20km.txt'  ;35data.txt'
path1='f:\lidar_data\2015\AU_Nov\raw\3_channel\'
datanm=['Pol_0924_3.txt','Pol_1013_3.txt','Pol_1015_3.txt','Pol_1106_3.txt','Pol_1127_3.txt','Pol_1130_3.txt']
cols=3
rows=2000
H=fltarr(cols,rows)
close,/all
m=5
 filename=path1+datanm[m]
  headx=''
  openr,1,filename
  READF,1,headx
IF N_ELEMENTS(cols) LE 0 THEN cols=1 ;Default value for cols
IF N_ELEMENTS(rows) LE 0 THEN rows=2000    ;Default value for rows
H=FLTARR(cols,rows) ;A big array to hold the data
S=FLTARR(cols)      ;A small array to read a line

ON_IOERROR,ers     ;Jump to statement ers when I/O error is detected
n=0 ; Create a counter
WHILE n LT rows DO BEGIN

    READF,1,S    ;Read a line of data
    H[*,n]=S     ;Store it in H
    n=n+1        ;Increment the counter
ENDWHILE          ;End of while loop
ers: CLOSE,1         ;Jump to this statement when an end of file is detected
H=H[*,0:n-1]
;stop
;D=fltarr(3,n)
A=fltarr(3,n)
;X=fltarr(n-1)

A[0,*]=H[1,*]/H[0,*];   ratio perpendicular/parallel
A[1,*]=H[2,*]/H[0,*]
A[2,*]=H[2,*]/H[1,*]
Ht=findgen(n)*7.5
;stop
;endfor
 !P.MULTI = [0,3,1]
   plot_position1 = [0.1,0.1,0.35,0.95];
   plot_position2 = [0.4,0.1,0.65,0.95];
   plot_position3 = [0.7,0.1,0.98,0.95];
plot,A[0,*],Ht/1000,background=-2,color=1,xrange=[0,0.2],position=plot_position1,title='perpen/parall',charsize='1.5'
 xyouts,.1,6,datanm[m],color=2
plot,A[1,*],Ht/1000,background=-2,color=1,position=plot_position2,title='total/parall',charsize='1.5'
plot,A[2,*],Ht/1000,background=-2,color=1,position=plot_position3, title='total/perpen', charsize='1.5'
stop
;openw,2,'f:\rsi\temp\Tav_ja16.txt'
;printf,2,meanH
;close,2
;stop
END