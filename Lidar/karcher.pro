Pro Karcher
so=[0.01,0.1, 0.6, 1]  ; super saturation
tg1=[21.5, 9.1, 4.8 ,1];lidar

;;;;;;;;;;;;;;;;;;
tg2=[2, 1. ,0.5  ,0.3 ]in situ Melinger 1999

plot,so^(0.333),tg1,psym=1,xrange=[0,1.2],xtitle='supersaturation^1/3',ytitle='tg'
oplot,so^(0.333),tg2,psym=2
stop
k1=tg1/so^(0.333)
k2=tg2/so^(0.333)
print,k1,k2
stop
end
