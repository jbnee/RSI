pro sunspot ;and Lomb_scarle periodogram
; Open the file test.lis:
close,/all
OPENR, 1, 'd:\rsi\test\sunspot.txt'
; Define a string variable:
x=''
B=fltarr(2,288)
A=fltarr(2,1)
;A = ''
; Loop until EOF is found:
i=0
readf,1,x  ;read a line of text
WHILE ~ EOF(1) DO BEGIN  ;read data
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
x=transpose(yr)
y=transpose(spot)
lomb_Sg= LNP_TEST(x, y, WK1 = freq, WK2 = amp, JMAX = jmax)
CLOSE, 1
plot,freq,amp ; periodogram in frequency
T=1/freq  ; change to Period
plot,T,amp,xrange=[0,20];xrange=[0,200]; plot in T

print,JMAX, T(Jmax)  ; index of Peak period
stop
end



;stop
