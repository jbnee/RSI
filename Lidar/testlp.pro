pro testlp
;m=[2,4,6]
n=0
x=fltarr(12)
for i= 0,10 do begin
if (i eq 2) or (i eq 4)or (i eq 6) then begin
i=i+1

;x(n)=i
;n=n+1

endif
print,i
x[n]=i
n=n+1
endfor
print,x
stop
end
