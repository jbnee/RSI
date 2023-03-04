PRO monsooncirrus
filename='d:\RSI\cirrus\ASM monthly 10_20KM.txt'

line=''
openr,1,filename
readf,1,line
readf,1,line
H=FLTARR(4,1000) ;A big array to hold the data
S=FLTARR(4) ;A small array to read a line
ON_IOERROR,ers ;Jump to statement ers when I/O error is detected
n=0 ; Create a counter
WHILE n LT 1000 DO BEGIN
READF,1,S ;Read a line of data
PRINT,S ;Print the line
H[*,n]=S ;Store it in H
n=n+1 ;Increment the counter
ENDWHILE ;End of while loop
ers: CLOSE,1 ;Jump to this statement when an end of file is detected
H=H[*,0:n-1]
END
stop
sum=0
  ;For jcol=0,col-1  do begin
   ;For irow=0,row-1 do begin
    ;H[jCOL,irow]=Rdata[jcol,irow]
    ; if (H[4,irow] eq 1) then sum=sum+H[4,irow]
     ;if (H[jcol,irow] EQ 999) then H[jcol,irow]=A[jcol,irow-1]
   ;endfor   ;irow
  ; endfor   ;jcol



stop
end