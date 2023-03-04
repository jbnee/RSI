Pro add_data
dat2=fltarr(2,100)

x=findgen(100)*0.05+135.0
dat2[0,*]=x
for i=0,69 do begin
print,dat2[0,i]
READ, y, PROMPT='Enter value: '

dat2[1,i]=y
print,i,dat2[0,i],y
endfor
stop
end
