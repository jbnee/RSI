Pro read_test
close,1
OPENR, 1, 'd:\radiosonde\testdata.txt'

; Define a string variable:
A = ''
B=fltarr(5,1)
; Loop until EOF is found:
on_ioerror, jp
WHILE ~ EOF(1) DO BEGIN
   ; Read a line of text:
   READF, 1, A
   ; Print the line:
   PRINT, A

  readf,1,B
  print,B
  ENDWHILE
; Close the file:

jp: CLOSE, 1
stop
end