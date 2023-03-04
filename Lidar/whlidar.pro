pro WHlidar
close,/all
datas=fltarr(2,2048)
ht=fltarr(2048)
sms=fltarr(2048)
sig=fltarr(2048)
extn=fltarr(2048)
filenm1=''
filepass="d:\lidar systems\LidarPro\WuHan\WH_ASC\"
Read,filenm1, prompt='filename= as jn201220....'
fn=filenm1+'.dat'
 openr,1,filepass+fn
readf,1,datas
ht=datas[0,*]
sig=datas[1,*]
sms=smooth(sig,10)
;plot,sig,ht,background=-2,color=2,xrange=[0,20];psym=2
;stop
extn=(-0.5)*deriv(ht,sms)
;se=smooth(extn,10)
plot,Alog(sms),ht,background=-2,color=1;,psym=1
stop
;plot,500*extn,ht,background=-2,color=6,psym=2;xrange=[0,50]
smext=smooth(extn,10)
plot,smext[0:250],ht,color=0,background=-2
stop
close,1
end
