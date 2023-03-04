PRO Cirrus_DATAx, H, filename,COLUMNS=cols,ROWS=rows
filename='d:\rsi\cirrus\cirrus_Lat_Season.txt'  ;35data.txt'
;filename='d:\rsi\test\Lidar_T2001ja16.txt'
OPENR,1,filename
cols=9
rows=12
IF N_ELEMENTS(cols) LE 0 THEN cols=1 ;Default value for cols
IF N_ELEMENTS(rows) LE 0 THEN rows=1000    ;Default value for rows
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
MeanH=fltarr(8,3)

stop
for n=0,7 do begin
;x[n]=H[1:9,n]
MeanH[n,0]=mean(H[n+1,0:2])
MeanH[n,1]=mean(H[n+1,3:8])
MeanH[n,2]=mean(H[n+1,9:11])
endfor
season=intarr(4)
bar_plot,MeanH(0,*),background=-2,color=3
stop
;openw,2,'d:\rsi\temp\Tav_ja16.txt'
;printf,2,meanH
;close,2
;stop
END