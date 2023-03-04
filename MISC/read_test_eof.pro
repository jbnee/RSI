Pro read_test_EOF
; EOF test
close,1
O3path='f:\RSI\test\'; 'd:\Ozone data\';  CWB_O3\2000\'
fname='O300110711.txt'; 'O300110711.txt'
OPENR, 1, O3path+fname; 'd:\Ozone data\CWB_O3\2000\00110711.51E'

; Define a string variable:

A = ''
B=fltarr(7,1000)
; Loop until EOF is found:
on_ioerror, jp
WHILE ~ EOF(1) DO BEGIN
   ; Read a line of text:
   READF, 1, A
   ; Print the line:
   PRINT, A
   READf,1,A
   print,A
   readf,1,B
    ;print,B

  ENDWHILE
; Close the file:
O3=B[0:n-1,*]
jp: CLOSE, 1
rs=where(B[6,*] eq 0)
row1=min(rs)
BB=B[*,0:row1-1]
stop
ht=BB[1,*]
T=BB[3,*]
Oz=BB[6,*]
plot,Oz,ht
stop
plot,T,ht
end