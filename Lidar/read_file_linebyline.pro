PRO READ_file_linebyline
close,/all
;filename='f:\rsi\testidl\35data.txt'
filename='F:\ozone&2017Eclipse\houston_sounding.txt'
OPENR, 1, filename
; Define a string variable:
A = ''
B=fltarr(100000); a verylarge array
n=0
; Loop until EOF is found:
WHILE ~ EOF(1) DO BEGIN
; Read a line of text:
 READF, 1, A
 B[n]=A
   ; Print the line:
PRINT,n,A
n=n+1
ENDWHILE
; Close the file:
CLOSE, 1
stop
end