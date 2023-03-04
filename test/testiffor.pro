pro testiffor
a=3
i=0
m=0
for i=0,12 do begin
   if (a LT 5) and (i LT 6) then begin  ;#1 while  程式一直在這裡繞
     a=i+1.5

     print,i,a
     wait, .5

   endif else begin  ;#1

    a=0

   print, i, a
   wait,1
  endelse

endfor
stop
end