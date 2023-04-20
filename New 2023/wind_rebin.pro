Pro Wind_rebin
;revise 2023/4/20
close,/all
file1='E:\RSI\New 2023\Uwind_500.txt';
file2='E:\RSI\New 2023\Vwind_500.txt'
openr,1,file1
U=fltarr(9,9)
readf,1,U
V=fltarr(9,9)
openr,2,file2
READf,2,V
close,/all

;;**** define latitude longitude ****************
x0=fltarr(9)
y0=fltarr(9)
for i=0,8 do begin
x0[i]=110+2.5*i
endfor

for j=0,4 do begin
y0[j]=25+2.5*j
endfor

;;;;::::***expand to 40 array *******;;;;;
x1=fltarr(21)
y1=fltarr(21)

for i1=0,20 do begin
x1[i1]=110+1.0*i1
endfor

;;;;;;;;expand y to 20 ***********
for j1=0,20 do begin
y1[j1]=25-1.0*j1
endfor


stop





print,U
stop
RU=rebin(u,18,18);
RV=rebin(V,18,18);

print,RU
print,RV
stop
openw,1,'E:\RSI\new 2023\RU500.txt'
printf,1,RU
openw,2,'E:\RSI\new 2023\RV500.txt'
printf,2,RV

close,/all
stop

end
