Pro O1s
ko=fltarr(4)
ko2=fltarr(4)
kn2=fltarr(4)
ko[0]=9.0E-12
Ko[1]=1.3E-11
ko[2]=5.9E-12
ko[3]=5.0E-10
ko2[0]=2.9E-13
ko2[1]=1.3E-13
ko2[2]=3.0E-14
ko2[3]=3.0E-11
kN2[0]=9.3E-15
kN2[1]=9.3E-15
kN2[2]=9.3E-15
kN2[3]=3.0E-11
R=4.0
For i=0,3 do begin
R_COCO2=(ko(i)/ko2(i))/(1+R*kn2(i)/ko2(i))
print,i,R_COCO2
endfor
stop
end