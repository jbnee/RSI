PRO READ_file_x; read unknow number of elements; H, filename,COLUMNS=cols,ROWS=rows
;fpath='d:\rsi\cirrus\';   ;35data.txt'
;data1='ASM_10_20km.txt'
fname='F:\rsi\test\Radioson2000_120612.txt'
;read,data1,prompt=' where is data? AS d:\rsi\test\Lidar_T2001ja16.txt'
;fname=fpath+data1
OPENR,1,fname
line=''
cols=9
rows=1000
readf,1,line
IF N_ELEMENTS(cols) LE 0 THEN cols=1 ;Default value for cols
IF N_ELEMENTS(rows) LE 0 THEN rows=1000    ;Default value for rows
H=FLTARR(cols,rows) ;A big array to hold the data
S=FLTARR(cols)      ;A small array to read a line

ON_IOERROR,ers     ;Jump to statement ers when I/O error is detected
n=0 ; Create a counter
Mnth=''
WHILE n LT rows DO BEGIN
    READF,1,S    ;Read a line of data
    H[*,n]=S     ;Store it in H

    n=n+1        ;Increment the counter
ENDWHILE          ;End of while loop
ers: CLOSE,1         ;Jump to this statement when an end of file is detected
H=H[*,0:n-1]
mnths=strcompress(H[0,*])
mn=strmid(mnths,5,2)
stop
sumwinter=fltarr(1,6)
sumspring=fltarr(1,6)
sumsummer=fltarr(1,6)
sumfall=fltarr(1,6)
for i=0,38,3 do begin
;;sum over winter months
if (mn[i] eq 12) or (mn[i] eq 1) or (mn[i] eq 2) then begin
  for m=1,6 do begin
  sumwinter1=H[i,m]+H[i+1,m]+H[i+2,m]+sumwinter
  endfor
endif
;sum over spring
if (mn[i] eq 3) or (mn[i] eq 4) or (mn[i] eq 5) then begin
  for m=1,6 do begin
  sumspring=H[i,m]+H[i+1,m]+H[i+2,m]
  endfor
endif
 if (mn[i] eq 6) or (mn[i] eq 7) or (mn[i] eq 8) then begin
  for m=1,6 do begin
  sumsummer=H[i,m]+H[i+1,m]+H[i+2,m]
  endfor
endif; else begin
if (mn[i] eq 9) or (mn[i] eq 10) or (mn[i] eq 11) then begin
  for m=1,6 do begin
  sumfall=H[i,m]+H[i+1,m]+H[i+2,m]
  endfor
endif
endfor
stop
;win=fltarr(2,rows)

;MeanH[0,*]=H[0,*]
;X=fltarr(ROWS)
for n=0,rows do begin
;x[n]=H[1:9,n]
;MeanH[1,n]=mean(H[1:9,n])
endfor
;Ht=H[9,*]
;Tempr=meanH[1,*]
;plot,Tempr,Ht,background=-2,color=1
;openw,2,'d:\rsi\temp\Tav_ja16.txt'
;printf,2,meanH
;close,2
stop
END