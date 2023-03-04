pro Plot_profiles_function,P,Ht
;-----------------
;x :signals
;y: height
; x = findgen(200)*!pi/180.0 ; as angles
;  y=findgen(100)

;Total_X=total(P,1);

Sz=size(P)
xrange=Sz[1]
;cmax=max(Total(P,1))
read,ymin,prompt='Minimum Y: '
read,Ymax,prompt='Max Y: '
plot,Total(P,1)/cmax,Ht,yrange=[ymin,ymax],color=2,background=-2,title=title
Data_range=Sz[2]
for i=0,xrange-1 do begin
oplot,P[i,*]/cmax,Ht
endfor
return
end




