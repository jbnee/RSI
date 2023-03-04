Pro RydbergATM
close,/all
IE=5.139 ;eV
Rydb=13.6   ; eV

wv=fltarr(60)
qd=fltarr(60)
openr,1, "d:\RSI\temp\Na_I.txt"
readf,1,wv
For n=0,59 do begin
xe=12400/wv(n)
qdf=IE-Rydb/xe
print,wv(n),qdf
qd(n)=qdf
endfor
stop
close,/all
end
