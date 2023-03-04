Pro forxn
yn=findgen(11)
I=findgen(11)
x=1.5
yn[0]=1.5
for n=0, 9 do begin
x=1/(1+sqrt(x))
yn[n+1]=x
endfor
print,x
;stop
print,yn
plot,I,yn, psym=2
stop
end