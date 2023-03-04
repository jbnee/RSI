pro file_srch
x=strarr(1000)
b = FILE_SEARCH('f:\\lidar_data\\2002\\no\\\no*')
for i=300,500 do begin
 x[i]=strmid(b[i],23,8)
i=i+1
x[i]=strmid(b[i],23,8)
;print,x[i]
while (x[i+1] eq x[i]) do begin
;print,i,x[i]
;i=i+1
endwhile
endfor
print,i,'  x=  ',x[i-1]

stop
end