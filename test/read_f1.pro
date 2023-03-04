pro read_f1
; Open the file test.lis:
close,/all
OPENR, 1, 'd:\rsi\test\sunspot.txt'
; Define a string variable:

B=fltarr(2,288)
A=fltarr(2,1)
;A = ''
; Loop until EOF is found:
i=0
WHILE ~ EOF(1) DO BEGIN
   ; Read a line of text:
   READF, 1, A
   ; Print the line:
   B[0,i]=A[0,0]
   B[1,i]=A[1,0]
   ;PRINT,A
   yr=B[0,*]*1000.
   spot=B[1,*]
   i=i+1
ENDWHILE
plot,yr,spot
stop
; Close the file:

CLOSE, 1



;stop
end