pro lice_file_change
;; unfinished
Path1='f:\lidar_data\2007\AP\AP_tex\t*'

Result = FILE_SEARCH(Path1)
help,result
s=size(result)
nfile=strarr(s[1]+1)
for k=1,s[1] do begin
  nfile[k]=result[k-1]
endfor
;stop

dfile=strarr(20)
mfile=strarr(20)
j=1

for j=1,s[1]/2 do begin
mfile[j]='t'+strmid(nfile[4+(j-1)*5],23,37)
dfile[j]='t'+strmid(nfile[5*j],23,37)
endfor
stop
m_data=transpose(mfile)
d_data=transpose(dfile)

stop

 ;m_dir='f:\lidar_data\2007\JN_test\JN0100'
 ;d_dir='f:\lidar_data\2007\JN_test\JN0100'
  ;FILE_MKDIR,'PPP'
 for L=1,10 do begin
   fnm='F:\lidar_data\2007\AP_test\'+mfile[L]
   fnd='F:\lidar_data\2007\AP_test\'+dfile[L]

   FILE_MOVE,fnm,m_data[L]; 'f:\lidar_data\no\'+mfile[L],m_dir
   FILE_MOVE,fnd,d_data[L]; 'f:\lidar_data\no\'+dfile[L],d_dir
 endfor
 stop


end

