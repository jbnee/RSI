Pro pressure_ht
;relationship of hPa in meters of heights up to 10 km
ht=indgen(100)*100.0; ht in meters 0:10000m
hpa=1015.60-0.109*ht+3.67e-6*ht^2
plot,ht,hpa,color=2,background=-2,xtitle='height meter',ytitle='hPa'
stop
end