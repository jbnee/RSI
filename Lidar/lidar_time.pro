Pro lidar_time
m=10
nstep=10
Rtime=strarr(m)
Rh=fltarr(m)
 rmn=fltarr(m)
 rsec=fltarr(m)

;Rtime=['11.35.46',  '11.54.28',  '12.13.10', '12.31.52', '12.50.34', '13.09.16', '13.27.58']

 For  N=0,m-1 do begin
  ;read,ltime, prompt='enter time as 11.35.46
 ;rtime[n]=ltime
Rh[n]=strmid(Rtime[n],0,2)
rmn[n]=strmid(Rtime[n],3,2)
Rsec[n]=strmid(Rtime[n],6,2)
print,rtime[n],rh[n],rmn[n],rsec[n]
endfor
stop
for N2=1,n-1 do begin
dth=rh[n2]-rh[n2-1]
dtm=rmn[n2]-rmn[n2-1]
dsec=rsec[n2]-rsec[n2-1]
DT=dth*60*60+dtm*60+dsec
print,Dt/nstep
endfor
stop
end




