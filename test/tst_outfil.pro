pro tst_outfil
close,/all
x=fltarr(30)
openw,2,'d:\rsi\test\tst_out.txt'
for i=0,20 do begin
x[i]=8.0*i
printf,2,i,x(i)
endfor
close,2
end