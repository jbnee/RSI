Pro cirrus_Asymmetric
close,/all
bpath='f:\RSI\lidar\data_list\se30.txt'
se30cirrus=fltarr(2,160)
openr,1,bpath
readf,1, se30cirrus
close,1
ht=se30cirrus[0,*]
Ix=se30cirrus[1,*]
print,ht,ix
plot,ix,ht,color=2,background=-2,yrange=[9,11]
stop
g=fltarr(160)
for n=1,158 do begin
;Ix[n]=Ix[n-1]*(g-1)/2+Ix[n+1]*(g+1)/2
;Ix[n]=(g/2)(Ix[n+1]+Ix[n-1])
g[n]=(2*Ix[n]-(Ix[n+1]-Ix[n-1]))/(Ix[n+1]+Ix[n-1])
endfor
stop
plot,smooth(g,10),color=2,background=-2
oplot,Ix/max(Ix),color=44

stop
end