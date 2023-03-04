pro testif2

a=3
i=0
 jp1: a=i+1.5
  i=i+1
if (a LT 5) and (i LT 10) then begin  ;#1 while  程式一直在這裡繞

print,i,a
wait, 1
goto, jp1
endif else begin  ;#1

jp2:a=0
 i=i+1
 while (i LT 10) do begin
 print,i,a
 wait,1
 goto,jp2
 endwhile
endelse
;endif ;#2
 while (i GT 10) do begin  ;#2

 ;endif
 print,i,a
 endwhile  ;#2
wait, 1



stop
end