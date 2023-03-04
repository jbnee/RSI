PRO RadiosondeX; read unknow number of elements; H, filename,COLUMNS=cols,ROWS=rows
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
A=FLTARR(cols,rows)
ON_IOERROR,ers     ;Jump to statement ers when I/O error is detected
n=0 ; Create a counter

WHILE n LT rows DO BEGIN
    READF,1,S    ;Read a line of data
    H[*,n]=S     ;Store it in H

    n=n+1        ;Increment the counter
ENDWHILE          ;End of while loop
ers: CLOSE,1         ;Jump to this statement when an end of file is detected
H=H[*,0:n-1]
;mnths=strcompress(H[0,*])
;mn=strmid(mnths,5,2)
stop
A=size(H)
A1=A[1]  ;column #
A2=A[2]   ;row #
 For j=0,A1-1  do begin
   For i=0,A2-1 do begin
   ; A[j,i]=H[j,i]
     if (H[j,i] eq 999.9) then H[j,i]=H[j,i-1]
     if (H[j,i] EQ 999) then H[j,i]=H[j,i-1]
   endfor   ;i
   endfor   ;j
Ht=H[3,*]
P=H[2,*]
Temp=H[4,*]
RH=H[5,*]
WD=H[7,*]

WS=H[8,*]
plot,Temp,Ht,background=-2,color=1
;openw,2,'d:\rsi\temp\Tav_ja16.txt'
;printf,2,meanH
;close,2
stop
END