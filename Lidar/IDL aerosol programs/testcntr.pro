pro testcntr
device,decompose=0
!p.multi=[0,1,2]
!p.background=255
loadct,39
nx=50
plot,[0,nx],[0,5];COLOR = 0
plot,[0,0],[nx,5],xrange=[0,nx],yrange=[0,5],/nodata,COLOR = 0
;oplot,[0,nx],[1.5,1.5],COLOR = 50
stop
end