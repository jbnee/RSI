pro ice
n1=1  ;air
n2=1.31  ;ice
;for normal incidence
n=n2/n1
rs=(1-n)/(1+n)
rp=rs
ts=2/(1+n)
tp=ts
AR=[[-rp,0],[0,rs]]
AT=[[rp,0],[0,ts]]
x=[1,0]
BR=AR*x
BT=AT*x
print,Br,BT
stop
end