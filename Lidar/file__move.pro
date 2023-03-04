pro file__move
;move files to a new location
Path1='f:\lidar_data\2007\Ap\'
path2=path1+'AP_tex'
dfile=path1+'t*'
Result = FILE_SEARCH(dfile)
help,result
s=size(result)
nf=strarr(s[1]+1)  ;number files
print,nf
stop
for k=1,s[1]-1 do begin
  nfile[k]=result[k-1]
endfor
stop

dfile=strarr(20)
mfile=strarr(20)
j=1

for j=1,s[1]/5 do begin
mfile[j]='e'+strmid(nfile[4+(j-1)*5],23,37)
dfile[j]='e'+strmid(nfile[5*j],23,37)
endfor
stop
m_data=transpose(mfile)
d_data=transpose(dfile)
stop

 m_dir='f:\lidar_data\2016\1019\P6_m'
 d_dir='f:\lidar_data\2016\1019\P6_d'
  ;FILE_MKDIR,'PPP'
 for L=1,10 do begin
   fnm='F:\lidar_data\2016\1019\'+mfile[L]
   fnd='F:\lidar_data\2016\1019\'+dfile[L]

   FILE_MOVE,fnm,m_dir; 'f:\lidar_data\no\'+mfile[L],m_dir
   FILE_MOVE,fnd,d_dir; 'f:\lidar_data\no\'+dfile[L],d_dir
 endfor
 stop


end

