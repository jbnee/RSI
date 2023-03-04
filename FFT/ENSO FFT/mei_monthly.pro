Pro Mei_monthly
close,/all
XMEI=fltarr(13,68)
openr,1,'E:\RSI\MISC\Mei_index.txt'
line=''
readf,1, line
print,line
readf,1,XMei
close,1
yr=XMei[0,*]
MMid=Xmei[1:12,*]
stop
;EMID=transpose(mmid)
;PRINT,SIZE(MMID)
n0=12*68
A_MEI=fltarr(n0)
;A_MEI[0:11]=MMID[0:11,0]
for y=0,67 do begin

A_Mei[y*12:y*12+11]=MMid[0:11,y]

endfor
stop
openw,1,'E:\RSI\misc\Qmie.txt'
printf,1,A_mei
close,1
stop
end




