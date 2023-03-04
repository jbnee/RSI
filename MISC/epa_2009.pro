pro EPA_2009; file test.lis:
close,/all
OPENR, 1, 'F:\EPA data\2009Ap24ChungliPM10_O3.txt
 B=fltarr(2,100)
 O3=fltarr(100)
 PM10=fltarr(100)
  line=''
 A=fltarr(2)
 READF,1,LINE
; Loop until EOF is found:
i=0
;ON_IOERROR,ers
WHILE ~EOF(1) DO BEGIN

   readf,1,line

   ;B=float(A)
   O3[i]=A[0,*]
   PM10[i]=A[1,*]

   i=i+1
ENDWHILE
;ers: close, 1
hr=findgen(100)
plot,hr,O3
stop
plot,hr,PM10

; Close the file:

CLOSE, 1
stop
end



;stop
