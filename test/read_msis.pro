pro read_msis  ;line by line reading
; Open the file test.lis:
close,/all
OPENR, 1, 'd:\misc\msisDATA.txt'
; Define a string variable:

B=fltarr(5,50)
A=fltarr(5,1)
X = ''
; Loop until EOF is found:
i=0
readf,1,x  ;read a line of text
WHILE ~ EOF(1) DO BEGIN
   ; Read a line of text:
   READF, 1, A
   ; Print the line:
  print,A

 For k=0,4 do begin
    B[k,i]=A[k,0]
  Endfor;;;;k
  ;B[0,i]=A[0,0]
  ;B[1,i]=A[1,0]
  ;B[2,i]=A[2,0]
  ;B[3,i]=A[3,0]
  ;B[4,i]=A[4,0]
   i=i+1
ENDWHILE
  HT=B[0,*]
  O=B[1,*]
  N2=B[2,*]
  O2=B[3,*]
  T=B[4,*]

plot,O,Ht,psym=0
oplot,T,HT
stop
; Close the file:

CLOSE, 1


;stop
end