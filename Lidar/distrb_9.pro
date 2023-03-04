Pro Distrb_9
AVE=fltarr(100)
sd=fltarr(100)
seed=1001L
sum=0
for n=0,50 do begin
for i=0,99 do begin
x=randomn(seed)
print,x
sum=sum+x
seed=10*x*randomu(seed)
endfor
sd[n]=seed
AVE[n]=sum/100
print,'Average= ',sum/100
endfor;N
stop
end