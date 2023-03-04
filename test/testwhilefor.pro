pro testwhilefor
; This program shows for and while  can not be used together
a=3
;i=0
m=0
for i=0,20 do begin


   while (a LT 8) do begin  ;#1 while  程式一直在這裡繞
     a=i+1.5
     print,i,a
     wait, .2

    ; i=i+1
   endwhile  ;#1
  b=4
  print,'b= ',b
  while (a GE 8) and (a GT 7) do begin  ; #2
   ;if (a GE 8) and (i GT 7) then begin
    a=0
   print, i, a
   wait,1
   i=i+1
   ;endif else begin
  ; if (i GE 15) then begin

   endwhile  ;#2
   ; while (i GT 15) do begin  ;#2

  ; a=999

    ;print,i,a
  ; endif
  ;endelse
  ;endwhile  ;#2
;JP1: wait, .1
endfor
stop
end