pro testifwhile

a=3
i=0

while (a < 5) and (i < 10) do begin  ;#1 while  程式一直在這裡繞
a=i+1.5
i=i+1
print,i,a
wait, 1
endwhile  ;#1
while (a > 5) and (i <10) do begin  ; #2
 a=0
 i=i+1
 print, i, a
endwhile  ;#2
 while (i >10) do begin  ;#2

 ;endif
 print,i,a
 endwhile  ;#2
wait, 1



stop
end