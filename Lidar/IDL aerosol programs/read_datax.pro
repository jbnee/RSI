PRO READ_DATAx, H, filename,COLUMNS=cols,ROWS=rows
;filename='d:\rsi\cirrus\ASM_10_20km.txt'  ;35data.txt'
filename='d:\rsi\test\Lidar_T2001ja16.txt'
OPENR,1,filename
cols=10
rows=915
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
stop
MeanH=fltarr(2,rows)
MeanH[0,*]=H[0,*]
X=fltarr(ROWS)
for n=0,914 do begin
;x[n]=H[1:9,n]
MeanH[1,n]=mean(H[1:9,n])
endfor
Ht=H[9,*]
Tempr=meanH[1,*]
plot,Tempr,Ht,background=-2,color=1
openw,2,'d:\rsi\temp\Tav_ja16.txt'
printf,2,meanH
close,2
stop
END